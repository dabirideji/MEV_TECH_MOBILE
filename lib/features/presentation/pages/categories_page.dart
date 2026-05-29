import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/course/course-widget/course_card.dart';
import 'package:mevtech/features/course/data/models/course-models/course_model.dart';
import 'package:mevtech/features/course/logic/course-cubit/course_cubit.dart';
import 'package:mevtech/features/course/logic/selected_course_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/presentation/widgets/course.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoriesView();
  }
}

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().loadCoursesAndCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) {
        if (current is CourseSuccess &&
            current.routeName == AppRouter.courseCategorySettings) {
          if (current.actionMethod == ActionMethod.deleting) {
            return true;
          }
          if (current.actionMethod == ActionMethod.deleted) {
            return true;
          }
          if (current.actionMethod == ActionMethod.notDeleted) {
            return true;
          }
          return false;
        }

        if (current is CourseLoading &&
            current.actionType == CourseActionType.getCourseCategory) {
          return true;
        }
        if (current is CourseSuccess &&
            current.actionType == CourseActionType.getCourseCategory) {
          return true;
        }
        if (current is CourseFailure &&
            current.actionType == CourseActionType.getCourseCategory) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CourseLoading) {
          // MevTechUtilities.progressIndicator(context);
        } else if (state is CourseFailure) {
          MevTechUtilities.errorToast(context, state.errorMessage);
        }
        // else if (state is CourseSuccess &&
        //     state.courseRefreshError.isNotEmpty) {
        //   MevTechUtilities.errorToast(
        //     context,
        //     state.courseRefreshError,
        //   );
        // }

        if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.deleting) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.notDeleted) {
          MevTechUtilities.hideProgressIndicator(context);

          // context.read<CourseCubit>().clearTempData();
          MevTechUtilities.errorToast(context, state.message ?? '');
          context.read<CourseCubit>().resetRoute();
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.deleted) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.successToast(
            context,
            state.message ?? 'Request Successful',
          );

          context.read<CourseCubit>().resetRoute();
        }
      },
      builder: (context, state) {
        final courseCubit = context.read<CourseCubit>();

        if (state is CourseSuccess &&
            state.actionType == CourseActionType.getCourseCategory) {
          // final isExpanded = context.select<CourseCubit, bool>((cubit) {
          //   return switch (cubit.state) {
          //     final CourseSuccess s => s.isMenuExpanded,
          //     _ => false,
          //   };
          // });
          // final isExpanded = state.isMenuExpanded[Course.all] ?? false;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              iconTheme: const IconThemeData(color: AppColor.primary),
              title: Text(
                'Course Categories',
                style: TextStyle(
                  fontFamily: 'poppings',
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                ),
              ),
              // actions: [
              //   Padding(
              //     padding: EdgeInsets.only(right: 10.w),
              //     child: IconButton(
              //       onPressed: () {
              //         // courseCubit.clearField();
              //         context.pushNamed(AppRouter.courseCategorySettings);
              //       },
              //       icon: Icon(
              //         Icons.add_card,
              //         size: 35.r,
              //         color: AppColor.secondary,
              //       ),
              //     ),
              //   ),
              // ],
            ),
            body: Padding(
              padding: EdgeInsets.all(12.r),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    ...state.categorizedCourses.entries.map((entry) {
                      final category = entry.key;
                      final courses = entry.value;
                      return CourseCategoryCard(
                        categoryList: courses,
                        isMenuExpanded:
                            state.isMenuExpanded[category.categoryName] ??
                            false,
                        category: category.categoryName,
                        onClickViewAll: (category) {
                          context.pushNamed(
                            AppRouter.categoryViewMore,
                            extra: category,
                          );
                        },
                        onExpansionChanged: (value) {
                          courseCubit.toggleMenu(category.categoryName);
                        },
                        onTap: (course) {
                          context.read<SelectedCourseCubit>().selectCourse(
                            course,
                          );

                          context.pushNamed(
                            AppRouter.courseDetails,
                            pathParameters: {'id': course.id},
                          );
                        },
                      );
                    }),
                    SizedBox(height: 10.h),
                    if (state.uncategorizedCourses.isNotEmpty)
                      CourseCategoryCard(
                        categoryList: state.uncategorizedCourses,
                        isMenuExpanded:
                            state.isMenuExpanded[Course.all] ?? false,
                        category: Course.all,
                        onClickViewAll: (category) {
                          context.pushNamed(
                            AppRouter.categoryViewMore,
                            extra: category,
                          );
                        },
                        onExpansionChanged: (value) {
                          courseCubit.toggleMenu(Course.all);
                        },
                        onTap: (course) {
                          context.read<SelectedCourseCubit>().selectCourse(
                            course,
                          );

                          context.pushNamed(
                            AppRouter.courseDetails,
                            pathParameters: {'id': course.id},
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: SafeArea(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         ElevatedButton(
            //           onPressed: () {
            //             optionBottomSheet(
            //               context: context,
            //               viewType: 'CAT',
            //               items: courseCubit.categoryModel ??
            //                   <CourseCategoryModel>[],
            //               onDelete: (id) {
            //                 Navigator.pop(context);
            //                 courseCubit.deleteCourseCategory(id);
            //               },
            //             );
            //           },
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             backgroundColor: AppColor.primary,
            //             foregroundColor: Colors.white,
            //           ),
            //           child: Container(
            //             height: 45.h,
            //             // width: double.infinity,
            //             alignment: Alignment.center,
            //             child: Text(
            //               'View Categories',
            //               style: TextStyle(
            //                 fontSize: 12.sp,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //         ),
            //         ElevatedButton(
            //           onPressed: () {
            //             // optionBottomSheet(
            //             //   context: context,
            //             //   viewType: 'CAT',
            //             //   items: courseCubit.categoryModel ??
            //             //       <CourseCategoryModel>[],
            //             //   onDelete: (id) {
            //             //     Navigator.pop(context);
            //             //     courseCubit.deleteCourseCategory(id);
            //             //   },
            //             // );
            //           },
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             backgroundColor: AppColor.primary,
            //             foregroundColor: Colors.white,
            //           ),
            //           child: Container(
            //             height: 45.h,
            //             // width: double.infinity,
            //             alignment: Alignment.center,
            //             child: Text(
            //               '    View Tags    ',
            //               style: TextStyle(
            //                 fontSize: 12.sp,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.only(bottom: 10),
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       optionBottomSheet(context);
            //     },
            //     backgroundColor: AppColor.secondaryTint,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       side: const BorderSide(
            //         color: AppColor.primaryFaint,
            //         width: 2,
            //       ),
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         const Icon(
            //           Icons.settings,
            //           color: AppColor.primary,
            //         ),
            //         Text(
            //           'Option',
            //           style: TextStyle(
            //             fontSize: 10.sp,
            //             fontWeight: FontWeight.w700,
            //             color: Colors.black45,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          );
        }
        if (state is CourseFailure &&
            state.actionType == CourseActionType.getCourseCategory) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '⚠️ ${state.errorMessage}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextButton.icon(
                      onPressed: context
                          .read<CourseCubit>()
                          .loadCoursesAndCategories,
                      icon: Icon(
                        FIcons.rotateCcw,
                        size: 25.sp,
                        color: AppColor.primary,
                      ),
                      label: Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text(state.errorMessage)
            ),
          );
        }

        if (state is CourseLoading &&
            state.actionType == CourseActionType.getCourseCategory) {
          return Scaffold(body: Center(child: MevTechUtilities.customLoader()));
        }
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('Courses Not Found')),
        );
      },
    );
  }

  dynamic optionBottomSheet({
    required BuildContext context,
    required String viewType,
    required List<CourseCategoryModel> items,
    required void Function(String)? onDelete,
  }) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                Text(
                  viewType == 'TAG' ? 'Tags' : 'Categories',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final value = items[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              value.categoryName,
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => onDelete?.call(value.id ?? ''),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Divider(thickness: 0.5, color: Colors.black45),
                        ],
                      );
                    },
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //         minimumSize: Size(150.w, 35.h),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           side: const BorderSide(
                //             color: AppColor.secondary,
                //             width: 1.5,
                //           ),
                //         ),
                //         backgroundColor: Colors.white,
                //         foregroundColor: AppColor.secondary,
                //       ),
                //       child: Container(
                //         // height: 35.h,
                //         // width: double.infinity,
                //         alignment: Alignment.center,
                //         child: Text(
                //           'Delete',
                //           style: TextStyle(
                //             fontSize: 13.sp,
                //             fontWeight: FontWeight.w600,
                //             color: AppColor.secondary,
                //           ),
                //         ),
                //       ),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         // context.pop();
                //         // // context.read<CourseCubit>().populateData(course);
                //         // context.pushNamed(AppRouter.editCourse);
                //       },
                //       style: ElevatedButton.styleFrom(
                //         minimumSize: Size(150.w, 35.h),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           side: const BorderSide(
                //             // color: Colors.grey,
                //             width: 1.5,
                //           ),
                //         ),
                //         backgroundColor: AppColor.primary,
                //         foregroundColor: Colors.white,
                //       ),
                //       child: Container(
                //         // height: 40.h,
                //         // width: double.infinity,
                //         alignment: Alignment.center,
                //         child: Text(
                //           'Edit',
                //           style: TextStyle(
                //             fontSize: 13.sp,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

// If you want to sort all courses by category name, use:
// final sortedCourses = myList.toList()
//   ..sort((a, b) => a.category.compareTo(b.category));
