import 'package:injectable/injectable.dart';
import 'package:template/core/error/failure_response.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/data/generic_repository.dart';
import 'package:template/data/paginated_model.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_request.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/data/models/course-models/course_request.dart';

@singleton
class CourseRepository {
  CourseRepository(this.apiService);

  final ApiService apiService;

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

  Future<List<CourseModel>> getCourses() async {
    final result = await apiService.getJsonRequest('Course/GetAllAsQueryable');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<CourseModel> getCoursebyID(String id) async {
    final result = await apiService.getJsonRequest(
      'Course/GetById/$id',
    );
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
    return repo.getPaginated(
      page: page,
      pageSize: pageSize,
      token: token,
    );
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
    return repo.getOdata(
      url: url,
      authRequired: authRequired,
      token: token,
    );
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

  Future<List<CourseCategoryModel>> getCourseCategories() async {
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

  Future<List<CourseCategoryModel>> getCourseCategoriesAsQueryable() async {
    final result =
        await apiService.getJsonRequest('CourseCategory/GetAllAsQueryable');
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
    final result =
        await apiService.deleteJsonRequest('CourseCategory/Delete/$id');
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

  Future<String> createCourseTag(
    CourseTagCreateRequest requestModel,
  ) async {
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
    final result =
        await apiService.getJsonRequest('CourseTag/GetAllAsQueryable');
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
    final result = await apiService.getJsonRequest(
      'CourseTag/GetById/$id',
    );
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

  Future<String> createCourseContent(
    CourseContentCreateRequest requestModel,
  ) async {
    final result = await apiService.postJsonRequest(
      requestModel.toJson(),
      'CourseContent/Create',
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
    final result =
        await apiService.deleteJsonRequest('CourseContent/Delete/$id');
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

  // students course notes

  Future<String> createContentNote(
    Map<String, dynamic> jsonData,
  ) async {
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
    final result =
        await apiService.getJsonRequest('StudentCourseContentNote/GetAll');
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

  Future<String> createContentComment(
    Map<String, dynamic> jsonData,
  ) async {
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
    final result = await apiService
        .getJsonRequest('CourseContentComment/GetAllAsQueryable');
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
        queryParams: queryParams);
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
