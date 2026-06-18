import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/core/utils/constants.dart';

class LoginEntryPage extends StatefulWidget {
  const LoginEntryPage({super.key});

  @override
  State<LoginEntryPage> createState() => _LoginEntryPageState();
}

class _LoginEntryPageState extends State<LoginEntryPage> {
  bool studentTile = false;
  bool instructorTile = false;
  String userType = UserType.student;

  @override
  void initState() {
    super.initState();
    studentTile = false;
    instructorTile = false;
    userType = UserType.student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.people_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                fontSize: 27.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Choose your account type to continue',
              style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            ),
            SizedBox(height: 30.h),
            AnimatedContainer(
              margin:
                  EdgeInsets.symmetric(horizontal: studentTile ? 7.w : 10.w),
              decoration: BoxDecoration(
                color: studentTile ? AppColor.primaryLight2 : Colors.white,
                border: Border.all(
                  color: studentTile
                      ? AppColor.primaryFaint
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: studentTile
                    ? const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : const [],
              ),
              duration: const Duration(milliseconds: 200),
              child: MaterialButton(
                splashColor: AppColor.primaryLight2,
                onPressed: () {
                  setState(() {
                    studentTile = true;
                    instructorTile = false;
                    userType = UserType.student;
                  });
                },
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: studentTile ? 12.h : 10.h),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (studentTile)
                        CircleAvatar(
                          backgroundColor: AppColor.primary,
                          radius: 13.r,
                          child: const Icon(
                            Icons.adjust,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                        ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Container(
                        padding: EdgeInsets.all(studentTile ? 12.r : 10.r),
                        decoration: BoxDecoration(
                          color: studentTile
                              ? AppColor.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          size: 27.r,
                          color: studentTile ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    'Student Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5.sp,
                    ),
                  ),
                  subtitle: Text(
                    'Access your courses,\nassignments, and\ngrades',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: studentTile ? Colors.black54 : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AnimatedContainer(
              margin:
                  EdgeInsets.symmetric(horizontal: instructorTile ? 7.w : 10.w),
              decoration: BoxDecoration(
                color: instructorTile ? AppColor.primaryLight2 : Colors.white,
                border: Border.all(
                  color: instructorTile
                      ? AppColor.primaryFaint
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: instructorTile
                    ? const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          offset: Offset(0, 8),
                        ),
                      ]
                    : const [],
              ),
              duration: const Duration(milliseconds: 200),
              child: MaterialButton(
                splashColor: AppColor.primaryLight2,
                onPressed: () {
                  setState(() {
                    instructorTile = true;
                    studentTile = false;
                    userType = UserType.instructor;
                  });
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: instructorTile ? 12.h : 10.h),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (instructorTile)
                        CircleAvatar(
                          backgroundColor: AppColor.primary,
                          radius: 13.r,
                          child: const Icon(
                            Icons.adjust,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                        ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Container(
                        padding: EdgeInsets.all(instructorTile ? 12.r : 10.r),
                        decoration: BoxDecoration(
                          color: instructorTile
                              ? AppColor.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.menu_book_outlined,
                          size: 27.r,
                          color: instructorTile ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    'Instructor Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5.sp,
                    ),
                  ),
                  subtitle: Text(
                    'Manage courses,\nstudents, and\nassignments',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: instructorTile ? Colors.black54 : Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            ElevatedButton(
              onPressed: studentTile || instructorTile
                  ? () {
                      context.pushNamed(AppRouter.login, extra: userType);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: studentTile || instructorTile
                    ? AppColor.primary
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
              ),
              child: studentTile || instructorTile
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        const Icon(
                          Icons.arrow_forward_ios,
                        )
                      ],
                    )
                  : Text(
                      'Select an Option',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(
                  child: Text(
                    'Need help? Contact support at ',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'support@mevtech.com',
                      style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
