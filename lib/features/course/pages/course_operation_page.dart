import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class CourseOperationPage extends StatelessWidget {
  const CourseOperationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseCubit = context.read<CourseCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course Operations',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                courseCubit.clearField();
                context.pushNamed(AppRouter.createCourse);
              },
              icon: Icon(
                Icons.assignment_add,
                size: 35.r,
                color: AppColor.secondary,
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<CourseCubit, CourseState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CourseSuccess) {
            return CourseOperationCard(
              courses: state.courses,
              onTap: (id) {},
              onTapAddContent: (id) {
                // context.read<CourseCubit>().populateData(course);
                context.pushNamed(AppRouter.createCourseContent, extra: id);
              },
              onTapEdit: (id) {
                // context.read<CourseCubit>().populateData(course);
                context.pushNamed(AppRouter.editCourse, extra: id);
              },
              onTapDelete: (id) {
                confirmDialogue(context, id);
              },
            );
          }
          return const Center(
            child: Text('Error Fetching Course'),
          );
        },
      ),
    );
  }

  Future<dynamic> confirmDialogue(BuildContext context, String id) async {
    MevTechUtilities.showAnimatedAlert(
      context: context,
      message: 'Are you sure you want to delete this course',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      alignment: Alignment.bottomCenter,
      onConfirm: () {
        context.pop();
        context.read<CourseCubit>().deleteCourse(id);
      },
    );
  }
}
