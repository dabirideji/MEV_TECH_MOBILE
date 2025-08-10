import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current is AuthLoading &&
            current.actionType == AuthActionType.resetPassword) {
          return true;
        }
        if (current is AuthPasswordResetSuccess &&
            current.actionType == AuthActionType.resetPassword) {
          return true;
        }
        if (current is AuthFailure &&
            current.actionType == AuthActionType.resetPassword) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is AuthLoading) {
          MevTechUtilities.progressIndicator(context);
        } else if (state is AuthFailure) {
          Navigator.of(context).pop();

          MevTechUtilities.errorToast(context, state.errorMessage);
        } else if (state is AuthPasswordResetSuccess) {
          Navigator.of(context).pop();

          successBottomSheet(context, message: state.message);
        }
      },
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();
        var isPasswordVisible = false;

        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/privacy-safety.jpg',
                      width: 80.w,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Create new password',
                    style: GoogleFonts.poppins(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Your new password must be different from  '
                    'previously used passwords',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      // fontSize: 23.sp,
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
                          'Password',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextField(
                          cursorColor: AppColor.primary,
                          controller: authCubit.txtPassword,
                          obscureText: !isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter Password',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13.sp,
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
                          'Confirm Password',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextField(
                          cursorColor: AppColor.primary,
                          controller: authCubit.txtConfirmPassword,
                          obscureText: !isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Confirm Password',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 13.sp,
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
                    onPressed: () {
                      authCubit.resetPassword(isInstructor: false);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Reset Password',
                        style: GoogleFonts.poppins(
                          fontSize: 15.5.sp,
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
      },
    );
  }

  dynamic successBottomSheet(BuildContext context, {required String message}) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: 100.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColor.primary,
                      size: 35.r,
                    ),
                    Image.asset(
                      'assets/images/success-icon.png',
                      width: 150,
                    ),
                    Icon(
                      Icons.star,
                      color: AppColor.primary,
                      size: 35.r,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Text(
                  textAlign: TextAlign.center,
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Your password has been changed successfully '
                    'click the done button to continue to login',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(AppRouter.login);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Done',
                        style: GoogleFonts.poppins(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
