import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/utils/colors.dart';

class QuizModeContainer extends StatelessWidget {
  const QuizModeContainer({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.features,
    required this.buttonText,
    super.key,
    this.onPressed,
    this.buttonColor = const Color(0xff2C69F5),
    this.showDuration = false,
  });

  final Widget icon;
  final String title;
  final String subTitle;
  final List<String> features;
  final void Function()? onPressed;
  final Color? buttonColor;

  final String buttonText;
  final bool showDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: containerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
          // border: Border.all(),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.5,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // header container
          Container(
            decoration: BoxDecoration(
              color: buttonColor,
              //(0xff2D69F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(25.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      icon,
                      if (showDuration)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade200.withAlpha(70),
                            borderRadius: BorderRadius.circular(360.r),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '30 min',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.all(25.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Column(
                  children: List.generate(features.length, (index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 4.r,
                              backgroundColor: Colors.black26,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              features[index],
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        const Icon(Icons.arrow_forward),
                      ],
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
}
