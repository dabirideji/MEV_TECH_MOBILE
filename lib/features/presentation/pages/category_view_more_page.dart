import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/presentation/widgets/course.dart';

class CategoryViewMorePage extends StatelessWidget {
  const CategoryViewMorePage({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseCubit>().state;
    var categoryList = <CourseModel>[];
    if (state is CourseSuccess && category != Course.all) {
      for (final entry in state.categorizedCourses.entries) {
        final courses = entry.value;
        final match = courses
            .where((course) => course.categoryNames.contains(category))
            .toList();

        if (match.isNotEmpty) {
          categoryList = match;
          break; // Exit the loop once a match is found
        }
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
        body: CourseModelCard(
          courses: categoryList,
          onTap: (id) {
            context.pushNamed(AppRouter.courseDetails, extra: id);
          },
        ),
      );
    } else if (state is CourseSuccess && category == Course.all) {
      final allCategoryList = state.uncategorizedCourses;

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
        body: CourseModelCard(
          courses: allCategoryList,
          onTap: (id) {
            context.pushNamed(AppRouter.courseDetails, extra: id);
          },
        ),
      );
    }
    return const Scaffold(
      body: Center(
        child: Text('Unable to fetch category list'),
      ),
    );
  }
}
