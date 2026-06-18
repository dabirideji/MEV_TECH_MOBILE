import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/course/course-widget/course_card.dart';
import 'package:mevtech/features/course/logic/selected_course_cubit.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:mevtech/features/presentation/landing/landing_cubit.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LandingView();
  }
}

class LandingView extends StatelessWidget {
  LandingView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWith = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authCubit = context.read<AuthCubit>();
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final dashboardCubit = context.read<DashboardCubit>();

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          onEndDrawerChanged: (isOpened) {
            if (!isOpened) {
              dashboardCubit.resetMenu();
            }
          },
          endDrawer: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.grey.shade200,
                child: SizedBox(
                  // height: screenHeight * 0.4,
                  width: screenWith * 0.9,
                  // color: Colors.grey.shade200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: dashboardCubit.isMenuExpanded,
                        builder: (context, isExpanded, child) {
                          return ExpansionTile(
                            iconColor: Colors.black54,
                            key: ValueKey(isExpanded),
                            initiallyExpanded: isExpanded,
                            onExpansionChanged: (value) {
                              dashboardCubit.toggleMenu();
                            },
                            minTileHeight: 25,
                            collapsedTextColor: Colors.black54,
                            collapsedIconColor: AppColor.primary,
                            textColor: Colors.black54,
                            childrenPadding: const EdgeInsets.only(left: 40),
                            leading: const Icon(FIcons.layers),
                            title: Text(
                              'Plans',
                              style: GoogleFonts.poppins(
                                // color: AppColor.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            children: [
                              menuItems(
                                title: 'Standard Plans (Free)',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                leading: const Icon(
                                  FIcons.users,
                                  color: AppColor.primary,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.pushNamed(AppRouter.subscription);
                                },
                              ),
                              menuItems(
                                title: 'Individual Plans (Paid)',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                leading: const Icon(
                                  FIcons.shieldUser,
                                  color: AppColor.primary,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.pushNamed(AppRouter.subscription);
                                },
                              ),
                              menuItems(
                                title: 'Organisational Plans (Paid)',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                leading: const Icon(
                                  FIcons.building2,
                                  color: AppColor.primary,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.pushNamed(AppRouter.subscription);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      menuItems(
                        title: 'Course Categories',
                        leading: const Icon(
                          FIcons.bookCopy,
                          color: AppColor.primary,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.pushNamed(AppRouter.categories);
                        },
                      ),
                      SizedBox(height: 10.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: ElevatedButton(
                          // ignore: unnecessary_lambdas
                          onPressed: () {
                            // Navigator.pop(context);
                            // Navigator.pop(context);

                            context.goNamed(AppRouter.dashboard);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            foregroundColor: AppColor.white,
                          ),
                          child: Text(
                            'Dashboard',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                AnimatedContainer(
                  // alignment: Alignment.center,
                  duration: const Duration(milliseconds: 300),
                  // height: isMenuExpanded ? 250.h : 60.h,
                  height: 60.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school),
                                SizedBox(width: 8.w),
                                RichText(
                                  text: TextSpan(
                                    text: 'MEV',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'TECH',
                                        style: GoogleFonts.poppins(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                scaffoldKey.currentState?.openEndDrawer();
                              },
                              minWidth: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 0.4.w,
                                  ),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Icon(Icons.menu, size: 28.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    key: const PageStorageKey('homePageScrollKey'),
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      // SliverAppBar(
                      //   pinned: true,
                      //   actions: [
                      //     IconButton(
                      //         onPressed: () {
                      //           scaffoldKey.currentState?.openEndDrawer();
                      //         },
                      //         icon: Icon(Icons.menu))
                      //   ],
                      // ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Home / ',
                                  style: GoogleFonts.poppins(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Available-Courses',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Available ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 37.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Courses',
                                        style: GoogleFonts.poppins(
                                          color: AppColor.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 37.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                // ignore: lines_longer_than_80_chars
                                'A plethora of niche knowledge programs to enable you to acquire specialized knowledge in a field of your choice. Ranging from 5 hours to 90 hours, pick a course based on the breadth and depth of learning you are looking for. These courses are free and can be completed at your own pace.',
                                style: GoogleFonts.poppins(fontSize: 15.5.sp),
                              ),
                              SizedBox(height: 20.h),
                              Center(
                                child: ElevatedButton(
                                  // ignore: unnecessary_lambdas
                                  onPressed: () {
                                    // authCubit.printAccessToken();
                                    // context.goNamed(AppRouter.course);
                                    homeCubit.navigateToPage(1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    foregroundColor: AppColor.white,
                                  ),
                                  child: Text(
                                    'See all courses',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),
                              Center(
                                child: Image.asset(
                                  'assets/images/Landing-banner.png',
                                  width: screenWith * 0.85.w,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Popular Courses',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 8.w),
                                    decoration: const BoxDecoration(
                                      color: AppColor.primary,
                                    ),
                                    child: Text(
                                      'Courses',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22.sp,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      homeCubit.navigateToPage(1);
                                    },
                                    child: Text(
                                      'View all Courses',
                                      style: GoogleFonts.poppins(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w600,
                                        // fontSize: 22.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.65.w,
                                    decoration: const BoxDecoration(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: MainCourseCardSlide(
                          courses: state.courses,
                          carouselController:
                              dashboardCubit.carouselController[0],
                          status: state.courseStatus,
                          failureMessage:
                              state.courseError ?? 'Error fetching courses',
                          onRetry: dashboardCubit.loadCourses,
                          onClick: (course) {
                            context.read<SelectedCourseCubit>().selectCourse(
                              course,
                            );

                            context.pushNamed(
                              AppRouter.courseDetails,
                              pathParameters: {'id': course.id},
                            );
                          },
                        ),
                      ),

                      // Newly Realeased
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            children: [
                              // SizedBox(height: 20.h),
                              carousalArrow(
                                onPressedPrev: () {
                                  dashboardCubit.goToPreviousPage(0);
                                },
                                onPressedNext: () {
                                  dashboardCubit.goToNextPage(0);
                                },
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Newly',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Container(
                                        padding: EdgeInsets.only(right: 8.w),
                                        decoration: const BoxDecoration(
                                          color: AppColor.primary,
                                        ),
                                        child: Text(
                                          'Released',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      homeCubit.navigateToPage(1);
                                    },
                                    child: Text(
                                      'View all Courses',
                                      style: GoogleFonts.poppins(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w600,
                                        // fontSize: 22.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.65.w,
                                    decoration: const BoxDecoration(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: MainCourseCardSlide(
                          courses: state.courses,
                          carouselController:
                              dashboardCubit.carouselController[1],
                          status: state.courseStatus,
                          failureMessage:
                              state.courseError ?? 'Error fetching courses',
                          onRetry: dashboardCubit.loadCourses,
                          onClick: (course) {
                            context.read<SelectedCourseCubit>().selectCourse(
                              course,
                            );

                            context.pushNamed(
                              AppRouter.courseDetails,
                              pathParameters: {'id': course.id},
                            );
                          },
                        ),
                      ),

                      // Be future Ready
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 20.h),
                              carousalArrow(
                                onPressedPrev: () {
                                  dashboardCubit.goToPreviousPage(1);
                                },
                                onPressedNext: () {
                                  dashboardCubit.goToNextPage(1);
                                },
                              ),

                              SizedBox(height: 30.h),
                              Row(
                                children: [
                                  Text(
                                    'Be future',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Container(
                                    padding: EdgeInsets.only(right: 8.w),
                                    decoration: const BoxDecoration(
                                      color: AppColor.primary,
                                    ),
                                    child: Text(
                                      'Ready',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Courses To Future Proof Your Career (IT Courses)',
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  // fontSize: 22.sp,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    homeCubit.navigateToPage(1);
                                  },
                                  child: Text(
                                    'View all Courses',
                                    style: GoogleFonts.poppins(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.65.w,
                                    decoration: const BoxDecoration(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: MainCourseCardSlide(
                          courses: state.courses,
                          carouselController:
                              dashboardCubit.carouselController[2],
                          status: state.courseStatus,
                          failureMessage:
                              state.courseError ?? 'Error fetching courses',
                          onRetry: dashboardCubit.loadCourses,
                          onClick: (course) {
                            context.read<SelectedCourseCubit>().selectCourse(
                              course,
                            );

                            context.pushNamed(
                              AppRouter.courseDetails,
                              pathParameters: {'id': course.id},
                            );
                          },
                        ),
                      ),

                      // Popular Basics Courses
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 20.h),
                              carousalArrow(
                                onPressedPrev: () {
                                  dashboardCubit.goToPreviousPage(2);
                                },
                                onPressedNext: () {
                                  dashboardCubit.goToNextPage(2);
                                },
                              ),

                              SizedBox(height: 30.h),
                              Text(
                                'Popular Basics Courses -',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8.w),
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                ),
                                child: Text(
                                  'Learn In 5 Hours',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    homeCubit.navigateToPage(1);
                                  },
                                  child: Text(
                                    'View all Courses',
                                    style: GoogleFonts.poppins(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.65.w,
                                    decoration: const BoxDecoration(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: MainCourseCardSlide(
                          courses: state.courses,
                          carouselController:
                              dashboardCubit.carouselController[3],
                          status: state.courseStatus,
                          failureMessage:
                              state.courseError ?? 'Error fetching courses',
                          onRetry: dashboardCubit.loadCourses,
                          onClick: (course) {
                            context.read<SelectedCourseCubit>().selectCourse(
                              course,
                            );

                            context.pushNamed(
                              AppRouter.courseDetails,
                              pathParameters: {'id': course.id},
                            );
                          },
                        ),
                      ),

                      // Executive Diploma Courses
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 20.h),
                              carousalArrow(
                                onPressedPrev: () {
                                  dashboardCubit.goToPreviousPage(3);
                                },
                                onPressedNext: () {
                                  dashboardCubit.goToNextPage(3);
                                },
                              ),

                              SizedBox(height: 30.h),
                              Text(
                                'Make a mark on your\nprofile with these',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 8.w),
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                ),
                                child: Text(
                                  'Executive Diploma',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    homeCubit.navigateToPage(1);
                                  },
                                  child: Text(
                                    'View all Courses',
                                    style: GoogleFonts.poppins(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.65.w,
                                    decoration: const BoxDecoration(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: screenWith * 0.23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: MainCourseCardSlide(
                          courses: state.courses,
                          carouselController:
                              dashboardCubit.carouselController[4],
                          status: state.courseStatus,
                          failureMessage:
                              state.courseError ?? 'Error fetching courses',
                          onRetry: dashboardCubit.loadCourses,
                          onClick: (course) {
                            context.read<SelectedCourseCubit>().selectCourse(
                              course,
                            );

                            context.pushNamed(
                              AppRouter.courseDetails,
                              pathParameters: {'id': course.id},
                            );
                          },
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            carousalArrow(
                              onPressedPrev: () {
                                dashboardCubit.goToPreviousPage(4);
                              },
                              onPressedNext: () {
                                dashboardCubit.goToNextPage(4);
                              },
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget carousalArrow({
    required void Function()? onPressedPrev,
    required void Function()? onPressedNext,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(
            splashColor: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.zero,
            onPressed: onPressedPrev,
            minWidth: 0,
            child: Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                border: Border.all(color: AppColor.primary, width: 0.7),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColor.secondary,
              ),
            ),
          ),
          SizedBox(width: 7.w),
          MaterialButton(
            splashColor: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.zero,
            onPressed: onPressedNext,
            minWidth: 0,
            child: Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                border: Border.all(color: AppColor.primary, width: 0.7),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColor.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'Mev',
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 22.sp,
                  decoration: TextDecoration.overline,
                  decorationColor: AppColor.primary,
                ),
                children: [
                  TextSpan(
                    text: 'Tech',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              child: Text(
                'Explore',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, size: 33.r),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              minWidth: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 0.4.w),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Icon(Icons.menu, size: 28.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItems({
    required String title,
    VoidCallback? onTap,
    Widget? leading,
    Widget? trailing,
    Color? tileColor,
    bool selected = false,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 13,
  }) {
    return ListTile(
      // selected: dashBoard.selectedMenuIndex == 1,
      //             selectedTileColor: Colors.grey.withOpacity(0.6),
      //             selectedColor: MyColors.themeColor,
      selected: selected,
      dense: true,
      tileColor: tileColor,
      selectedColor: Colors.red,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black54,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
        ),
      ),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
