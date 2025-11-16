import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/course_thumbnail.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/presentation/widgets/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({required this.course, super.key});

  final Course course;

  // DIP BAS MBA

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (course.id == 'MEV')
                  mevTechIcon()
                else if (course.id == 'CIQ')
                  ciQIcon()
                else if (course.id == 'AU')
                  acaUniIcon(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Text(
                    'Free Learning',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity.w,
            height: 140.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  course.imagePath,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            course.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
              text: '${course.durationType}: ',
              style: const TextStyle(
                color: Colors.black54,
              ),
              children: [
                TextSpan(
                  text: course.duration,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Start Now',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mevTechIcon() {
    return RichText(
      text: TextSpan(
        text: 'Mev',
        style: TextStyle(
          fontFamily: 'poppins',
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          fontStyle: FontStyle.italic,
        ),
        children: [
          TextSpan(
            text: 'Tech',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget ciQIcon() {
    return Image.asset(
      'assets/icons/CiQ-icon.png',
      width: 70.w,
    );
  }

  Widget acaUniIcon() {
    return Container(
      margin: EdgeInsets.only(left: 15.w),
      child: Image.asset(
        'assets/icons/Aca-Uni-icon.png',
        width: 35.w,
      ),
    );
  }
}

class MainCourseCardSlide extends StatelessWidget {
  const MainCourseCardSlide({
    required this.courses,
    required this.carouselController,
    required this.status,
    required this.onRetry,
    this.onClick,
    super.key,
    this.failureMessage = '',
  });

  final List<CourseModel> courses;
  final CarouselSliderController carouselController;
  final LoadStatus status;
  final String failureMessage;
  final void Function(CourseModel)? onClick;
  final void Function()? onRetry;

  // DIP BAS MBA

  @override
  Widget build(BuildContext context) {
    if (status == LoadStatus.loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              width: double.infinity.w,
              height: 230.h,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    if (status == LoadStatus.failure) {
      return Container(
        width: double.infinity.w,
        height: 140.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$failureMessage ⛔',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.send,
                color: AppColor.primary,
              ),
              label: Text(
                'Reload Course',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        height: 360.h,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          // _currentIndex = index;
        },
      ),
      items: List.generate(courses.length, (index) {
        final course = courses[index];

        return Container(
          alignment: Alignment.center,
          width: double.infinity.w,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mevTechIcon(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Text(
                        'Free Learning',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity.w,
                height: 140.h,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      course.courseImageUrl,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                course.courseTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 5.h),
              RichText(
                text: const TextSpan(
                  text: 'Flexible Duration: ',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  children: [
                    TextSpan(
                      text: '2-3 Weeks Learning',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: () => onClick?.call(course),
                child: const Text(
                  'Start Now',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget mevTechIcon() {
    return RichText(
      text: TextSpan(
        text: 'Mev',
        style: TextStyle(
          fontFamily: 'poppins',
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          fontStyle: FontStyle.italic,
        ),
        children: [
          TextSpan(
            text: 'Tech',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcons extends StatelessWidget {
  const CategoryIcons(
      {required this.categories,
      required this.status,
      required this.onClick,
      required this.onRetry,
      super.key,
      this.failureMessage = ''});

  final List<CourseCategoryModel> categories;
  final LoadStatus status;
  final String failureMessage;
  final void Function(String)? onClick;
  final void Function()? onRetry;

  Widget catIcons(String categoryName) {
    if (categoryName == Course.aiMarchineLearning) {
      return const Icon(Icons.monitor_outlined, color: Colors.deepPurple);
    } else if (categoryName == Course.softwareDev) {
      return const Icon(Icons.monitor_outlined, color: Colors.teal);
    } else if (categoryName == Course.business) {
      return Icon(Icons.business_outlined, color: Colors.green.shade700);
    } else if (categoryName == Course.engineering) {
      return const Icon(Icons.engineering_outlined, color: Colors.black87);
    } else if (categoryName == Course.finance) {
      return const Icon(Icons.bar_chart_outlined, color: Colors.pink);
    } else if (categoryName == Course.design) {
      return const Icon(Icons.pattern_outlined, color: Colors.orange);
    } else if (categoryName == Course.marketing) {
      return const Icon(Icons.campaign_outlined, color: Colors.red);
    } else if (categoryName == Course.dataScience) {
      return const Icon(Icons.data_thresholding_outlined,
          color: Colors.blueGrey);
    } else if (categoryName == Course.health) {
      return const Icon(Icons.health_and_safety, color: Colors.pinkAccent);
    } else if (categoryName == Course.hospitality) {
      return const Icon(Icons.healing, color: Colors.blueAccent);
    } else if (categoryName == Course.supplyChain) {
      return const Icon(Icons.pallet, color: Colors.black);
    } else if (categoryName == Course.education) {
      return const Icon(Icons.school, color: Colors.black54);
    } else if (categoryName == Course.education2) {
      return const Icon(Icons.my_library_books, color: Colors.lightGreen);
    } else if (categoryName == Course.publicAdmin) {
      return Icon(Icons.how_to_vote, color: Colors.blue.shade900);
    } else if (categoryName == Course.workplaceTech) {
      return const Icon(Icons.computer, color: Colors.deepOrange);
    } else if (categoryName == Course.agriculture) {
      return const Icon(Icons.hive, color: Colors.cyan);
    }

    return const Icon(Icons.category, color: Colors.indigoAccent);
  }

  @override
  Widget build(BuildContext context) {
    if (status == LoadStatus.loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (context, index) {
              return CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.r,
              );
            },
          ),
        ),
      );
    }
    if (status == LoadStatus.failure) {
      return Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(13.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          children: [
            Text(
              failureMessage,
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.send,
                color: AppColor.primary,
              ),
              label: Text(
                'Retry',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          return SizedBox(
            width: 80.w,
            child: MaterialButton(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              padding: EdgeInsets.zero,
              onPressed: () => onClick?.call(category.categoryName),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(360.r),
                    ),
                    child: catIcons(category.categoryName),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    category.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MiniCourseCard extends StatelessWidget {
  const MiniCourseCard({
    required this.courses,
    required this.isMenuExpanded,
    required this.category,
    this.onClickViewAll,
    this.onExpansionChanged,
    super.key,
  });

  final List<CourseModel> courses;
  final bool isMenuExpanded;
  final String category;
  final void Function(String)? onClickViewAll;

  final ValueChanged<bool>? onExpansionChanged;

  static const List<String> tutorNames = [
    'Alice Kobe',
    'Bob Whiney',
    'Charlie',
    'David Moore',
    'EveLyn',
    'Briggs',
    'Katty Perry',
    'Andreas',
    'Jose Moph',
  ];

  static final random = Random();

  @override
  Widget build(BuildContext context) {
    final categoryList =
        courses.where((course) => course.id == category).toList();
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent, // no color bleed
        showTrailingIcon: false,
        shape: const Border.fromBorderSide(BorderSide.none),
        collapsedShape: const Border.fromBorderSide(BorderSide.none),
        enableFeedback: false,

        initiallyExpanded: isMenuExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color:
                isMenuExpanded ? AppColor.secondaryFade : AppColor.primaryFaint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                isMenuExpanded
                    ? Icons.keyboard_double_arrow_down_outlined
                    : Icons.keyboard_double_arrow_right_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onClickViewAll?.call(category),
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 17.w) / 2;
              return SizedBox(
                height: 260.h,
                child: ListView.separated(
                  // padding: EdgeInsets.only(top: 20.h),
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 15.w),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final randomIndex = random.nextInt(tutorNames.length);
                    final course = categoryList[index];
                    return SizedBox(
                      width: itemWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: itemWidth,
                            height: 120.h,
                            // margin: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  course.courseImageUrl,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            course.courseTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_2_outlined,
                              ),
                              Text(
                                course.instructorId,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class MainCourseCard extends StatelessWidget {
//   const MainCourseCard({
//     required this.courses,
//     // required this.category,
//     super.key,
//   });

//   final List<Course> courses;
//   // final String category;

//   static const List<String> tutorNames = [
//     'Alice Kobe',
//     'Bob Whiney',
//     'Charlie',
//     'David Moore',
//     'EveLyn',
//     'Briggs',
//     'Katty Perry',
//     'Andreas',
//     'Jose Moph',
//   ];

//   static final random = Random();

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final itemWidth = (constraints.maxWidth - 17.w) * 0.3;
//         return ListView.separated(
//           // padding: EdgeInsets.only(top: 20.h),
//           physics: const ClampingScrollPhysics(),

//           separatorBuilder: (context, index) => SizedBox(height: 5.h),
//           itemCount: courses.length,
//           itemBuilder: (context, index) {
//             final randomIndex = random.nextInt(tutorNames.length);
//             final course = courses[index];
//             return Container(
//               padding: EdgeInsets.all(15.r),
//               decoration: ShapeDecoration(
//                 shape: NonUniformBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.black12,
//                   topWidth: 0.5,
//                   bottomWidth: 2.5,
//                   leftWidth: 0.7,
//                   rightWidth: 0.7,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: itemWidth,
//                     height: 85.h,
//                     // margin: EdgeInsets.symmetric(horizontal: 12.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.r),
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: AssetImage(
//                           course.imagePath,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           course.title,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 3,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.person_2_outlined,
//                               color: AppColor.secondary,
//                             ),
//                             Text(
//                               tutorNames[randomIndex],
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12.sp,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 15.r,
//                         color: Colors.black54,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

class CourseModelCard extends StatelessWidget {
  const CourseModelCard({
    required this.courses,
    this.onTap,
    // required this.category,
    super.key,
  });

  final List<CourseModel> courses;
  // final String category;
  final void Function(CourseModel)? onTap;

  static final random = Random();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 17.w) * 0.3;
        return ListView.separated(
          // padding: EdgeInsets.only(top: 20.h),
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          separatorBuilder: (context, index) => SizedBox(height: 5.h),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () => onTap?.call(course),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: ShapeDecoration(
                      shape: NonUniformBorder(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                        topWidth: 0.5,
                        bottomWidth: 2.5,
                        leftWidth: 0.7,
                        rightWidth: 0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: itemWidth,
                          height: 85.h,
                          // margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: course.courseImageUrl,
                              placeholder: (context, url) => const Center(
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
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  course.courseTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.person_2_outlined,
                                  //   color: AppColor.secondary,
                                  // ),
                                  Flexible(
                                    child: Text(
                                      course.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                // '₦${MevTechUtilities.formatterDouble(
                                //   // course.price,
                                //   50000.23,
                                // )}',
                                'Free',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: AppColor.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.r,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void clearSingleImage(String url) {
    CachedNetworkImage.evictFromCache(url);
  }

// Or to clear everything (not recommended unless needed):

  Future<void> clearAllCache() async {
    // await DefaultCacheManager().emptyCache();
  }
}

class CourseCategoryCard extends StatelessWidget {
  const CourseCategoryCard({
    required this.isMenuExpanded,
    required this.categoryList,
    required this.category,
    this.onClickViewAll,
    this.onTap,
    this.onExpansionChanged,
    super.key,
  });

  final bool isMenuExpanded;
  final String category;
  final void Function(String)? onClickViewAll;
  final void Function(CourseModel)? onTap;
  final ValueChanged<bool>? onExpansionChanged;
  final List<CourseModel> categoryList;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent, // no color bleed
        showTrailingIcon: false,
        shape: const Border.fromBorderSide(BorderSide.none),
        collapsedShape: const Border.fromBorderSide(BorderSide.none),
        enableFeedback: false,

        initiallyExpanded: isMenuExpanded,
        onExpansionChanged: onExpansionChanged,
        title: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color:
                isMenuExpanded ? AppColor.secondaryFade : AppColor.primaryFaint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              Icon(
                isMenuExpanded
                    ? Icons.keyboard_double_arrow_down_outlined
                    : Icons.keyboard_double_arrow_right_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onClickViewAll?.call(category),
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 17.w) / 2;
              return SizedBox(
                height: 260.h,
                child: ListView.separated(
                  // padding: EdgeInsets.only(top: 20.h),
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 15.w),
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final course = categoryList[index];
                    return GestureDetector(
                      onTap: () => onTap?.call(course),
                      child: SizedBox(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: itemWidth,
                              height: 120.h,
                              // margin: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    course.courseImageUrl,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              course.courseTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.school,
                                  size: 15.w,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'Free',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                    color: AppColor.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CourseContentListCard extends StatelessWidget {
  const CourseContentListCard({
    required this.courseContents,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final List<CourseContentModel> courseContents;
  final void Function(String)? onTap;
  final void Function(String)? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 17.w) * 0.3;
        return ListView.separated(
          padding: EdgeInsets.only(top: 10.h),
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemCount: courseContents.length,
          itemBuilder: (context, index) {
            final courseContent = courseContents[index];
            final videoId = MevTechUtilities.extractYoutubeId(
                courseContent.courseContentVideoUrl);
            return GestureDetector(
              onTap: () => onTap?.call(courseContent.id),
              onLongPress: () => onLongPress?.call(courseContent.id),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: ShapeDecoration(
                      shape: NonUniformBorder(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                        topWidth: 0.5,
                        bottomWidth: 2.5,
                        leftWidth: 0.7,
                        rightWidth: 0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: itemWidth,
                          height: 85.h,
                          // margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CourseThumbnail(
                              videoUrl: courseContent.courseContentVideoUrl,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  courseContent.courseContentTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.person_2_outlined,
                                  //   color: AppColor.secondary,
                                  // ),
                                  Flexible(
                                    child: Text(
                                      courseContent.courseContentDescription,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                // '₦${MevTechUtilities.formatterDouble(
                                //   // course.price,
                                //   50000.23,
                                // )}',
                                'Free',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: AppColor.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.more_vert,
                              size: 15.r,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppColor.primary,
                      size: 50.w,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void clearSingleImage(String url) {
    CachedNetworkImage.evictFromCache(url);
  }

// Or to clear everything (not recommended unless needed):

  Future<void> clearAllCache() async {
    // await DefaultCacheManager().emptyCache();
  }
}

class CourseOperationCard extends StatelessWidget {
  const CourseOperationCard({
    required this.courses,
    this.onTap,
    super.key,
    this.onTapEdit,
    this.onTapDelete,
    this.onTapAddContent,
  });

  final List<CourseModel> courses;

  final void Function(String)? onTap;
  final void Function(String)? onTapEdit;
  final void Function(String)? onTapDelete;
  final void Function(String)? onTapAddContent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 17.w) * 0.3;
        return ListView.separated(
          // padding: EdgeInsets.only(top: 20.h),
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          separatorBuilder: (context, index) => SizedBox(height: 5.h),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () => onTap?.call(course.id),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: ShapeDecoration(
                      shape: NonUniformBorder(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black12,
                        topWidth: 0.5,
                        bottomWidth: 2.5,
                        leftWidth: 0.7,
                        rightWidth: 0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: itemWidth,
                          height: 85.h,
                          // margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: course.courseImageUrl,
                              placeholder: (context, url) => const Center(
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
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  course.courseTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.person_2_outlined,
                                  //   color: AppColor.secondary,
                                  // ),
                                  Flexible(
                                    child: Text(
                                      course.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                // '₦${MevTechUtilities.formatterDouble(
                                //   // course.price,
                                //   50000.23,
                                // )}',
                                'Free',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: AppColor.secondary,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        onTapAddContent?.call(course.id),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.only(left: 5.w),
                                      minimumSize: Size(60.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    iconAlignment: IconAlignment.end,
                                    label: Text(
                                      'Content',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  ElevatedButton(
                                    onPressed: () => onTapEdit?.call(course.id),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(60.w, 30.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: AppColor.primary,
                                    ),
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  ElevatedButton(
                                    onPressed: () =>
                                        onTapDelete?.call(course.id),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(60.w, 30.h),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void clearSingleImage(String url) {
    CachedNetworkImage.evictFromCache(url);
  }

// Or to clear everything (not recommended unless needed):

  Future<void> clearAllCache() async {
    // await DefaultCacheManager().emptyCache();
  }
}
