import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/home/home_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/logic/user-cubit/user_cubit.dart';
import 'package:template/features/user/user-widget/user_image.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    final authSuccess = context.read<AuthCubit>().state as AuthLoginSuccess;
    context.read<UserCubit>().fetchSavedUserData(authSuccess.model.user);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final authCubit = context.read<AuthCubit>();
    final homeCubit = context.read<HomeCubit>();

    UserModel? user;

    if (authState is AuthLoginSuccess) {
      user = authState.model.user;
    }

    return BlocConsumer<UserCubit, UserState>(
      listener: (BuildContext context, UserState state) {
        if (state.imageUploadStatus.isSuccess) {
          authCubit.updateUserdata(state.user);

          MevTechUtilities.successToast(context, state.message);
        } else if (state.imageUploadStatus.isFailure) {
          MevTechUtilities.errorToast(
            context,
            state.imageUploadStatus.error ?? 'Image upload failed. try again',
          );
          context.read<UserCubit>().resetState();
        }
      },
      builder: (context, state) {
        final userCubit = context.read<UserCubit>();
        return Scaffold(
          body: Center(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  collapsedHeight: 70,
                  expandedHeight: 70,
                  backgroundColor: Colors.white60,
                  forceElevated: true,
                  pinned: true,
                  flexibleSpace: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                            // color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.file != null)
                          Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  height: 80.h,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Image.file(
                                        state.file!,
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 40,
                                  right: 0,
                                  bottom: 0,
                                  child: state.imageUploadStatus.isLoading
                                      ? SizedBox(
                                          height: 10.h,
                                          width: 10.w,
                                          child:
                                              const CircularProgressIndicator(
                                            color: AppColor.secondary,
                                            strokeWidth: 5,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed:
                                              userCubit.compresseAndGetImage,
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 30.w,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          )
                        else if (state.user?.profilePictureUrl != null)
                          Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  height: 80.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: UserImage(
                                        state.user?.profilePictureUrl! ?? ''),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 40,
                                  right: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    onPressed: userCubit.compresseAndGetImage,
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 30.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  height: 80.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child:
                                        Image.asset('assets/images/avatar.jpg'),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 40,
                                  right: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    onPressed: userCubit.compresseAndGetImage,
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 30.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            '${user?.firstName} ${user?.lastName}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        menuItems(
                          leading: Icons.person_pin_outlined,
                          title: 'View Profile',
                          onTap: () {
                            context.pushNamed(AppRouter.viewProfile);
                          },
                        ),
                        SizedBox(height: 20.h),
                        menuItems(
                          leading: Icons.person_add_alt,
                          title: 'Edit Profile',
                          onTap: () {
                            userCubit.populateData(user);
                            context.pushNamed(AppRouter.editUser);
                          },
                        ),
                        SizedBox(height: 20.h),
                        menuItems(
                          leading: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: () {},
                        ),
                        SizedBox(height: 20.h),
                        menuItems(
                          leading: Icons.lock_outline,
                          title: 'Change Password',
                          onTap: () {
                            context.pushNamed(AppRouter.changePassword);
                          },
                        ),
                        SizedBox(height: 20.h),
                        menuItems(
                          leading: Icons.logout_outlined,
                          title: 'Log Out',
                          onTap: () {
                            MevTechUtilities.showAnimatedAlert(
                              context: context,
                              message: 'You will be logged out. Continue?',
                              onConfirm: () {
                                authCubit.logOut();
                                homeCubit.resetValue();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget menuItems({
    required IconData leading,
    required String title,
    required void Function()? onTap,
  }) {
    return ListTile(
      // iconColor: AppColor.primary,
      shape: NonUniformBorder(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
        topWidth: 0.2,
        bottomWidth: 0.5,
        leftWidth: 0.3,
        rightWidth: 0.3,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
      ),
      hoverColor: Colors.transparent,
      onTap: onTap,
      leading: CircleAvatar(
        radius: 15.r,
        backgroundColor: AppColor.primaryTint,
        child: Icon(
          leading,
          size: 17.w,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15.r,
      ),
    );
  }
}
