import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/logic/selected_course_cubit.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';

class DashboardCoursCategory extends StatelessWidget {
  const DashboardCoursCategory({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    var categoryList = <CourseModel>[];
    if (state is DashboardSuccess) {
      final match = state.courses
          .where((course) => course.categoryNames.contains(category))
          .toList();

      if (match.isNotEmpty) {
        categoryList = match;
      }

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.primary,
          ),
          title: Text(
            category,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: Colors.black87,
            ),
          ),
        ),
        body: categoryList.isNotEmpty
            ? CourseModelCard(
                courses: categoryList,
                onTap: (course) {
                  context.read<SelectedCourseCubit>().selectCourse(course);

                  context.pushNamed(
                    AppRouter.courseDetails,
                    pathParameters: {'id': course.id},
                  );
                },
              )
            : const Center(
                child: Text('No Courses found for the selected category'),
              ),
      );
    }
    return const Scaffold(
      body: Center(
        child: Text('No Courses found for the selected category'),
      ),
    );
  }
}
