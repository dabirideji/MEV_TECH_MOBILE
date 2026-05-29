import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:mevtech/core/error/failure_response.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/core/storages/DatabaseHandler.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/data/generic_repository.dart';
import 'package:mevtech/data/paginated_model.dart';
import 'package:mevtech/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:mevtech/features/course/data/models/course-content-models/course_content_request.dart';
import 'package:mevtech/features/course/data/models/course-content-models/course_video_model.dart';
import 'package:mevtech/features/course/data/models/course-models/course_model.dart';
import 'package:mevtech/features/course/data/models/course-models/course_request.dart';

@singleton
class CourseRepository {
  CourseRepository(this.apiService);

  final ApiService apiService;

  final db = DatabaseHandler();

  Future<String> createCourse(CreateCourseRequest requestModel) async {
    final result = await apiService.multipartRequestCreate(
      'Course/CreateCourse',
      requestModel,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseModel>> getLocalCourses() async {
    final result = await db.getDbRecords('course');
    if (result.isNotEmpty) {
      final courses = result.map(CourseModel.fromMap).toList();
      return courses;
    }
    // return getCourses();
    return [];
  }

  Future<void> clearDB() async {
    await db.deleteDbRecords('course');
    await db.deleteDbRecords('courseCategory');
  }

  Future<List<CourseModel>> getCourses() async {
    final result = await apiService.getJsonRequest('Course/GetAllAsQueryable');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        await db.deleteDbRecords('course');
        final data = result['data'] as List<dynamic>;

        final courses = data
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();

        await db.insertDbRecord<CourseModel>('course', courses);

        return courses;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseModel> getCoursebyID(String id) async {
    final result = await apiService.getJsonRequest('Course/GetById/$id');
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return CourseModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseModel> updateCourse(
    UpdateCourseRequest requestModel,
    String id,
  ) async {
    final result = await apiService.multipartRequestUpdate(
      'Course/Update/$id',
      requestModel,
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final userInfo = data['userInformation'] as Map<String, dynamic>;
        return CourseModel.fromJson(userInfo);
      } else if (result is Map && result['status'] == true) {
        final course = await getCoursebyID(id);
        return course;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteCourses(String id) async {
    final result = await apiService.deleteJsonRequest('Course/Delete/$id');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Course Enrolment

  Future<CourseEnrollmentModel?> getCourseEnrollment({
    required String courseId,
    required String studentId,
    required Uri uri,
  }) async {
    final local = await db.getEnrollment(
      studentId: studentId,
      courseId: courseId,
    );
    if (local != null) {
      unawaited(refreshEnrolment(uri));
      return local;
    }

    final result = await fetchOdata<CourseEnrollmentModel>(
      url: uri,
      fromJson: CourseEnrollmentModel.fromJson,
    );

    if (result.isNotEmpty) {
      await db.saveEnrollment(result.first);
      final local = await db.getEnrollment(
        studentId: studentId,
        courseId: courseId,
      );
      return local;
    } else {
      return null;
    }
  }

  Future<void> refreshEnrolment(Uri uri) async {
    try {
      final result = await fetchOdata<CourseEnrollmentModel>(
        url: uri,
        fromJson: CourseEnrollmentModel.fromJson,
      );
      if (result.isNotEmpty) {
        await db.saveEnrollment(result.first);
      }
    } catch (_) {}
  }

  // wrapper methods

  Future<PaginatedResponse<T>> fetchPaginated<T>({
    required String endPoint,
    required int page,
    required int pageSize,
    required T Function(Map<String, dynamic>) fromJson,
    String token = '',
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getPaginated(page: page, pageSize: pageSize, token: token);
  }

  Future<List<T>> fetchAll<T>({
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
    String token = '',
    Map<String, String>? queryParams,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getAll(
      queryParams: queryParams,
      authRequired: authRequired,
      token: token,
    );
  }

  Future<T> fetchById<T>({
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    required String id,
    bool authRequired = true,
    String token = '',
    Map<String, String>? queryParams,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getById(
      id,
      queryParams: queryParams,
      authRequired: authRequired,
      token: token,
    );
  }

  Future<String> create<T>({
    required String endPoint,
    required Map<String, dynamic> jsonData,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.add(jsonData, authRequired: authRequired);
  }

  Future<T> update<T>({
    required String endPoint,
    required Map<String, dynamic> jsonData,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.edit(jsonData, id);
  }

  Future<String> delete<T>({
    required String endPoint,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.remove(id);
  }

  Future<List<T>> fetchOdata<T>({
    required Uri url,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
    String token = '',
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: '',
      fromJson: fromJson,
    );
    return repo.getOdata(url: url, authRequired: authRequired, token: token);
  }

  // Course Category

  Future<String> createCourseCategory(
    CourseCategoryCreateRequest requestModel,
  ) async {
    final result = await apiService.postJsonRequest(
      requestModel.toJson(),
      'CourseCategory/Create',
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseCategoryModel>> getLocalCourseCategory() async {
    final result = await db.getDbRecords('courseCategory');
    if (result.isNotEmpty) {
      final categories = result.map(CourseCategoryModel.fromMap).toList();
      return categories;
    }
    // return getCourseCategories();
    return [];
  }

  Future<List<CourseCategoryModel>> getCourseCategories() async {
    final result = await apiService.getJsonRequest(
      'CourseCategory/GetAllAsQueryable',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        await db.deleteDbRecords('courseCategory');
        final data = result['data'] as List<dynamic>;

        final categories = data
            .map((e) => CourseCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();

        await db.insertDbRecord<CourseCategoryModel>(
          'courseCategory',
          categories,
        );

        return categories;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseCategoryModel>> getCourseCategoriesAsQueryable() async {
    final result = await apiService.getJsonRequest('CourseCategory/GetAll');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseCategoryModel> getCourseCategorybyID(String id) async {
    final result = await apiService.getJsonRequest(
      'CourseCategory/GetById/$id',
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return CourseCategoryModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseCategoryModel> updateCourseCategory(
    CourseCategoryUpdateRequest requestModel,
    String id,
  ) async {
    final result = await apiService.updateJsonRequest(
      requestModel.toJson(),
      'CourseCategory/Update/$id',
    );

    if (result != null) {
      if (result is Map &&
          result['status'] == true &&
          (result.containsKey('data') && result['data'] != null)) {
        final data = result['data'] as Map<String, dynamic>;

        return CourseCategoryModel.fromJson(data);
      } else if (result is Map && result['status'] == true) {
        final course = await getCourseCategorybyID(id);
        return course;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteCourseCategory(String id) async {
    final result = await apiService.deleteJsonRequest(
      'CourseCategory/Delete/$id',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Course Tag

  Future<String> createCourseTag(CourseTagCreateRequest requestModel) async {
    final result = await apiService.postJsonRequest(
      requestModel.toJson(),
      'CourseTag/Create',
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseTagModel>> getCourseTags() async {
    final result = await apiService.getJsonRequest('CourseTag/GetAll');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseTagModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseTagModel>> getCourseTagsAsQueryable() async {
    final result = await apiService.getJsonRequest(
      'CourseTag/GetAllAsQueryable',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseTagModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseTagModel> getCourseTagbyID(String id) async {
    final result = await apiService.getJsonRequest('CourseTag/GetById/$id');
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return CourseTagModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseTagModel> updateCourseTag(
    CourseTagUpdateRequest requestModel,
    String id,
  ) async {
    final result = await apiService.updateJsonRequest(
      requestModel.toJson(),
      'CourseTag/Update/$id',
    );

    if (result != null) {
      if (result is Map &&
          result['status'] == true &&
          (result.containsKey('data') && result['data'] != null)) {
        final data = result['data'] as Map<String, dynamic>;

        return CourseTagModel.fromJson(data);
      } else if (result is Map && result['status'] == true) {
        final course = await getCourseTagbyID(id);
        return course;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteCourseTag(String id) async {
    final result = await apiService.deleteJsonRequest('CourseTag/Delete/$id');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Course Contents

  Future<List<CourseVideoModel>> getYoutubeVideos(String playlistId) async {
    final result = await apiService.youtubeVideoRequest(
      baseUrl: 'https://www.googleapis.com/youtube/v3/playlistItems',
      progLink:
          '?part=snippet&playlistId=$playlistId&key=$youtubeApiKey&maxResults=50',
    );
    if (result != null) {
      if (result is Map) {
        // final data = result['data'] as List<dynamic>;
        final items = result['items'] as List<dynamic>;

        return items
            .map((e) => CourseVideoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> createCourseContent(
    CreateCourseContentRequest requestModel,
  ) async {
    final result = await apiService.multipartCreateCourseContent(
      'CourseContent/CreateCourseContent',
      requestModel,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseContentModel>> getCoursesContents() async {
    final result = await apiService.getJsonRequest('CourseContent/GetAll');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseContentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseContentModel>> getCourseContentbyID(String courseId) async {
    final result = await apiService.getJsonRequest(
      'CourseContent/GetByCourseId/course/$courseId',
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseContentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseContentModel>> updateCourseContent(
    CourseContentUpdateRequest requestModel,
    String id,
  ) async {
    final result = await apiService.updateJsonRequest(
      requestModel.toJson(),
      'CourseContent/Update/$id',
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return [CourseContentModel.fromJson(data)];
      } else if (result is Map && result['status'] == true) {
        final courseContent = await getCourseContentbyID(id);
        return courseContent;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteCourseContent(String id) async {
    final result = await apiService.deleteJsonRequest(
      'CourseContent/Delete/$id',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // check if video is embededable

  Future<bool> checkEmbeded(String videoUrl) async {
    final result = await apiService.videoEmbedableRequest(videoUrl);
    if (result != null) {
      if (result is Map) {
        // final data = result['data'] as List<dynamic>;
        final items = result['items'] as List<dynamic>;
        final item = items[0] as Map<String, dynamic>;
        final status = item['status'] as Map<String, dynamic>;
        final embeddable = status['embeddable'] as bool;

        return embeddable;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // students course notes

  Future<String> createContentNote(Map<String, dynamic> jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      'StudentCourseContentNote/Create',
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseContentNoteModel>> getContentsNotes() async {
    final result = await apiService.getJsonRequest(
      'StudentCourseContentNote/GetAll',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map(
              (e) => CourseContentNoteModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // /api/StudentCourseContentNote/GetByCourseContentId/{studentId}

  Future<List<CourseContentNoteModel>> getContentNoteByCourseIdStudentId({
    required String courseContentId,
    required String studentId,
  }) async {
    final result = await apiService.getJsonRequest(
      // 'StudentCourseContentNote/GetByCourseContentId$studentId',
      'StudentCourseContentNote/GetByCourseContentId/$studentId/$courseContentId',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map(
              (e) => CourseContentNoteModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // students course comments

  Future<String> createContentComment(Map<String, dynamic> jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      'CourseContentComment/Create',
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<CourseContentCommentModel>> getContentsComment() async {
    final result = await apiService.getJsonRequest(
      'CourseContentComment/GetAllAsQueryable',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map(
              (e) =>
                  CourseContentCommentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // /api/CourseContentComment/GetByCourseContentId/{courseContentId}

  Future<List<CourseContentCommentModel>> getContentsCommentByContentId(
    String courseContentId,
  ) async {
    final result = await apiService.getJsonRequest(
      'CourseContentComment/GetByCourseContentId/$courseContentId',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map(
              (e) =>
                  CourseContentCommentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<PaginatedResponse<CourseContentCommentModel>>
  getContentsCommentPaginated({Map<String, dynamic>? queryParams}) async {
    final result = await apiService.getJsonRequest(
      'CourseContentComment/GetPaginatedData/paginate',
      queryParams: queryParams,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;

        return PaginatedResponse<CourseContentCommentModel>.fromJson(
          data,
          CourseContentCommentModel.fromJson,
        );
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }
}
