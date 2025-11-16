import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;
  bool isPasswordVisible = false;
  bool isconfirmPasswordVisible = false;
  bool agreePolicy = false;
  bool showPolicyError = false;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    final signUpCubit = context.read<AuthCubit>();
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current is AuthLoading &&
            current.actionType == AuthActionType.register) {
          return true;
        }
        if (current is AuthRegisterSuccess) {
          return true;
        }
        if (current is AuthFailure &&
            current.actionType == AuthActionType.register) {
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
        } else if (state is AuthRegisterSuccess && state.sendStatus.isInitial) {
          MevTechUtilities.hideProgressIndicator(context);

          context.pushReplacementNamed(AppRouter.confirmSignupEmail);
        } else {
          MevTechUtilities.hideProgressIndicator(context);
        }
      },
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            signUpCubit.clearField();
          },
          child: Scaffold(
            body: Container(
              // height: screenHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hex-login.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 15.h, left: 25.w, right: 25.w),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autovalidateForm
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Create ',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Your Account',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Center(
                              child: Text(
                                'Join thousands of organizations transforming through learning',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 12.sp,
                                  // fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'UserName',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            myTextField(
                              controller: signUpCubit.txtUsername,
                              hintText: 'john_joe',
                              prefixIcon: const Icon(Icons.person),
                              validator: FormValidator.validateUsername,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'First Name',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            myTextField(
                              controller: signUpCubit.txtFirstName,
                              hintText: 'John',
                              validator: FormValidator.validateFirstName,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Last Name',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            myTextField(
                              controller: signUpCubit.txtLastName,
                              hintText: 'Doe',
                              validator: FormValidator.validateLastName,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            myTextField(
                              controller: signUpCubit.txtPhoneNumber,
                              hintText: '+234 (810) 123-4567',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                ),
                                child: const Icon(Icons.phone),
                              ),
                              validator: FormValidator.validatePhoneNumber,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Email',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            myTextField(
                              controller: signUpCubit.txtEmail,
                              hintText: 'your@email.com',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email),
                              validator: FormValidator.validateEmail,
                            ),
                            SizedBox(height: 10.h),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    myTextField(
                                      controller: signUpCubit.txtPassword,
                                      hintText: '********',
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !isPasswordVisible,
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          isPasswordVisible == true
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                      validator: FormValidator.validatePassword,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Confirm Password',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    myTextField(
                                      controller:
                                          signUpCubit.txtConfirmPassword,
                                      hintText: '********',
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !isconfirmPasswordVisible,
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            isconfirmPasswordVisible =
                                                !isconfirmPasswordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          isconfirmPasswordVisible == true
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                      validator: (value) {
                                        return FormValidator
                                            .validateConfirmPassword(
                                          value,
                                          signUpCubit.txtPassword.text,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: showPolicyError && isClicked
                                            ? Border.all(
                                                width: 1.5,
                                                color: Colors.red.shade300,
                                              )
                                            : null,
                                      ),
                                      child: CheckboxListTile(
                                        value: agreePolicy,
                                        title: Text(
                                          ' I agree to the Terms of Service and Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 10.5.sp,
                                          ),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppColor.primary,
                                        dense: true,
                                        onChanged: (newValue) {
                                          setState(
                                            () {
                                              agreePolicy = newValue ?? false;
                                              showPolicyError = !agreePolicy;
                                            },
                                          );
                                        },
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                          vertical: -4,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: showPolicyError && isClicked,
                                      child: Container(
                                        // width: double.infinity,
                                        margin: EdgeInsets.only(top: 5.h),
                                        padding: EdgeInsets.all(2.r),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Colors.red.shade100,
                                        ),
                                        child: Text(
                                          'please agree to the Terms before proceeding',
                                          style: TextStyle(
                                            fontSize: 10.5.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 5.h),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _autovalidateForm = true;
                                  isClicked = true;
                                  showPolicyError = !agreePolicy;
                                });
                                if (!agreePolicy) return;
                                if (_formKey.currentState!.validate()) {
                                  signUpCubit.registerUser();
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
                                height: 40.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already Have An Account?',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
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
    String? Function(String?)? validator,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return TextFormField(
      cursorColor: AppColor.primary,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      // style: const TextStyle(),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'poppins',
          fontSize: 12.sp,
          color: Colors.black38,
        ),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
      validator: validator,
    );
  }
}
