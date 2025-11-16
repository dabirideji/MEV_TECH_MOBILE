import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';

@lazySingleton
class SelectedCourseCubit extends Cubit<CourseModel?> {
  SelectedCourseCubit() : super(null);
  void selectCourse(CourseModel course) => emit(course);
}
