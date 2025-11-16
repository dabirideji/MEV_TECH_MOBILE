part of 'course_cubit.dart';

enum CourseActionType {
  getCourse,
  createCourse,
  updateCourse,
  deleteCourse,
  getCourseCategory,
  createCourseCategory,
  updateCourseCategory,
  deleteCourseCategory,
}

enum ActionMethod {
  initial,
  fetching,
  fetched,
  notFetched,
  creating,
  created,
  notCreated,
  updating,
  updated,
  notUpdated,
  deleting,
  deleted,
  notDeleted
}

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

final class CourseInitial extends CourseState {
  const CourseInitial({required this.courses});
  factory CourseInitial.initial() {
    return const CourseInitial(
      courses: [],
    );
  }

  final List<Course> courses;
}

final class CourseLoading extends CourseState {
  const CourseLoading({this.actionType = CourseActionType.getCourse});

  final CourseActionType actionType;
}

final class CourseMockSuccess extends CourseState {
  const CourseMockSuccess({required this.courses});

  final List<CourseModel> courses;
}

final class CourseCreateSuccess extends CourseState {
  const CourseCreateSuccess(this.message);

  final String message;
}

final class CourseUpdateSuccess extends CourseState {
  const CourseUpdateSuccess(this.message);

  final String message;
}

final class CourseDeletedSuccess extends CourseState {
  const CourseDeletedSuccess(this.message);

  final String message;
}

final class CourseSuccess extends CourseState {
  const CourseSuccess({
    required this.courses,
    required this.isMenuExpanded,
    this.message,
    this.file,
    this.actionType = CourseActionType.getCourse,
    this.imageText,
    this.isDeleting = false,
    this.deleteErrorMessage,
    this.isUpdating = false,
    this.isCreating = false,
    this.updateSuccessMessage = '',
    this.updateErrorMessage,
    this.courseRefreshError = '',
    this.categorizedCourses = const {},
    this.uncategorizedCourses = const [],
    this.actionMethod = ActionMethod.initial,
    this.routeName = AppRouter.course,
    this.categories = const [],
    this.tags = const [],
    this.courseEnrollment,
    this.isVideoEmbeddable = false,
  });

  final List<CourseModel> courses;
  final Map<String, bool> isMenuExpanded;
  final String? message;
  final File? file;
  final CourseActionType actionType;
  final String? imageText;
  final bool isDeleting;
  final String? deleteErrorMessage;
  final bool isUpdating;
  final bool isCreating;
  final String updateSuccessMessage;
  final String? updateErrorMessage;
  final String courseRefreshError;
  final Map<CourseCategoryModel, List<CourseModel>> categorizedCourses;
  final List<CourseModel> uncategorizedCourses;
  final ActionMethod actionMethod;
  final String routeName;
  final List<CourseCategoryModel> categories;
  final List<CourseTagModel> tags;
  final CourseEnrollmentModel? courseEnrollment;
  final bool isVideoEmbeddable;

  CourseSuccess copyWith({
    List<CourseModel>? courses,
    Map<String, bool>? isMenuExpanded,
    String? message,
    File? file,
    CourseActionType? actionType,
    String? imageText,
    bool? isDeleting,
    String? deleteErrorMessage,
    bool? isUpdating,
    bool? isCreating,
    String? updateSuccessMessage,
    String? updateErrorMessage,
    String? courseRefreshError,
    Map<CourseCategoryModel, List<CourseModel>>? categorizedCourses,
    List<CourseModel>? uncategorizedCourses,
    ActionMethod? actionMethod,
    String? routeName,
    List<CourseCategoryModel>? categories,
    List<CourseTagModel>? tags,
    CourseEnrollmentModel? courseEnrollment,
    bool? isVideoEmbeddable,
  }) {
    return CourseSuccess(
      courses: courses ?? this.courses,
      isMenuExpanded: isMenuExpanded ?? this.isMenuExpanded,
      message: message ?? this.message,
      file: file ?? this.file,
      actionType: actionType ?? this.actionType,
      imageText: imageText ?? this.imageText,
      isDeleting: isDeleting ?? this.isDeleting,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
      updateSuccessMessage: updateSuccessMessage ?? this.updateSuccessMessage,
      updateErrorMessage: updateErrorMessage ?? this.updateErrorMessage,
      courseRefreshError: courseRefreshError ?? this.courseRefreshError,
      categorizedCourses: categorizedCourses ?? this.categorizedCourses,
      uncategorizedCourses: uncategorizedCourses ?? this.uncategorizedCourses,
      isCreating: isCreating ?? this.isCreating,
      actionMethod: actionMethod ?? this.actionMethod,
      routeName: routeName ?? this.routeName,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      courseEnrollment: courseEnrollment ?? this.courseEnrollment,
      isVideoEmbeddable: isVideoEmbeddable ?? this.isVideoEmbeddable,
    );
  }

  @override
  List<Object?> get props => [
        courses,
        isMenuExpanded,
        message ?? '',
        file ?? '',
        actionType,
        imageText ?? '',
        isDeleting,
        deleteErrorMessage ?? '',
        isUpdating,
        updateSuccessMessage,
        updateErrorMessage ?? '',
        courseRefreshError,
        categorizedCourses,
        uncategorizedCourses,
        isCreating,
        actionMethod,
        routeName,
        categories,
        tags,
        courseEnrollment,
        isVideoEmbeddable,
      ];
}

final class CourseFailure extends CourseState {
  const CourseFailure(
    this.errorMessage, {
    this.actionType = CourseActionType.getCourse,
  });

  final String errorMessage;
  final CourseActionType actionType;

  @override
  List<Object> get props => [errorMessage, actionType];
}
