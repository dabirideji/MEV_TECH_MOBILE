import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/core/utils/constants.dart';
import 'package:template/data/google_signin.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/cubit/Login-Signup/login_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.userType = UserType.student, super.key});

  final String userType;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;

    final authCubit = context.read<AuthCubit>();

    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current is AuthLoading &&
            current.actionType == AuthActionType.login) {
          return true;
        }
        if (current is AuthLoginSuccess &&
            current.actionType == AuthActionType.login) {
          return true;
        }
        if (current is AuthFailure &&
            current.actionType == AuthActionType.login) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is AuthLoading) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is AuthFailure) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.errorToast(context, state.errorMessage);
        } else if (state is AuthLoginSuccess) {
          MevTechUtilities.hideProgressIndicator(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            // height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hex-login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 40.w),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateForm
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Welcome ',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Back',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            widget.userType == UserType.instructor
                                ? 'Sign in to continue to your dashboard'
                                : 'Sign in to continue your learning journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.5.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        myTextField(
                          controller: authCubit.txtEmail,
                          hintText: 'your@email.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          validator: FormValidator.validateEmail,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return myTextField(
                              controller: authCubit.txtPassword,
                              obscureText: !isPasswordVisible,
                              hintText: '********',
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(
                                    () {
                                      isPasswordVisible = !isPasswordVisible;
                                    },
                                  );
                                },
                                icon: Icon(
                                  isPasswordVisible == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20.r,
                                ),
                              ),
                              validator: FormValidator.validatePassword,
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.pushNamed(AppRouter.passResetToken);
                              authCubit.clearField();
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: AppColor.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.5.sp,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _autovalidateForm = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              authCubit.loginUser(widget.userType);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppColor.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Container(
                            height: 45.h,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {
                            // authCubit.signInWithGoogle();
                            GoogleSigninService.initiateOAuthLogin(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                width: 0.9,
                                color: Colors.black45,
                              ),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: AppColor.primary,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/google.png',
                                width: 18.w,
                                height: 18.h,
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                height: 45.h,
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign in with Google',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            context.pushNamed(AppRouter.signUp);
                            authCubit.clearField();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dont Have An Account?',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
    String? Function(String?)? validator,
    IconData? prefixIcon,
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
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'poppins',
          fontSize: 13.sp,
          color: Colors.black38,
        ),
        filled: true,
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: Colors.black54,
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
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 0.9,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.1,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
