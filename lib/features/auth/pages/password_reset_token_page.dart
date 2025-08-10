import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class PasswordResetTokenPage extends StatefulWidget {
  const PasswordResetTokenPage({super.key});

  @override
  State<PasswordResetTokenPage> createState() => _PasswordResetTokenPageState();
}

class _PasswordResetTokenPageState extends State<PasswordResetTokenPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        if (current is AuthLoading &&
            current.actionType == AuthActionType.sendPasswordRequest) {
          return true;
        }
        if (current is AuthPasswordResetSuccess &&
            current.actionType == AuthActionType.sendPasswordRequest) {
          return true;
        }
        if (current is AuthFailure &&
            current.actionType == AuthActionType.sendPasswordRequest) {
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
          context.pushNamed(AppRouter.verifyPassToken);
        }
      },
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateForm
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/reset-password.jpg',
                        width: 170.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Reset Password',
                      style: GoogleFonts.poppins(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Enter the email associated with your account and '
                      'we’ll send an email with instructions to reset your password',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        // fontSize: 23.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextFormField(
                      cursorColor: AppColor.primary,
                      controller: authCubit.txtEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'your@email.com',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: Colors.black38,
                        ),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black54,
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
                      validator: FormValidator.validateEmail,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _autovalidateForm = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          authCubit.sendPasswordResetToken();
                          _formKey.currentState?.reset();
                          _autovalidateForm = false;
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
                        height: 50.h,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Send',
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
          ),
        );
      },
    );
  }
}
