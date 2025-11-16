import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/logic/selected_course_cubit.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';

class SearchCourse extends StatefulWidget {
  const SearchCourse({super.key});

  @override
  State<SearchCourse> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  Timer? _debounce;

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<DashboardCubit>().searchCourse(query.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        final dashboardCubit = context.read<DashboardCubit>();

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Search Course',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // SizedBox(height: 20.h),
                TextField(
                  controller: dashboardCubit.searchText,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 28,
                      // color: AppColor.primary,
                    ),
                    suffixIcon: state.searchStatus == LoadStatus.loading
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 15.h,
                              bottom: 15.h,
                              right: 15.w,
                              left: 15.w,
                            ),
                            child: SizedBox(
                              height: 10.h,
                              width: 10.w,
                              child: const CircularProgressIndicator(
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : null,
                    hintText: 'Search courses...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColor.primary),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: _onChanged,
                ),
                SizedBox(height: 10.h),
                Expanded(
                  // state.searchError != null
                  child: state.searchedCourses.isEmpty &&
                          dashboardCubit.searchText.text.isNotEmpty
                      ? Center(
                          child: Text(state.searchError ?? 'No courses found'),
                        )
                      : state.searchedCourses.isEmpty
                          ? CourseModelCard(
                              courses: state.courses,
                              onTap: (course) {
                                context
                                    .read<SelectedCourseCubit>()
                                    .selectCourse(course);

                                context.pushNamed(
                                  AppRouter.courseDetails,
                                  pathParameters: {'id': course.id},
                                );
                              },
                            )
                          : CourseModelCard(
                              courses: state.searchedCourses,
                              onTap: (course) {
                                context
                                    .read<SelectedCourseCubit>()
                                    .selectCourse(course);

                                context.pushNamed(
                                  AppRouter.courseDetails,
                                  pathParameters: {'id': course.id},
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
