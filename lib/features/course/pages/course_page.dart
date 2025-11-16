import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/course/logic/selected_course_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().onCreate();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) {
        if (current is CourseLoading &&
            current.actionType == CourseActionType.getCourse) {
          return true;
        }
        if (current is CourseSuccess &&
            current.actionType == CourseActionType.getCourse) {
          return true;
        }
        if (current is CourseFailure &&
            current.actionType == CourseActionType.getCourse) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CourseLoading) {
          // MevTechUtilities.progressIndicator(context);
        } else if (state is CourseFailure) {
          MevTechUtilities.errorToast(context, state.errorMessage);
        } else if (state is CourseSuccess &&
            state.courseRefreshError.isNotEmpty) {
          MevTechUtilities.errorToast(
            context,
            state.courseRefreshError,
          );
        }
      },
      builder: (context, state) {
        final courseCubit = context.read<CourseCubit>();

        var isInstructor = false;
        if (authState is AuthLoginSuccess) {
          isInstructor = authState.model.user.isInstructor;
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'Course',
              style: GoogleFonts.poppins(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              if (isInstructor)
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed(AppRouter.courseOperation);
                    },
                    icon: Icon(
                      Icons.settings_applications,
                      size: 35.r,
                      color: AppColor.secondary,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
          body: state is CourseSuccess
              ? RefreshIndicator(
                  onRefresh: () async {
                    await courseCubit.refreshCourses();
                  },
                  color: AppColor.primary,
                  backgroundColor: Colors.grey.shade200,
                  child: CourseModelCard(
                    courses: state.courses,
                    onTap: (course) {
                      context.read<SelectedCourseCubit>().selectCourse(course);

                      context.pushNamed(
                        AppRouter.courseDetails,
                        pathParameters: {'id': course.id},
                      );
                    },
                  ),
                )
              : state is CourseLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.secondary,
                        backgroundColor: AppColor.primary,
                      ),
                    )
                  : Center(
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
                                  'Unable to Load Courses',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                IconButton(
                                  onPressed: courseCubit.fetchCourses,
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppColor.secondary,
                                  ),
                                ),
                                Text(
                                  'Retry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: AppColor.secondary,
          //   onPressed: () {
          //     context.pushNamed(AppRouter.mockTest, extra: 'EerdGm-ehJQ');
          //   },
          //   child: const Text('Playlist'),
          // ),
        );
      },
    );
  }
}
