import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/logic/user-cubit/user_cubit.dart';

class ViewProfilePage extends StatelessWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userState = context.watch<UserCubit>().state;
    UserModel? user;
    if (authState is AuthLoginSuccess) {
      user = authState.model.user;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (userState.user?.profilePictureUrl != null)
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: userImage(userState.user?.profilePictureUrl! ?? ''),
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
                userState.user?.firstName ?? 'Student',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 25.h),
              profileDetails(
                'UserName',
                '${userState.user?.username}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'FullName',
                '${userState.user?.firstName} ${userState.user?.lastName}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Email Address',
                '${userState.user?.email}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Phone Number',
                '${userState.user?.phoneNumber}',
              ),
              SizedBox(height: 15.h),
              profileDetails(
                'Created On',
                MevTechUtilities.formatDateTime(userState.user?.createdAt),
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
                  height: 40.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Unsubscribe From Premium',
                    style: TextStyle(
                      fontSize: 13.sp,
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
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
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

  Widget userImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: AppColor.secondary,
            backgroundColor: AppColor.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => IconButton(
          onPressed: () {
            // userImage(imageUrl);
          },
          icon: const Icon(Icons.person_off)),
      fit: BoxFit.fill,
    );
  }
}
