part of 'dashboard_cubit.dart';

enum LoadStatus { initial, loading, success, failure }

sealed class DashboardState extends Equatable {
  const DashboardState({
    this.courses = const [],
    this.categories = const [],
    this.courseStatus = LoadStatus.initial,
    this.categoryStatus = LoadStatus.initial,
    this.searchedCourses = const [],
    this.searchStatus = LoadStatus.initial,
    this.courseError,
    this.categoryError,
    this.searchError,
  });

  final List<CourseModel> courses;
  final List<CourseCategoryModel> categories;
  final LoadStatus courseStatus;
  final LoadStatus categoryStatus;
  final List<CourseModel> searchedCourses;
  final LoadStatus searchStatus;
  final String? courseError;
  final String? categoryError;
  final String? searchError;

  @override
  List<Object?> get props => [
        courses,
        categories,
        courseStatus,
        categoryStatus,
        courseError,
        categoryError,
        searchedCourses,
        searchStatus,
        searchError,
      ];
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess({
    super.courses,
    super.categories,
    super.courseStatus,
    super.categoryStatus,
    super.searchedCourses,
    super.searchStatus,
    super.courseError,
    super.categoryError,
    super.searchError,
  });

  DashboardSuccess copyWith({
    List<CourseModel>? courses,
    List<CourseCategoryModel>? categories,
    LoadStatus? courseStatus,
    LoadStatus? categoryStatus,
    List<CourseModel>? searchedCourses,
    LoadStatus? searchStatus,
    String? courseError,
    String? categoryError,
    String? searchError,
  }) {
    return DashboardSuccess(
      courses: courses ?? this.courses,
      categories: categories ?? this.categories,
      courseStatus: courseStatus ?? this.courseStatus,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      searchedCourses: searchedCourses ?? this.searchedCourses,
      searchStatus: searchStatus ?? this.searchStatus,
      courseError: courseError,
      categoryError: categoryError,
      searchError: searchError,
    );
  }

  // @override
  // List<Object?> get props => [
  //       courses,
  //       categories,
  //       courseStatus,
  //       categoryStatus,
  //       courseError,
  //       categoryError,
  //       searchedCourses,
  //       searchStatus,
  //       searchError,
  //     ];
}
