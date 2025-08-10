import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/course-widget/course_card.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/home/home_cubit.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:template/features/user/data/models/user_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DashboardCubit>().loadDashboardData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final authState = context.watch<AuthCubit>().state;
    final homeCubit = context.read<HomeCubit>();

    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        // if (state is DashboardLoading) {
        //   // MevTechUtilities.progressIndicator(context);
        // } else if (state is DashboardFailure) {
        //   // context.pop();

        //   // MevTechUtilities.errorToast(context, state.errorMessage);
        // } else if (state is DashboardSuccess) {
        //   // context.pop();
        // }
      },
      builder: (context, state) {
        final dashboardCubit = context.read<DashboardCubit>();

        UserModel? user;
        if (authState is AuthLoginSuccess) {
          user = authState.model.user;
        }

        return RefreshIndicator(
          onRefresh: () async {
            await dashboardCubit.loadDashboardData();
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/dash-header.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 15.h,
                        left: 15.w,
                        right: 15.w,
                        bottom: 15.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColor.primary,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Image.asset(
                                          'assets/images/avatar.jpg'),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Hi, ${user?.firstName ?? ''}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        'Welcome to world of Learning!',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          TextField(
                            // controller: dashboardCubit.emailToken,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 30,
                                // color: AppColor.primary,
                              ),
                              hintText: 'Search Course',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: AppColor.primary),
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (searchText) {},
                            onTap: () {
                              homeCubit.navigateToPage(1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black26,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Center(
                              //     child: ElevatedButton(
                              //         onPressed: () {
                              //           dashboardCubit.loadDashboardData();
                              //           // dashboardCubit.searchCourse('pyth');
                              //         },
                              //         child: Text('Test'))),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Category',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      context.pushNamed(AppRouter.categories);
                                    },
                                    iconAlignment: IconAlignment.end,
                                    icon: const Icon(
                                      Icons.input,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    label: Text(
                                      'View All',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              CategoryIcons(
                                categories: state.categories,
                                status: state.categoryStatus,
                                failureMessage: state.categoryError ?? '',
                                onRetry: dashboardCubit.loadCategories,
                                onClick: (category) {
                                  context.pushNamed(
                                    AppRouter.dashboardCoursCategory,
                                    extra: category,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Builder(
                          builder: (context) {
                            if (state is DashboardSuccess) {
                              return Column(
                                children: [
                                  carousalArrow(
                                    onPressedPrev: () {
                                      dashboardCubit.goToPreviousPage(0);
                                    },
                                    onPressedNext: () {
                                      dashboardCubit.goToNextPage(0);
                                    },
                                  ),
                                  MainCourseCardSlide(
                                    courses: state.courses,
                                    carouselController:
                                        dashboardCubit.carouselController[0],
                                    status: state.courseStatus,
                                    failureMessage: state.courseError ??
                                        'Error fetching courses',
                                    onRetry: dashboardCubit.loadCourses,
                                    onClick: (id) {
                                      context.pushNamed(
                                        AppRouter.courseDetails,
                                        extra: id,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  carousalArrow(
                                    onPressedPrev: () {
                                      dashboardCubit.goToPreviousPage(1);
                                    },
                                    onPressedNext: () {
                                      dashboardCubit.goToNextPage(1);
                                    },
                                  ),
                                  MainCourseCardSlide(
                                    courses: state.courses,
                                    carouselController:
                                        dashboardCubit.carouselController[1],
                                    status: state.courseStatus,
                                    failureMessage: state.courseError ??
                                        'Error fetching courses',
                                    onRetry: dashboardCubit.loadCourses,
                                    onClick: (id) {
                                      context.pushNamed(
                                        AppRouter.courseDetails,
                                        extra: id,
                                      );
                                    },
                                  ),
                                  carousalArrow(
                                    onPressedPrev: () {
                                      dashboardCubit.goToPreviousPage(2);
                                    },
                                    onPressedNext: () {
                                      dashboardCubit.goToNextPage(2);
                                    },
                                  ),
                                  MainCourseCardSlide(
                                    courses: state.courses,
                                    carouselController:
                                        dashboardCubit.carouselController[2],
                                    status: state.courseStatus,
                                    failureMessage: state.courseError ??
                                        'Error fetching courses',
                                    onRetry: dashboardCubit.loadCourses,
                                    onClick: (id) {
                                      context.pushNamed(
                                        AppRouter.courseDetails,
                                        extra: id,
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
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
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.zero,
            onPressed: onPressedPrev,
            minWidth: 0,
            child: Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  360,
                ),
                border: Border.all(
                  color: AppColor.primary,
                  width: 0.7,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColor.secondary,
              ),
            ),
          ),
          SizedBox(width: 7.w),
          MaterialButton(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.zero,
            onPressed: onPressedNext,
            minWidth: 0,
            child: Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  360,
                ),
                border: Border.all(
                  color: AppColor.primary,
                  width: 0.7,
                ),
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

  Widget categoryIcons() {
    final categoryList = <Map<String, dynamic>>[
      {
        'name': 'Technical',
        'icon': const Icon(
          Icons.monitor_outlined,
          color: Colors.deepPurple,
        ),
      },
      {
        'name': 'Business',
        'icon': Icon(
          Icons.business_outlined,
          color: Colors.green.shade700,
        ),
      },
      {
        'name': 'Engineering',
        'icon': const Icon(
          Icons.engineering_outlined,
          color: Colors.black87,
        ),
      },
      {
        'name': 'Finance',
        'icon': const Icon(
          Icons.bar_chart_outlined,
          color: Colors.pink,
        ),
      },
      {
        'name': 'Design',
        'icon': const Icon(
          Icons.pattern_outlined,
          color: Colors.orange,
        ),
      },
      {
        'name': 'Marketing',
        'icon': const Icon(
          Icons.campaign_outlined,
          color: Colors.red,
        ),
      },
      {
        'name': 'Others',
        'icon': const Icon(
          Icons.dynamic_feed_outlined,
          color: Colors.blueAccent,
        ),
      },
    ];
    return SizedBox(
      height: 130.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        separatorBuilder: (context, index) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          final value = categoryList[index];
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(13.r),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(360.r),
                ),
                child: value['icon'] as Widget,
              ),
              SizedBox(height: 5.h),
              Text(
                value['name'].toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
