import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/data/odata_query_builder.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_request.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/data/models/course-models/course_request.dart';
import 'package:template/features/course/data/repository/course_repository.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/presentation/widgets/course.dart';

part 'course_state.dart';

@injectable
class CourseCubit extends Cubit<CourseState> {
  CourseCubit(this.courseRepository) : super(CourseInitial.initial());

  final CourseRepository courseRepository;
  // File? file;
  dynamic successState;

  TextEditingController name = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  String courseImageUrl = '';
  String courseId = '';

  List<Course> myList = [];

  List<CourseCategoryModel>? categoryModel;

  // ==== Other Course Fetaures Fields===

  TextEditingController txtCategoryName = TextEditingController();
  TextEditingController txtCategoryDescription = TextEditingController();
  TextEditingController txtTagName = TextEditingController();
  TextEditingController txtTagDescription = TextEditingController();

  Future<void> onCreate() async {
    await fetchCourses();
  }

  void clearField() {
    name.clear();
    title.clear();
    description.clear();
    imageUrl.clear();
    courseImageUrl = '';
    courseId = '';
  }

  void toggleMenu(String category) {
    if (state is CourseSuccess) {
      final current = state as CourseSuccess;
      final currentMap = Map<String, bool>.from(current.isMenuExpanded);
      currentMap[category] = !(currentMap[category] ?? false);

      emit(
        current.copyWith(isMenuExpanded: currentMap),
      );
    }
  }

  Future<void> populateData({
    CourseModel? course,
    List<String> tags = const [],
    List<String> categories = const [],
  }) async {
    if (state is CourseSuccess) {
      final current = state as CourseSuccess;

      courseImageUrl = '';
      courseId = '';

      if (course != null) {
        courseId = course.id;
        name.text = course.courseName;
        title.text = course.courseTitle;
        description.text = course.description;
        imageUrl.text = course.courseImageUrl;
        categories.addAll(course.categoryNames);
        tags.addAll(course.tagNames);

        // emit(
        //   current.copyWith(
        //     file: file,
        //     isUpdating: false,
        //     updateErrorMessage: '',
        //     updateSuccessMessage: '',
        //   ),
        // );
      }
    }
  }

  Future<void> refreshCourses() async {
    try {
      if (state is! CourseSuccess) return;

      emit((state as CourseSuccess).copyWith(courseRefreshError: ''));

      final result = await courseRepository.getCourses();

      if (result.isNotEmpty) {
        if (!isClosed) {
          // emit((state as CourseSuccess).copyWith(courses: result));
          emit(CourseSuccess(courses: result, isMenuExpanded: const {}));

          if (state is CourseSuccess) {
            successState = state as CourseSuccess;
          }
        }
      } else {
        if (!isClosed) {
          emit(
            (state as CourseSuccess)
                .copyWith(courseRefreshError: 'unable to fetch course'),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          (state as CourseSuccess).copyWith(courseRefreshError: e.toString()),
        );
      }
    }
  }

  Future<void> testGetCourse() async {
    // 84507269-f31b-4e82-8483-1002c464df7b
    // 1c146df3-a881-4c7b-b59c-224df103a5a3
    final result = await courseRepository
        .getCoursebyID('84507269-f31b-4e82-8483-1002c464df7b');
    log(result.categoryNames.isNotEmpty
        ? result.categoryNames.first
        : 'not category found');
  }

  Future<void> fetchCourses() async {
    try {
      if (!isClosed) {
        emit(const CourseLoading());
      }

      final result = await courseRepository.getCourses();
      if (result.isNotEmpty) {
        // final data = [result[0], result[1]];
        if (!isClosed) {
          emit(CourseSuccess(courses: result, isMenuExpanded: const {}));
          if (state is CourseSuccess) {
            successState = state as CourseSuccess;
          }
        }
      } else {
        if (!isClosed) {
          emit(const CourseFailure('unable to fetch course'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(CourseFailure(e.toString()));
      }
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      if (state is! CourseSuccess) return;
      emit(
        (state as CourseSuccess)
            .copyWith(isDeleting: true, deleteErrorMessage: ''),
      );

      final result = await courseRepository.deleteCourses(id);

      if (result.isNotEmpty) {
        emit((state as CourseSuccess).copyWith(isDeleting: false));
        emit(CourseDeletedSuccess(result));
      } else {
        emit(
          (state as CourseSuccess).copyWith(
            deleteErrorMessage: 'An Error Has Occured',
            isDeleting: false,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as CourseSuccess).copyWith(
          deleteErrorMessage: e.toString(),
          isDeleting: false,
        ),
      );
    }
  }

  Future<void> updateCourse({required String id, String? categoryId}) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.updating,
      routeName: AppRouter.editCourse,
    ));

    try {
      final jsonData = UpdateCourseRequest(
        courseName: name.text,
        courseTitle: title.text,
        description: description.text,
        isFree: true,
        courseImageUrl: imageUrl.text,
        categories: [categoryId ?? ''],
      );

      final updatedCourse = await courseRepository.updateCourse(jsonData, id);

      final updatedList = current.courses.map((course) {
        return course.id == updatedCourse.id ? updatedCourse : course;
      }).toList();

      emit(
        current.copyWith(
          actionMethod: ActionMethod.updated,
          routeName: AppRouter.editCourse,
          courses: updatedList,
        ),
      );
      clearField();
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notUpdated,
        routeName: AppRouter.editCourse,
        message: e.toString(),
      ));
    }
  }

// 41c59c61-46a6-43eb-995d-8978dc667e07
  Future<void> updateCourseOld({
    required String id,
  }) async {
    if (state is! CourseSuccess) return;
    try {
      emit(
        (state as CourseSuccess).copyWith(
          isUpdating: true,
          updateErrorMessage: '',
          updateSuccessMessage: '',
        ),
      );

      final jsonData = UpdateCourseRequest(
        id: id,
        courseName: name.text,
        courseTitle: title.text,
        description: description.text,
        isFree: true,
        courseImageUrl: courseImageUrl,
      );

      final updatedCourse = await courseRepository.updateCourse(jsonData, id);

      if (state is CourseSuccess) {
        final currentState = state as CourseSuccess;

        final updatedList = currentState.courses.map((course) {
          return course.id == updatedCourse.id ? updatedCourse : course;
        }).toList();

        emit(
          (state as CourseSuccess).copyWith(
            courses: updatedList,
            isUpdating: false,
            updateErrorMessage: '',
            updateSuccessMessage: 'Course Updated Successfuly',
          ),
        );

        clearField();
      }

      emit(
        (state as CourseSuccess).copyWith(
          isUpdating: false,
          updateErrorMessage:
              'Please select a file to continue creating your course',
          updateSuccessMessage: '',
        ),
      );
    } catch (e) {
      emit(
        (state as CourseSuccess).copyWith(
          isUpdating: false,
          updateErrorMessage: e.toString(),
          updateSuccessMessage: '',
        ),
      );
    }
  }

  void updateSingleCourse(CourseModel updatedCourse) {
    if (state is CourseSuccess) {
      final currentState = state as CourseSuccess;

      final updatedList = currentState.courses.map((course) {
        return course.id == updatedCourse.id ? updatedCourse : course;
      }).toList();

      emit(currentState.copyWith(courses: updatedList));
    }
  }

  Future<void> createCourseOld(File? file) async {
    try {
      emit(const CourseLoading(actionType: CourseActionType.createCourse));

      if (file != null) {
        final course = CreateCourseRequest(
          courseName: name.text,
          courseTitle: title.text,
          description: description.text,
          isFree: true,
          courseImageUrl: imageUrl.text,
          courseImageFile: file,
          instructorId: MevTechUtilities.id,
        );

        emit(const CourseLoading(actionType: CourseActionType.createCourse));

        final result = await courseRepository.createCourse(course);

        emit(CourseCreateSuccess(result));

        clearField();
      } else {
        emit(
          const CourseFailure(
            'Please select a file to continue creating your course',
            actionType: CourseActionType.createCourse,
          ),
        );
      }
    } catch (e) {
      emit(
        CourseFailure(e.toString(), actionType: CourseActionType.createCourse),
      );
    }
  }

  Future<void> createCourse({
    required List<String> categoryNames,
    required List<String> tagNames,
  }) async {
    try {
      emit(const CourseLoading(actionType: CourseActionType.createCourse));

      final thumbnailUrl = getYouTubeThumbnail(imageUrl.text);
      // log(thumbnailUrl);

      final course = CreateCourseRequest(
        courseName: name.text,
        courseTitle: title.text,
        description: description.text,
        courseImageUrl: thumbnailUrl,
        isFree: true,
        instructorId: MevTechUtilities.id,
      );

      emit(const CourseLoading(actionType: CourseActionType.createCourse));

      final result = await courseRepository.createCourse(course);

      emit(CourseCreateSuccess(result));

      clearField();
    } catch (e) {
      emit(
        CourseFailure(e.toString(), actionType: CourseActionType.createCourse),
      );
    }
  }

  void clearTempData() {
    if (successState != null && successState is CourseSuccess) {
      emit(
        CourseSuccess(
          courses: (successState as CourseSuccess).courses,
          isMenuExpanded: const {},
          file: (successState as CourseSuccess).file,
        ),
      );
    }
  }

  // course content create

  Future<void> createCourseContent({
    required String courseContentCourseId,
    required String courseContentTitle,
    required String courseContentDescription,
    required String courseContentVideoUrl,
    required String courseContentSummary,
    required String courseContentTranscript,
    required File? courseContentThumbnailFile,
    required String courseContentThumbnailUrl,
    required int order,
    required bool isPreview,
    required bool isFree,
  }) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;

    try {
      final courseContent = CreateCourseContentRequest(
        courseContentCourseId: courseContentCourseId,
        courseContentTitle: courseContentTitle,
        courseContentDescription: courseContentDescription,
        courseContentVideoUrl: courseContentVideoUrl,
        courseContentSummary: courseContentSummary,
        courseContentTranscript: courseContentTranscript,
        order: order,
        isPreview: isPreview,
        isFree: isFree,
      );
      emit(current.copyWith(
        actionMethod: ActionMethod.creating,
        routeName: AppRouter.createCourseContent,
      ));

      final result = await courseRepository.createCourseContent(courseContent);

      emit(current.copyWith(
        actionMethod: ActionMethod.created,
        routeName: AppRouter.createCourseContent,
        message: result,
      ));

      clearField();
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notCreated,
        routeName: AppRouter.createCourseContent,
        message: e.toString(),
      ));
    }
  }

  Future<void> checkIfEmbedable(String videoUrl) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    try {
      emit(current.copyWith(
        actionMethod: ActionMethod.fetching,
        routeName: AppRouter.createCourseContent,
      ));

      final result = await courseRepository.checkEmbeded(videoUrl);

      emit(current.copyWith(
        isVideoEmbeddable: result,
        actionMethod: ActionMethod.fetched,
        routeName: AppRouter.createCourseContent,
      ));
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.fetched,
        routeName: AppRouter.createCourseContent,
      ));
    }
  }

  void resetState() {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(CourseSuccess(
        courses: current.courses, isMenuExpanded: current.isMenuExpanded));
  }

  Future<File?> getImageFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      return file;
    } else {
      return null;
    }
  }

  Future<void> compresseAndGetImage() async {
    if (state is CourseSuccess) {
      final current = state as CourseSuccess;
      try {
        final image = await getImageFile();

        if (image != null) {
          final result = await FlutterImageCompress.compressAndGetFile(
            image.absolute.path,
            '${image.path}.jpg',
            quality: 5,
          );
          if (result != null) {
            final file = File(result.path);

            emit(current.copyWith(file: file));
          } else {
            emit(current.copyWith(imageText: 'An Error Occured'));
          }
        } else {
          emit(current.copyWith(imageText: 'Image Not Select'));
          // debugPrint(current.imageText);
        }
      } catch (e) {
        emit(current.copyWith(imageText: e.toString()));
      }
    }
  }

  String getYouTubeThumbnail(String url) {
    final uri = Uri.parse(url);

    String? videoId;

    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.first;
    } else if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];
    }

    if (videoId == null || videoId.isEmpty) {
      throw Exception('Invalid YouTube URL: video ID not found');
    }

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  // treat this part, its throwing errors
  Future<File?> getImageFileFromUrl(String imageUrl) async {
    try {
      final cacheManager = DefaultCacheManager();
      final fileInfo = await cacheManager.getFileFromCache(imageUrl);

      if (fileInfo != null && fileInfo.file.existsSync()) {
        return fileInfo.file;
      } else {
        final file = await cacheManager.getSingleFile(imageUrl);
        return file;
      }
    } catch (e) {
      return null;
    }
  }

  // ================== Course Category Section ==================

  Future<void> loadCoursesAndCategories() async {
    try {
      if (!isClosed) {
        emit(const CourseLoading(
            actionType: CourseActionType.getCourseCategory));
      }

      final categories = await courseRepository.fetchAll<CourseCategoryModel>(
        endPoint: 'CourseCategory/GetAllAsQueryable',
        fromJson: CourseCategoryModel.fromJson,
      );

      categoryModel = categories;

      final courses = await courseRepository.getCourses();

      final categorized = <CourseCategoryModel, List<CourseModel>>{};
      final uncategorized = <CourseModel>[];

      for (final category in categories) {
        final matchedCourses = courses
            .where(
              (course) => course.categoryNames.contains(category.categoryName),
            )
            .toList();

        if (matchedCourses.isNotEmpty) {
          categorized[category] = matchedCourses;
        }
      }

      for (final course in courses) {
        final hasCategory = course.categoryNames.isNotEmpty &&
            course.categoryNames.any(
              (catName) =>
                  categories.map((cat) => cat.categoryName).contains(catName),
            );
        // final hasCategory = course.categoryNames
        //     .where((catName) => catName.toString().trim().isNotEmpty)
        //     .any((catName) => categories.any((cat) =>
        //         cat.categoryName.trim().toLowerCase() ==
        //         catName.toString().trim().toLowerCase()));

        if (!hasCategory) {
          uncategorized.add(course);
        }
      }

      if (!isClosed) {
        emit(
          CourseSuccess(
              courses: const [],
              isMenuExpanded: const {},
              categorizedCourses: categorized,
              uncategorizedCourses: uncategorized,
              actionType: CourseActionType.getCourseCategory),
        );
        if (state is CourseSuccess) {
          successState = state as CourseSuccess;
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(CourseFailure(e.toString(),
            actionType: CourseActionType.getCourseCategory));
      }
    }
  }

  Future<void> createCourseCategory({
    required String categoryName,
    required String categoryDescription,
  }) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.creating,
      routeName: AppRouter.courseCategorySettings,
    ));

    try {
      final model = CourseCategoryModel(
        categoryName: categoryName,
        categoryDescription: categoryDescription,
        categoryImageUrl: '',
      );

      final result = await courseRepository.create<CourseCategoryModel>(
        endPoint: 'CourseCategory/Create',
        jsonData: model.toJson(),
        fromJson: CourseCategoryModel.fromJson,
      );

      emit(current.copyWith(
        actionMethod: ActionMethod.created,
        routeName: AppRouter.courseCategorySettings,
        message: result,
      ));
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notCreated,
        routeName: AppRouter.courseCategorySettings,
        message: e.toString(),
      ));
    }
  }

  Future<void> deleteCourseCategory(String id) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.deleting,
      routeName: AppRouter.courseCategorySettings,
    ));

    try {
      final result = await courseRepository.delete<CourseCategoryModel>(
        endPoint: 'CourseCategory/Delete',
        id: id,
        fromJson: CourseCategoryModel.fromJson,
      );

      emit(current.copyWith(
        actionMethod: ActionMethod.deleted,
        routeName: AppRouter.courseCategorySettings,
        message: result,
      ));
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notDeleted,
        routeName: AppRouter.courseCategorySettings,
        message: e.toString(),
      ));
    }
  }

  Future<void> fetchAllCourseCategory() async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;

    try {
      emit(current.copyWith(
        actionMethod: ActionMethod.fetching,
        routeName: AppRouter.editCourse,
      ));

      final result = await courseRepository.fetchAll<CourseCategoryModel>(
        endPoint: 'CourseCategory/GetAllAsQueryable',
        fromJson: CourseCategoryModel.fromJson,
      );

      emit(
        current.copyWith(
          actionMethod: ActionMethod.fetched,
          routeName: AppRouter.editCourse,
          categories: result,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          actionMethod: ActionMethod.notFetched,
          routeName: AppRouter.editCourse,
          message: e.toString(),
        ),
      );
    }
  }

  // course tags

  Future<void> createCourseTags({
    required String tagName,
    required String tagDescription,
  }) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.creating,
      routeName: AppRouter.courseCategorySettings,
    ));

    try {
      final model = CourseTagModel(
        tagName: tagName,
        tagDescription: tagDescription,
      );

      final result = await courseRepository.create<CourseTagModel>(
        endPoint: 'CourseTag/Create',
        jsonData: model.toJson(),
        fromJson: CourseTagModel.fromJson,
      );

      emit(current.copyWith(
        actionMethod: ActionMethod.created,
        routeName: AppRouter.courseCategorySettings,
        message: result,
      ));
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notCreated,
        routeName: AppRouter.courseCategorySettings,
        message: e.toString(),
      ));
    }
  }

  // course enrollment

  Future<void> createCourseEnrollment({
    required String courseId,
    required String studentId,
  }) async {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.creating,
      routeName: AppRouter.courseDetails,
    ));

    try {
      final jsonData = <String, dynamic>{
        'courseId': courseId,
        'studentId': studentId,
      };

      final result = await courseRepository.create<CourseEnrollmentModel>(
        endPoint: 'CourseEnrollment/Create',
        jsonData: jsonData,
        fromJson: CourseEnrollmentModel.fromJson,
      );

      emit(current.copyWith(
        actionMethod: ActionMethod.created,
        routeName: AppRouter.courseDetails,
        message: result,
      ));

      unawaited(
          fetchCourseEnrollment(courseId: courseId, studentId: studentId));
    } catch (e) {
      emit(current.copyWith(
        actionMethod: ActionMethod.notCreated,
        routeName: AppRouter.courseDetails,
        message: e.toString(),
      ));
    }
  }

  void checkState(
      {List<CourseModel>? courses, List<CourseModel>? categorizedCourses}) {
    if (state is! CourseSuccess) {
      emit(CourseSuccess(courses: courses ?? [], isMenuExpanded: const {}));
    } else {
      final current = state as CourseSuccess;
      if (current.courses.isEmpty) {}
    }
  }

  Future<void> fetchCourseEnrollment({
    required String courseId,
    required String studentId,
  }) async {
    // _currentSearchId++;
    // final searchId = _currentSearchId;

    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    try {
      const endPoint = 'CourseEnrollment/GetOData/odata';

      final queryBuilder =
          ODataQueryBuilder(baseUrl: '${ApiService.baseUrlAddress}/$endPoint');

      final uri = queryBuilder
          .filter('studentId eq $studentId and courseId eq $courseId')
          .build();

      if (!isClosed) {
        emit(current.copyWith(
          actionMethod: ActionMethod.fetching,
          routeName: AppRouter.courseDetails,
        ));
      }

      final result = await courseRepository.fetchOdata<CourseEnrollmentModel>(
        url: uri,
        fromJson: CourseEnrollmentModel.fromJson,
      );

      if (!isClosed) {
        emit(current.copyWith(
          actionMethod: ActionMethod.fetched,
          routeName: AppRouter.courseDetails,
          courseEnrollment: result.first,
        ));
      }

      // if (searchId == _currentSearchId) {

      // }
    } catch (e) {
      if (!isClosed) {
        emit(current.copyWith(
          actionMethod: ActionMethod.notFetched,
          routeName: AppRouter.courseDetails,
          message: e.toString(),
        ));
      }
    }
  }

  void resetRoute() {
    if (state is! CourseSuccess) return;
    final current = state as CourseSuccess;
    emit(current.copyWith(
      actionMethod: ActionMethod.initial,
      routeName: AppRouter.course,
      message: '',
    ));
  }
}
