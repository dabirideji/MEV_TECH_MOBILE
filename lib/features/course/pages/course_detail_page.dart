import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/course/logic/course_details_cubit.dart';
import 'package:template/features/course/logic/selected_course_cubit.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/injector.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({required this.courseId, super.key});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseDetailsCubit>(),
      child: CourseDetailsView(courseId: courseId),
    );
  }
}

class CourseDetailsView extends StatefulWidget {
  const CourseDetailsView({required this.courseId, super.key});
  final String courseId;

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final courses = context.read<DashboardCubit>().state.courses;
    //   context.read<CourseCubit>().checkState(courses: courses);

    //   context.read<CourseCubit>().fetchCourseEnrollment(
    //         courseId: widget.courseId,
    //         studentId: MevTechUtilities.id,
    //       );
    // });

    final selectedCourse = context.read<SelectedCourseCubit>().state;
    if (selectedCourse == null || selectedCourse.id != widget.courseId) {
      context.read<CourseDetailsCubit>().fetchCourseById(widget.courseId);
      context.read<CourseDetailsCubit>().fetchCourseEnrollment(
            courseId: widget.courseId,
            studentId: MevTechUtilities.id,
          );
    } else {
      context.read<CourseDetailsCubit>().loadFromMemory(selectedCourse);
      context.read<CourseDetailsCubit>().fetchCourseEnrollment(
            courseId: selectedCourse.id,
            studentId: MevTechUtilities.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authSuccess = context.read<AuthCubit>().state as AuthLoginSuccess;

    return BlocConsumer<CourseDetailsCubit, CourseDetailsState>(
      listener: (context, state) {
        if (state is CourseDetailsLoading) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseDetailsFailure) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.errorToast(context, state.errorMessage);
        } else if (state is CourseDetailsSuccess &&
            state.createStatus.isLoading) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseDetailsSuccess &&
            state.createStatus.isFailure) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.errorToast(
              context, state.createStatus.error ?? 'Something went wrong');
        } else if (state is CourseDetailsSuccess &&
            state.createStatus.isSuccess) {
          MevTechUtilities.hideProgressIndicator(context);
          successBottomSheet(context, message: state.message);
        }
      },
      builder: (context, state) {
        final detailsCubit = context.read<CourseDetailsCubit>();

        if (state is CourseDetailsSuccess) {
          final course = state.course;
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              // courseCubit.fetchCourses();
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                title: Text(
                  'Course Details',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  const icons = Icon(
                    Icons.star,
                    size: 13,
                    color: AppColor.secondary,
                  );
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: course.courseImageUrl,
                                placeholder: (_, url) => const Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: AppColor.secondary,
                                      backgroundColor: AppColor.primary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  course.courseTitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Text(
                                  'Free',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: AppColor.secondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              // Text(
                              //   'By Willy Morgan',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 12.sp,
                              //     fontWeight: FontWeight.w500,
                              //     color: Colors.black54,
                              //   ),
                              // ),
                              // SizedBox(height: 10.h),
                              // Row(
                              //   children: List.generate(5, (index) {
                              //     return icons;
                              //   }),
                              // ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Description',
                            style: GoogleFonts.poppins(
                              // fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            course.description,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          // Text(
                          //   'Instructor',
                          //   style: GoogleFonts.poppins(
                          //     fontSize: 14.sp,
                          //     fontWeight: FontWeight.w500,
                          //     // color: Colors.black45,
                          //   ),
                          // ),
                          // SizedBox(height: 10.h),
                          // Row(
                          //   children: [
                          //     SizedBox(width: 15.w),
                          //     const CircleAvatar(
                          //       backgroundColor: AppColor.primaryTint,
                          //       child: Icon(
                          //         Icons.person,
                          //         color: AppColor.primary,
                          //       ),
                          //     ),
                          //     SizedBox(width: 7.w),
                          //     Text(
                          //       'Willy Morgan',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 12.sp,
                          //         fontWeight: FontWeight.w500,
                          //         color: Colors.black45,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // floatingActionButton:
              // Padding(
              //         padding: const EdgeInsets.only(bottom: 10),
              //         child: FloatingActionButton(
              //           onPressed: state.isDeleting
              //               ? null
              //               : () {
              //                   optionBottomSheet(
              //                     context,
              //                     course.id,
              //                     course: course,
              //                   );
              //                 },
              //           backgroundColor: AppColor.secondaryTint,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //             side: const BorderSide(
              //               color: AppColor.primaryFaint,
              //               width: 2,
              //             ),
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               const Icon(
              //                 Icons.settings,
              //                 color: AppColor.primary,
              //               ),
              //               Text(
              //                 'Option',
              //                 style: GoogleFonts.poppins(
              //                   fontSize: 10.sp,
              //                   fontWeight: FontWeight.w700,
              //                   color: Colors.black45,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              // floatingActionButton: state.fetchStatus.isFailure
              //     ? Padding(
              //         padding: EdgeInsets.only(bottom: 10.h),
              //         child: TextButton.icon(
              //             onPressed: () {
              //               courseCubit.fetchCourseEnrollment(
              //                 courseId: widget.courseId,
              //                 studentId: MevTechUtilities.id,
              //               );
              //             },
              //             iconAlignment: IconAlignment.end,
              //             icon: Icon(
              //               Icons.refresh,
              //               color: Colors.red,
              //               size: 23.w,
              //             ),
              //             label: Text(
              //               'unable to fetch enrollment\nclick to refresh or Enrol below',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 11.sp,
              //                 fontWeight: FontWeight.w500,
              //                 color: Colors.red,
              //               ),
              //             )),
              //       )
              //     : null,

              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      !authSuccess.isSubscribed
                          ? context.pushNamed(AppRouter.subscription)
                          : state.courseEnrollment != null
                              ? context.pushNamed(
                                  AppRouter.courseContentlist,
                                  extra: widget.courseId,
                                )
                              : detailsCubit.createCourseEnrollment(
                                  courseId: widget.courseId,
                                  studentId: MevTechUtilities.id,
                                );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: state.fetchStatus.isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : null,
                    label: Container(
                      height: 45.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: buttonText(
                        courseId: widget.courseId,
                        studentId: MevTechUtilities.id,
                        enrollment: state.courseEnrollment,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Text('Unable to load Course'),
        );
      },
    );
  }

  Widget buttonText(
      {required String courseId,
      required String studentId,
      required CourseEnrollmentModel? enrollment}) {
    if (enrollment != null) {
      if (courseId == enrollment.courseId &&
          studentId == enrollment.studentId) {
        return Text(
          'View course content',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        );
      }
    }

    return Text(
      'Enrol Now',
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  dynamic successBottomSheet(BuildContext context, {required String message}) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: 100.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColor.primary,
                      size: 35.r,
                    ),
                    Image.asset(
                      'assets/images/success-icon.png',
                      width: 150,
                    ),
                    Icon(
                      Icons.star,
                      color: AppColor.primary,
                      size: 35.r,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Text(
                  textAlign: TextAlign.center,
                  message,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Your have enrolled successfully '
                    'click the view content to view course content now',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColor.secondary,
                            foregroundColor: Colors.white,
                          ),
                          child: Container(
                            height: 40.h,
                            // width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'close',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                              ..pop(context)
                              ..pushNamed(
                                AppRouter.courseContentlist,
                                extra: widget.courseId,
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColor.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Container(
                            height: 40.h,
                            // width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'view content',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
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

  dynamic optionBottomSheet(
    BuildContext context,
    String id, {
    required CourseModel course,
  }) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 100.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.w),
                  title: Text(
                    'Select an action below to continue',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  leading: const Text(''),
                  trailing: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        confirmDialogue(context, id);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 35.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: AppColor.secondary,
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.secondary,
                      ),
                      child: Container(
                        // height: 35.h,
                        // width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Delete',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // context.pop();
                        // // context.read<CourseCubit>().populateData(course);
                        // context.pushNamed(AppRouter.editCourse);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 35.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            // color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Container(
                        // height: 40.h,
                        // width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
