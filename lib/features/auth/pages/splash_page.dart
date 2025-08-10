import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.primaryLight1,
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Mev',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 25.sp,
                        decoration: TextDecoration.overline,
                        decorationColor: AppColor.secondary,
                        decorationThickness: 2,
                      ),
                      children: [
                        TextSpan(
                          text: 'Tech',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 25.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  if (state is AuthLoading &&
                      state.actionType == AuthActionType.sessionCheck)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade400,
                        color: AppColor.primary,
                        stopIndicatorColor: Colors.black,
                        trackGap: 100,
                        minHeight: 8,
                      ),
                    )
                  else if (state is AuthFailure &&
                      state.actionType == AuthActionType.sessionCheck)
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                state.errorMessage,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextButton.icon(
                                onPressed:
                                    context.read<AuthCubit>().checkUserSession,
                                icon: const Icon(
                                  Icons.refresh,
                                  color: AppColor.secondary,
                                ),
                                label: Text(
                                  'Retry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          onPressed: context.read<AuthCubit>().logOut,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Back to login',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              const Icon(
                                Icons.login,
                                color: AppColor.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
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
