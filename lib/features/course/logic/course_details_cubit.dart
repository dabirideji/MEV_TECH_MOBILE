import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/core/utils/request_states.dart';
import 'package:template/data/odata_query_builder.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/data/repository/course_repository.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

sealed class CourseDetailsState extends Equatable {
  const CourseDetailsState();
  @override
  List<Object?> get props => [];
}

final class CourseDetailsInitial extends CourseDetailsState {}

final class CourseDetailsLoading extends CourseDetailsState {}

final class CourseDetailsSuccess extends CourseDetailsState {
  const CourseDetailsSuccess(
    this.course, {
    this.fetchStatus = const RequestState.initial(),
    this.createStatus = const RequestState.initial(),
    this.message = '',
    this.courseEnrollment,
  });

  final CourseModel course;
  final RequestState fetchStatus;
  final RequestState createStatus;
  final String message;
  final CourseEnrollmentModel? courseEnrollment;

  CourseDetailsSuccess copyWith({
    CourseModel? course,
    RequestState? fetchStatus,
    RequestState? createStatus,
    String? message,
    CourseEnrollmentModel? courseEnrollment,
  }) {
    return CourseDetailsSuccess(
      course ?? this.course,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      createStatus: createStatus ?? this.createStatus,
      message: message ?? this.message,
      courseEnrollment: courseEnrollment,
    );
  }

  @override
  List<Object?> get props =>
      [course, fetchStatus, createStatus, message, courseEnrollment];
}

final class CourseDetailsFailure extends CourseDetailsState {
  const CourseDetailsFailure(this.errorMessage);

  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

@injectable
class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit(this.courseRepository) : super(CourseDetailsInitial());
  final CourseRepository courseRepository;

  void loadFromMemory(CourseModel course) {
    emit(CourseDetailsSuccess(course));
  }

  Future<void> fetchCourseById(String id) async {
    emit(CourseDetailsLoading());
    try {
      final course = await courseRepository.getCoursebyID(id);
      emit(CourseDetailsSuccess(course));
    } catch (e) {
      emit(CourseDetailsFailure(e.toString()));
    }
  }

  // course enrollment

  void resetState() {
    if (state is! CourseDetailsSuccess) return;
    final current = state as CourseDetailsSuccess;
    emit(current.copyWith(
      createStatus: const RequestState.initial(),
      fetchStatus: const RequestState.initial(),
      message: '',
    ));
  }

  Future<void> createCourseEnrollment({
    required String courseId,
    required String studentId,
  }) async {
    if (state is! CourseDetailsSuccess) return;
    final current = state as CourseDetailsSuccess;
    emit(current.copyWith(createStatus: const RequestState.loading()));

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
        createStatus: const RequestState.success(),
        message: result,
      ));

      unawaited(
          fetchCourseEnrollment(courseId: courseId, studentId: studentId));
    } catch (e) {
      emit(current.copyWith(
        createStatus: RequestState.failure(e.toString()),
      ));
    }
  }

  Future<void> fetchCourseEnrollment({
    required String courseId,
    required String studentId,
  }) async {
    // _currentSearchId++;
    // final searchId = _currentSearchId;
    resetState();

    if (state is! CourseDetailsSuccess) return;
    final current = state as CourseDetailsSuccess;
    try {
      const endPoint = 'CourseEnrollment/GetOData/odata';

      final queryBuilder =
          ODataQueryBuilder(baseUrl: '${ApiService.baseUrlAddress}/$endPoint');

      final uri = queryBuilder
          .filter('studentId eq $studentId and courseId eq $courseId')
          .build();

      if (!isClosed) {
        emit(current.copyWith(fetchStatus: const RequestState.loading()));
      }

      final result = await courseRepository.fetchOdata<CourseEnrollmentModel>(
        url: uri,
        fromJson: CourseEnrollmentModel.fromJson,
      );

      if (!isClosed) {
        emit(current.copyWith(
          fetchStatus: const RequestState.success(),
          courseEnrollment: result.first,
        ));
      }

      // if (searchId == _currentSearchId) {

      // }
    } catch (e) {
      if (!isClosed) {
        emit(current.copyWith(
          fetchStatus: RequestState.failure(e.toString()),
        ));
      }
    }
  }
}
