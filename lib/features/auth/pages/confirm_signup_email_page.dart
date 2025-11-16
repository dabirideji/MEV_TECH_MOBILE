import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class ConfirmSignupEmailPage extends StatefulWidget {
  const ConfirmSignupEmailPage({super.key});

  @override
  State<ConfirmSignupEmailPage> createState() => _ConfirmSignupEmailPageState();
}

class _ConfirmSignupEmailPageState extends State<ConfirmSignupEmailPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().sendEmailConfirmToken();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          if (state.verifyStatus.isLoading) {
            MevTechUtilities.showProgressIndicator(context);
          } else if (state.sendStatus.isFailure) {
            MevTechUtilities.errorToast(
                context, state.sendStatus.error ?? 'An Error Occured');
          } else if (state.verifyStatus.isFailure) {
            MevTechUtilities.hideProgressIndicator(context);

            MevTechUtilities.errorToast(
                context, state.verifyStatus.error ?? 'An Error Occured');
          } else if (state.verifyStatus.isSuccess) {
            MevTechUtilities.hideProgressIndicator(context);

            MevTechUtilities.successToast(context, state.message);
            context.goNamed(AppRouter.login);
          } else if (state.sendStatus.isSuccess) {
            MevTechUtilities.successToast(context, state.message);
          }
        }
      },
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

        if (state is AuthRegisterSuccess && state.sendStatus.isFailure) {
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
                        width: 40.w,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        'OTP code Not Sent',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: Colors.black26,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          state.sendStatus.error ??
                              'Unable to complete action, try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: authCubit.sendEmailConfirmToken,
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
                          'Resend OTP',
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

        if (state is AuthRegisterSuccess) {
          return Scaffold(
            appBar: AppBar(),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/email-icon.png',
                          width: 40.w,
                          color: AppColor.primary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          'OTP code verification',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (state.sendStatus.isLoading)
                        Center(
                          child: Text(
                            'Sending...',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary,
                            ),
                          ),
                        ),
                      if (state.sendStatus.isSuccess)
                        Text(
                          'We have sent an OTP code to your email ${authCubit.userEmail} '
                          'Enter the OTP code below to verify',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      SizedBox(height: 30.h),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          child: TextFormField(
                            cursorColor: AppColor.primary,
                            controller: authCubit.txtToken,
                            keyboardType: TextInputType.number,
                            enabled: state.sendStatus.isSuccess,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: state.sendStatus.isSuccess
                                  ? 'Enter OTP code'
                                  : 'please wait',
                              hintStyle: TextStyle(
                                fontSize: 11.5.sp,
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
                            validator: FormValidator.customField,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      ElevatedButton(
                        onPressed: state.sendStatus.isLoading
                            ? null
                            : () {
                                setState(() {
                                  _autovalidateForm = true;
                                });

                                if (_formKey.currentState!.validate()) {
                                  authCubit.verifyEmailConfirmToken();
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
                          child: state.sendStatus.isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Verify',
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
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Error sending OTP'),
          ),
        );
      },
    );
  }
}
