import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/features/course/data/models/course-models/course_model.dart';

@injectable
class SelectedCourseCubit extends Cubit<CourseModel?> {
  SelectedCourseCubit() : super(null);
  void selectCourse(CourseModel course) => emit(course);
}
