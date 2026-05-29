import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/logic/user-cubit/user_cubit.dart';
import 'package:mevtech/features/user/user-widget/user_expanded_image.dart';
import 'package:mevtech/features/user/user-widget/user_image.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userState = context.watch<UserCubit>().state;
    final user = context.watch<AuthCubit>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (user?.profilePictureUrl != null)
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: UserImage(
                      user?.profilePictureUrl! ?? '',
                      onTap: () {
                        UserFullImage.expand(
                          context,
                          user?.profilePictureUrl! ?? '',
                        );
                      },
                    ),

                    // userImage(user?.profilePictureUrl! ?? ''),
                  ),
                )
              else
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: Image.asset('assets/images/avatar.jpg'),
                  ),
                ),
              SizedBox(height: 5.h),
              Text(
                user?.firstName.toUpperCase() ?? 'Student',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 25.h),
              profileDetails('UserName', '${user?.username}'),
              SizedBox(height: 15.h),
              profileDetails(
                'FullName',
                '${user?.firstName} ${user?.lastName}',
              ),
              SizedBox(height: 15.h),
              profileDetails('Email Address', '${user?.email}'),
              SizedBox(height: 15.h),
              profileDetails('Phone Number', '${user?.phoneNumber}'),
              SizedBox(height: 15.h),
              profileDetails(
                'Joined On',
                MevTechUtilities.formatDateTime(user?.createdAt),
              ),
              // SizedBox(height: 25.h),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       side: const BorderSide(
              //         color: AppColor.primary,
              //         width: 1.5,
              //       ),
              //     ),
              //     backgroundColor: Colors.green.shade100,
              //     foregroundColor: AppColor.primary,
              //   ),
              //   child: Container(
              //     height: 40.h,
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     child: Text(
              //       'Unsubscribe From Premium',
              //       style: TextStyle(
              //         fontSize: 13.sp,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.red,
              //       ),
              //     ),
              //   ),
              // ),
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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          Text(
            titleValue,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
