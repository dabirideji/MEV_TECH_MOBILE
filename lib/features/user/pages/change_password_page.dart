import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/core/utils/colors.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isOldPasswordVisible = false;
    var isPasswordVisible = false;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/privacy-safety.jpg',
                  width: 60.w,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Change password',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              // ignore: prefer_const_constructors
              Text(
                'Your new password must be different\nfrom  '
                'previously used passwords',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30.h),
              StatefulBuilder(builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Old Password',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextField(
                      cursorColor: AppColor.primary,
                      // controller: authCubit.txtPassword,
                      obscureText: !isOldPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Old Password',
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black38,
                        ),
                        filled: true,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              isOldPasswordVisible = !isOldPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isOldPasswordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextField(
                      cursorColor: AppColor.primary,
                      // controller: authCubit.txtPassword,
                      obscureText: !isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'New Password',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black38,
                        ),
                        filled: true,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextField(
                      cursorColor: AppColor.primary,
                      // controller: authCubit.txtConfirmPassword,
                      obscureText: !isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Confirm New Password',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black38,
                        ),
                        filled: true,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                ),
                child: Container(
                  height: 40.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
