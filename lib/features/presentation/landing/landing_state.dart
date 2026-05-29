part of 'landing_cubit.dart';

sealed class LandingState extends Equatable {
  const LandingState();

  @override
  List<Object> get props => [];
}

final class LandingInitial extends LandingState {
  const LandingInitial({required this.courses});

  factory LandingInitial.initial() {
    return const LandingInitial(
      courses: [],
    );
  }

  final List<Course> courses;
}

final class LandingLoading extends LandingState {}

final class LandingSuccess extends LandingState {
  const LandingSuccess(
    this.successMessage, {
    required this.courses,
    required this.courses2,
    required this.combineCourse,
    this.isMenuExpanded = false,
  });

  final String successMessage;
  final List<Course> courses;
  final List<Course> courses2;
  final List<Course> combineCourse;
  final bool isMenuExpanded;

  LandingSuccess copyWith({
    String? successMessage,
    List<Course>? courses,
    List<Course>? courses2,
    List<Course>? combineCourse,
    bool? isMenuExpanded,
  }) {
    return LandingSuccess(
      successMessage ?? this.successMessage,
      courses: courses ?? this.courses,
      courses2: courses2 ?? this.courses2,
      combineCourse: combineCourse ?? this.combineCourse,
      isMenuExpanded: isMenuExpanded ?? this.isMenuExpanded,
    );
  }

  @override
  List<Object> get props => [
        successMessage,
        courses,
        courses2,
        combineCourse,
        isMenuExpanded,
      ];
}

final class LandingFailure extends LandingState {
  const LandingFailure(this.errorMessage);

  final String errorMessage;
}
