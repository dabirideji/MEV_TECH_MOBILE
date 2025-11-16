import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/dropdown_btn.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class CreateCourseContentPage extends StatefulWidget {
  const CreateCourseContentPage({required this.courseId, super.key});

  final String courseId;

  @override
  State<CreateCourseContentPage> createState() =>
      _CreateCourseContentPageState();
}

class _CreateCourseContentPageState extends State<CreateCourseContentPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;

  TextEditingController courseContentTitle = TextEditingController();
  TextEditingController courseContentDescription = TextEditingController();
  TextEditingController courseContentVideoUrl = TextEditingController();
  TextEditingController courseContentSummary = TextEditingController();
  TextEditingController courseContentTranscript = TextEditingController();
  TextEditingController courseContentThumbnailUrl = TextEditingController();

  File? file;
  bool isPreview = true;
  bool isFree = true;
  int order = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) {
        if (current is CourseSuccess &&
            current.actionMethod == ActionMethod.creating &&
            current.routeName == AppRouter.createCourseContent) {
          return true;
        }
        if (current is CourseSuccess &&
            current.actionMethod == ActionMethod.notCreated &&
            current.routeName == AppRouter.createCourseContent) {
          return true;
        }
        if (current is CourseSuccess &&
            current.actionMethod == ActionMethod.created &&
            current.routeName == AppRouter.createCourseContent) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.creating) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.notCreated) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.errorToast(
              context, state.message ?? 'unable to complete action. try again');
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.created) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.successToast(
              context, state.message ?? 'succesfully created course content');

          context.pop();
        }
      },
      builder: (context, state) {
        final courseCubit = context.read<CourseCubit>();

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            courseCubit.resetState();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Create course content',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateForm
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Course Content Title',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        myTextField(
                          controller: courseContentTitle,
                          hintText: 'Title',
                          validator: FormValidator.customField,
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Course Content Description',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        myTextField(
                          controller: courseContentDescription,
                          hintText: 'Description',
                          maxLines: 3,
                          validator: FormValidator.customField,
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Course Content VideoUrl',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        if (state is CourseSuccess)
                          Container(
                            padding: EdgeInsets.all(7.r),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.3,
                                color: Colors.grey,
                              ),
                            ),
                            child: TextFormField(
                              controller: courseContentVideoUrl,
                              cursorHeight: 15,
                              cursorColor: Colors.black26,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                suffix: state.actionMethod ==
                                        ActionMethod.fetching
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.black38,
                                        ),
                                      )
                                    : state.actionMethod ==
                                                ActionMethod.fetched &&
                                            state.isVideoEmbeddable
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : state.actionMethod ==
                                                    ActionMethod.fetched &&
                                                state.isVideoEmbeddable == false
                                            ? const Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              )
                                            : null,
                                hintText: 'https://www.google.com',
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) => courseCubit.resetState(),
                            ),
                          ),
                        SizedBox(height: 7.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              courseCubit
                                  .checkIfEmbedable(courseContentVideoUrl.text);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                            ),
                            child: Text(
                              'verify video',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Course Content ThumbnailUrl',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        myTextField(
                          controller: courseContentThumbnailUrl,
                          hintText: 'ThumbnailUrl',
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Course Content Transcript',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        myTextField(
                          controller: courseContentTranscript,
                          hintText: 'Transcript',
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          'Course Content Summary',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        myTextField(
                          controller: courseContentSummary,
                          hintText: 'Summary',
                        ),
                        SizedBox(height: 7.h),
                        Row(
                          children: [
                            DropdownBtn(
                              hint: '0',
                              value: order,
                              items: List.generate(101, (index) {
                                return index;
                              }),
                              onChanged: (newValue) {
                                setState(() {
                                  order = newValue ?? 0;
                                });
                              },
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Order',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        CheckboxListTile(
                          value: isPreview,
                          title: Text(
                            'IsPreview',
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.blueDarkest,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColor.primary,
                          dense: true,
                          onChanged: (newValue) {
                            setState(() {
                              isPreview = !isPreview;
                            });
                          },
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                        CheckboxListTile(
                          value: isFree,
                          title: Text(
                            'IsFree',
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.blueDarkest,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColor.primary,
                          dense: true,
                          onChanged: (newValue) {
                            setState(() {
                              isFree = !isFree;
                            });
                          },
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                        // Center(
                        //     child: TextButton(
                        //         onPressed: () {
                        //           courseCubit.checkIfEmbedable(
                        //               'https://www.youtube.com/watch?v=JQvlGwI4Vxw');
                        //         },
                        //         child: Text('Test codes'))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 8.h),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _autovalidateForm = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      courseCubit.createCourseContent(
                        courseContentCourseId: widget.courseId,
                        courseContentTitle: courseContentTitle.text,
                        courseContentDescription: courseContentDescription.text,
                        courseContentVideoUrl: courseContentVideoUrl.text,
                        courseContentSummary: courseContentSummary.text,
                        courseContentTranscript: courseContentTranscript.text,
                        courseContentThumbnailFile: file,
                        courseContentThumbnailUrl:
                            courseContentThumbnailUrl.text,
                        order: order,
                        isPreview: isPreview,
                        isFree: isFree,
                      );
                    }
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
                    height: 40.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Create content',
                      style: TextStyle(
                        fontSize: 13.sp,
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

  Widget myTextField({
    required String hintText,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
        isDense: true,
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
      validator: validator,
    );
  }
}
