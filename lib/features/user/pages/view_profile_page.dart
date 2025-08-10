import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/data/models/user_model.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    UserModel? user;
    if (authState is AuthLoginSuccess) {
      user = authState.model.user;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColor.primaryTint,
                child: Icon(
                  Icons.person_pin,
                  size: 100.r,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                user?.isInstructor ?? false ? 'Instructor' : 'Student',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 25.h),
              profileDetails(
                'UserName',
                '${user?.username}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'FullName',
                '${user?.firstName} ${user?.lastName}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Email Address',
                '${user?.email}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Phone Number',
                '${user?.phoneNumber}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Created On',
                MevTechUtilities.formatDateTime(user?.createdAt),
              ),
              SizedBox(height: 25.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: AppColor.primary,
                      width: 1.5,
                    ),
                  ),
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: AppColor.primary,
                ),
                child: Container(
                  height: 45.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Unsubscribe From Premium',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
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

  Widget profileDetails(String title, String titleValue) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.r),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            titleValue,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
