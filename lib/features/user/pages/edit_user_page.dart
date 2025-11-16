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
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/logic/user-cubit/user_cubit.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var isPasswordVisible = false;

    final authCubit = context.read<AuthCubit>();
    final authState = context.watch<AuthCubit>().state;
    UserModel? user;
    if (authState is AuthLoginSuccess) {
      user = authState.model.user;
    }

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserSuccess && state.updateUserStatus.isLoading) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is UserSuccess && state.updateUserStatus.isFailure) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.errorToast(
            context,
            state.updateUserStatus.error ?? 'Unable to update user. try again',
          );
        } else if (state is UserSuccess && state.updateUserStatus.isSuccess) {
          MevTechUtilities.hideProgressIndicator(context);

          authCubit.updateUserdata(state.user);

          MevTechUtilities.successToast(context, state.message);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        final userCubit = context.read<UserCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'First Name',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  myTextField(
                    controller: userCubit.txtFirstName,
                    hintText: 'First Name',
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
                  SizedBox(height: 5.h),
                  myTextField(
                    controller: userCubit.txtLastName,
                    hintText: 'Last Name',
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
                  SizedBox(height: 5.h),
                  myTextField(
                    controller: userCubit.txtUsername,
                    hintText: 'Enter UserName',
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  myTextField(
                    controller: userCubit.txtEmail,
                    hintText: 'Enter Email Address',
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
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
                  SizedBox(height: 5.h),
                  myTextField(
                    controller: userCubit.txtPhoneNumber,
                    hintText: 'Enter Phone Number',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 8,
                        top: 15,
                        bottom: 9,
                      ),
                      child: Text(
                        '+234',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          // color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      userCubit.updateUser(
                        state.user?.id ?? user?.id,
                      );
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
                        'Save',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: AppColor.primary,
                          width: 1.5,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.primary,
                    ),
                    child: Container(
                      height: 40.h,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
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

  Widget myTextField({
    required String hintText,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool enabled = true,
  }) {
    return TextField(
      cursorColor: AppColor.primary,
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: 13.sp,
      ),
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
    );
  }
}
