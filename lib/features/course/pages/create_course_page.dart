import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/course/logic/course-cubit/course_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/presentation/widgets/course.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  String? spCategory;
  List<String> categoryItems = List.from(Course.categoryItems);
  String spTag = Course.allTags;
  List<String> selectedCategoryItems = [];
  List<String> selectedTagItems = [];
  List<Map<String, List<String>>> categoryTags = List.from(Course.categoryTags);

  Map<String, bool> toggleTagMap = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) {
        if (current is CourseLoading &&
            current.actionType == CourseActionType.createCourse) {
          return true;
        }
        if (current is CourseCreateSuccess) {
          return true;
        }
        if (current is CourseFailure &&
            current.actionType == CourseActionType.createCourse) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CourseLoading) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseFailure) {
          MevTechUtilities.hideProgressIndicator(context);

          context.read<CourseCubit>().clearTempData();
          MevTechUtilities.errorToast(context, state.errorMessage);
        } else if (state is CourseCreateSuccess) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.successToast(context, state.message);

          context.goNamed(AppRouter.course);
          context.read<CourseCubit>().fetchCourses();
        }
      },
      builder: (context, state) {
        final courseCubit = context.read<CourseCubit>();

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {},
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Create Course',
                style: GoogleFonts.poppins(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Course Name',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      myTextField(
                        controller: courseCubit.name,
                        hintText: 'Enter Course Name',
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Course Title',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      myTextField(
                        controller: courseCubit.title,
                        hintText: 'Enter Course Title',
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Course Description',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      myTextField(
                        controller: courseCubit.description,
                        hintText: 'Enter Course Description',
                        maxLines: 3,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Course Image-URL',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: EdgeInsets.all(10.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.3,
                            color: Colors.grey,
                          ),
                        ),
                        child: TextFormField(
                          controller: courseCubit.imageUrl,
                          cursorHeight: 15,
                          cursorColor: Colors.black26,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'https://www.google.com',
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Category',
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          dropdownBtn(
                            value: spCategory,
                            hint: 'Select course category',
                            context: context,
                            items: categoryItems,
                            onChanged: (newValue) {
                              final tempValue = spCategory;
                              setState(() {
                                spCategory = newValue ?? spCategory;

                                if (newValue != null &&
                                    !selectedCategoryItems.contains(newValue)) {
                                  if (tempValue != null &&
                                      selectedCategoryItems
                                          .contains(tempValue)) {
                                    selectedCategoryItems.remove(tempValue);
                                  }
                                  selectedCategoryItems.add(newValue);
                                }
                              });
                            },
                          ),
                          SizedBox(height: 10.h),
                          Wrap(
                            children: List.generate(
                              selectedCategoryItems.length,
                              (index) {
                                final category = selectedCategoryItems[index];
                                return tagWidget(
                                  tag: category,
                                  onPressed: () {
                                    setState(() {
                                      selectedCategoryItems.removeAt(index);
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          showTags(context);
                        },
                        label: Text(
                          'Select Course Tags',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_drop_down),
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColor.primaryLight1,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        children:
                            List.generate(selectedTagItems.length, (index) {
                          final tag = selectedTagItems[index];
                          return tagWidget(
                              tag: tag,
                              onPressed: () {
                                setState(() {
                                  selectedTagItems.removeAt(index);
                                  toggleTagMap
                                      .removeWhere((key, value) => key == tag);
                                });
                              });
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 8.h),
                child: ElevatedButton(
                  onPressed: () {
                    courseCubit.createCourse(
                      categoryNames: selectedCategoryItems,
                      tagNames: selectedTagItems,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        width: 0.9,
                        color: Colors.black45,
                      ),
                    ),
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.grey.shade200,
                  ),
                  child: Container(
                    height: 45.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Create',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // List<TextInputFormatter> get textFormatters =>
  Widget tagWidget({required String tag, required void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton.icon(
        onPressed: null,
        label: Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black87,
            ),
          ),
        ),
        icon: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget myTextField({
    required String hintText,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return TextField(
      cursorColor: AppColor.primary,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontFamily: 'poppins',
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'poppins',
          fontSize: 13.sp,
          color: Colors.black38,
        ),
        filled: true,
        suffixIcon: suffixIcon,
        fillColor: Colors.grey.shade100,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
      ),
    );
  }

  Widget dropdownBtn({
    required String? value,
    required BuildContext context,
    required List<String> items,
    String? hint,
    void Function(String?)? onChanged,
  }) {
    return Card(
      color: AppColor.primaryLight1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // dropdownColor: Colors.red.shade100,
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          hint: Text(hint ?? ''),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          value: value,

          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void showTags(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogueSetState) {
            return Dialog(
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // shape: BoxShape.rectangle,
                  color: AppColor.primaryLight2,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 10),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        // shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: categoryTags.length,
                        itemBuilder: (context, index) {
                          var tagHeader = '';
                          var tags = <String>[];
                          categoryTags[index].forEach((key, value) {
                            tagHeader = key;
                            tags = value;
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('* $tagHeader'),
                              SizedBox(height: 10.sp),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Wrap(
                                  children:
                                      List.generate(tags.length, (subIndex) {
                                    final tag = tags[subIndex];
                                    return myCheckBox(
                                      tag: tag,
                                      value: toggleTagMap[tag] ?? false,
                                      onChanged: (newValue) {
                                        dialogueSetState(() {
                                          toggleTagMap[tag] = newValue ?? false;

                                          if (newValue != null &&
                                              newValue == true) {
                                            if (!selectedTagItems
                                                .contains(tag)) {
                                              selectedTagItems.add(tag);
                                            }
                                          }

                                          if (newValue == false) {
                                            toggleTagMap.remove(tag);
                                            selectedTagItems.remove(tag);
                                          }
                                        });
                                        setState(() {});
                                      },
                                    );
                                  }),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 0.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget myCheckBox({
    required String tag,
    required bool? value,
    required void Function(bool?)? onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      padding: EdgeInsets.only(left: 5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(fontSize: 12.sp),
          ),
          Checkbox(
            value: value,
            checkColor: Colors.white,
            activeColor: AppColor.primary,
            onChanged: onChanged,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
        ],
      ),
    );
  }
}


  // if (state is CourseSuccess) {
                              //   return Flexible(
                              //     child: MaterialButton(
                              //       // splashColor: Colors.red,
                              //       padding: const EdgeInsets.all(7),
                              //       clipBehavior: Clip.hardEdge,
                              //       minWidth: 0,
                              //       onPressed: courseCubit.compresseAndGetImage,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10),
                              //         side: const BorderSide(
                              //           color: Colors.grey,
                              //           width: 0.5,
                              //         ),
                              //       ),
                              //       // child: Container(
                              //       //   width: screenWidth * 0.45,
                              //       //   child: Column(
                              //       //     mainAxisSize: MainAxisSize.min,
                              //       //     children: [
                              //       //       if (state.file == null)
                              //       //         Container(
                              //       //           width: screenWidth * 0.4,
                              //       //           alignment: Alignment.center,
                              //       //           decoration: BoxDecoration(
                              //       //             border: Border.all(
                              //       //               width: 0.3,
                              //       //               color: Colors.grey,
                              //       //             ),
                              //       //           ),
                              //       //           child: Column(
                              //       //             mainAxisAlignment:
                              //       //                 MainAxisAlignment.center,
                              //       //             children: [
                              //       //               const Icon(
                              //       //                 Icons.photo,
                              //       //                 size: 60,
                              //       //                 color: Colors.black54,
                              //       //               ),
                              //       //               Text(
                              //       //                 state.imageText ??
                              //       //                     'Select Image',
                              //       //                 style: GoogleFonts.poppins(
                              //       //                   fontSize: 11,
                              //       //                   fontWeight:
                              //       //                       FontWeight.w500,
                              //       //                   // color: AppColor.primary,
                              //       //                 ),
                              //       //               ),
                              //       //               SizedBox(height: 5.h),
                              //       //             ],
                              //       //           ),
                              //       //         )
                              //       //       else
                              //       //         SizedBox(
                              //       //           height: 110.h,
                              //       //           width: double.infinity,
                              //       //           child: ClipRRect(
                              //       //             borderRadius:
                              //       //                 BorderRadius.circular(10),
                              //       //             child: Image.file(
                              //       //               state.file!,
                              //       //               fit: BoxFit.fill,
                              //       //             ),
                              //       //           ),
                              //       //         ),
                              //       //       SizedBox(height: 2.h),
                              //       //       const Icon(Icons.arrow_drop_down),
                              //       //     ],
                              //       //   ),
                              //       // ),
                              //     ),
                              //   );
                              // }
                              // return Container();
                              // SizedBox(
                              //   width: screenWidth * 0.4,
                              //   child: myTextField(
                              //     controller: courseCubit.price,
                              //     hintText: 'Enter Price',
                              //     keyboardType:
                              //         const TextInputType.numberWithOptions(
                              //       decimal: true,
                              //     ),
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.allow(
                              //         RegExp(r'^\d*\.?\d*'),
                              //       ),
                              //     ],
                              //   ),
                              // ),