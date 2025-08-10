import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class VerifyPasswordResetPage extends StatelessWidget {
  const VerifyPasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current is AuthLoading &&
            current.actionType == AuthActionType.verifyPasswordRequest) {
          return true;
        }
        if (current is AuthPasswordResetSuccess &&
            current.actionType == AuthActionType.verifyPasswordRequest) {
          return true;
        }
        if (current is AuthFailure &&
            current.actionType == AuthActionType.verifyPasswordRequest) {
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
          MevTechUtilities.showToast(context, state.message);
          context.pushReplacementNamed(AppRouter.resetPass);
        }
      },
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

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
                      'assets/images/email-icon.png',
                      width: 80.w,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'OTP code verification',
                    style: GoogleFonts.poppins(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'We have sent an OTP code to your email ${authCubit.userEmail} '
                    'Enter the OTP code below to verify',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      // fontSize: 23.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      child: TextField(
                        cursorColor: AppColor.primary,
                        controller: authCubit.txtToken,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter OTP code',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.black38,
                          ),
                          filled: true,
                          prefixIcon: const Icon(Icons.email_outlined),
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
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: authCubit.verifyPasswordResetToken,
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
                        'Verify',
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
}
