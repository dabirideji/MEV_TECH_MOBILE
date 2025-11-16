import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/course-widget/youtube_video_card.dart';
import 'package:template/features/course/data/models/course-content-models/course_video_model.dart';
import 'package:template/features/course/logic/course-content-cubit/course_content_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class CourseContentlistPage extends StatefulWidget {
  const CourseContentlistPage({required this.courseId, super.key});
  final String courseId;

  @override
  State<CourseContentlistPage> createState() => _CourseContentlistPageState();
}

class _CourseContentlistPageState extends State<CourseContentlistPage> {
  @override
  void initState() {
    super.initState();
    // const playlistId = 'PLm8k6jTjMBQMDiCN-aAKeVqIsyyzyNCp6';
    context.read<CourseContentCubit>().fetchCourseContent(widget.courseId);
  }

  CourseVideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: AppColor.primary,
        title: Text(
          'course content List',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<CourseContentCubit, CourseContentState>(
        listener: (context, state) {
          if (state is CourseContentLoading) {
            // MevTechUtilities.showProgressIndicator(context);
          }

          if (state is CourseContentFailure) {
            // MevTechUtilities.hideProgressIndicator(context);
            MevTechUtilities.errorToast(context, state.errorMessage);
          }

          if (state is CourseContentSuccess) {
            // MevTechUtilities.hideProgressIndicator(context);
          }
          if (state is CourseContentSuccess && state.status.isDeleting) {
            MevTechUtilities.showProgressIndicator(context);
          }

          if (state is CourseContentSuccess && state.status.isDeleteFailure) {
            MevTechUtilities.hideProgressIndicator(context);
            MevTechUtilities.errorToast(
                context, state.status.error ?? 'unable to complete action');
          }

          if (state is CourseContentSuccess && state.status.isDeleteSuccess) {
            MevTechUtilities.hideProgressIndicator(context);
            MevTechUtilities.successToast(context, 'Succesfully deleted');
            context
                .read<CourseContentCubit>()
                .fetchCourseContent(widget.courseId);
          }
        },
        builder: (context, state) {
          if (state is CourseContentSuccess) {
            return Center(
              child: CourseContentListCard(
                courseContents: state.courseContentModel,
                onTap: (id) {
                  context.pushNamed(
                    AppRouter.courseContent,
                    extra: id,
                  );
                },
                onLongPress: (id) {
                  MevTechUtilities.showAnimatedAlert(
                      context: context,
                      message:
                          'Are you sure you want to delete the selected course content?',
                      onConfirm: () {
                        context.pop();
                        context
                            .read<CourseContentCubit>()
                            .deleteCourseContent(id);
                      });
                },
              ),
            );
          } else if (state is CourseContentLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.secondary,
                backgroundColor: AppColor.primary,
              ),
            );
          } else if (state is CourseContentFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.errorMessage,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextButton.icon(
                          onPressed: () {
                            context
                                .read<CourseContentCubit>()
                                .fetchCourseContent(widget.courseId);
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColor.secondary,
                          ),
                          label: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Unable to load item'),
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
        // context.read<CourseCubit>().deleteCourse(id);
      },
    );
  }
}
