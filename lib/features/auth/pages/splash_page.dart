import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthCubit>().state is! AuthLoading) {
        context.read<AuthCubit>().checkUserSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading &&
              state.actionType == AuthActionType.sessionCheck) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Image.asset(
                    'assets/splash/Splah-image.png',
                    width: MediaQuery.sizeOf(context).width * 0.80,
                  ),
                  Container(
                    width: 150,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade400,
                      color: Colors.white,
                      // value: 0.6,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AuthFailure &&
              state.actionType == AuthActionType.sessionCheck) {
            return Column(
              mainAxisAlignment: .center,
              children: [
                Container(
                  margin: EdgeInsets.all(15.r),
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        '⚠️ ${state.errorMessage}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton.icon(
                        onPressed: context.read<AuthCubit>().checkUserSession,
                        icon: Icon(
                          Icons.refresh,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                MaterialButton(
                  onPressed: context.read<AuthCubit>().logOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Back to login',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(Icons.login, color: Colors.white, size: 30.sp),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
