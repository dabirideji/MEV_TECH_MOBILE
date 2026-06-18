import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/logic/user-cubit/user_cubit.dart';
import 'package:mevtech/features/user/user-widget/user_expanded_image.dart';
import 'package:mevtech/features/user/user-widget/user_image.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    // final authSuccess = context.read<AuthCubit>().state as AuthLoginSuccess;
    final currentUser = context.read<AuthCubit>().currentUser;
    context.read<UserCubit>().fetchSavedUserData(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    // final authState = context.read<AuthCubit>().state;
    final authCubit = context.read<AuthCubit>();
    final homeCubit = context.read<HomeCubit>();

    // UserModel? user ;

    final user = context.watch<AuthCubit>().currentUser;

    // if (authState is AuthLoginSuccess) {
    //   user = authState.model.user;
    // }

    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (previous, current) => previous != current,
      listener: (BuildContext context, UserState state) {
        if (state.deleteUserAccountStatus.isLoading) {
          MevTechUtilities.showProgressIndicator(context);
        }
        if (state.deleteUserAccountStatus.isFailure) {
          MevTechUtilities.hideProgressIndicator(context);
          MevTechUtilities.errorToast(
            context,
            state.deleteUserAccountStatus.error ??
                'Delete Action failed. try again',
          );
          context.read<UserCubit>().resetState();
        }

        if (state.deleteUserAccountStatus.isSuccess) {
          MevTechUtilities.hideProgressIndicator(context);
          MevTechUtilities.successToast(context, state.message);
          authCubit.logOut();
          homeCubit.resetValue();
        }

        if (state.imageUploadStatus.isSuccess) {
          authCubit.updateUserdata(state.user);

          MevTechUtilities.successToast(context, state.message);
        }

        if (state.imageUploadStatus.isFailure) {
          MevTechUtilities.errorToast(
            context,
            state.imageUploadStatus.error ?? 'Image upload failed. try again',
          );
          context.read<UserCubit>().resetState();
        }
      },
      builder: (context, state) {
        final userCubit = context.read<UserCubit>();
        // log(state.user?.profilePictureUrl ?? 'null data');
        return Scaffold(
          body: Center(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  // automaticallyImplyLeading: false,
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
                                    ),
                                  ),
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
                                      state.user?.profilePictureUrl ?? '',
                                      onTap: () {
                                        UserFullImage.expand(
                                          context,
                                          state.user?.profilePictureUrl ?? '',
                                        );
                                      },
                                    ),
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
                                    child: Image.asset(
                                      'assets/images/avatar.jpg',
                                    ),
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
                            '${user?.firstName.toUpperCase()} ${user?.lastName.toUpperCase()}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        menuItems(
                          leading: FIcons.circleUserRound,
                          title: 'View Profile',
                          onTap: () {
                            context.pushNamed(AppRouter.viewProfile);
                          },
                        ),
                        SizedBox(height: 30.h),
                        menuItems(
                          leading: FIcons.userRoundPen,
                          title: 'Edit Profile',
                          onTap: () {
                            userCubit.populateData(user);
                            context.pushNamed(AppRouter.editUser);
                          },
                        ),
                        // SizedBox(height: 20.h),
                        // menuItems(
                        //   leading: Icons.settings_outlined,
                        //   title: 'Settings',
                        //   onTap: () {},
                        // ),
                        // SizedBox(height: 20.h),
                        // menuItems(
                        //   leading: Icons.lock_outline,
                        //   title: 'Change Password',
                        //   onTap: () {
                        //     context.pushNamed(AppRouter.changePassword);
                        //   },
                        // ),
                        SizedBox(height: 30.h),
                        menuItems(
                          leading: FIcons.logOut,
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

                        // SizedBox(height: 30.h),
                        // menuItems(
                        //   leading: FIcons.bellDot,
                        //   title: 'Test OneSignal',
                        //   onTap: () {
                        //     context
                        //         .read<AuthCubit>()
                        //         .testOneSignalNotifications(
                        //           context.read<AuthCubit>().currentUser?.id ??
                        //               '',
                        //         );
                        //   },
                        // ),
                        // FilledButton.icon(
                        //   onPressed: () {},
                        //   label: Text('Delete Account'),
                        // ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        ListTile(
                          // iconColor: AppColor.primary,
                          shape: NonUniformBorder(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                            topWidth: 3,
                            bottomWidth: 0.8,
                            leftWidth: 0.3,
                            rightWidth: 0.3,
                          ),
                          title: Text(
                            'Delete Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                          hoverColor: Colors.transparent,
                          onTap: () {
                            MevTechUtilities.showAnimatedAlert(
                              context: context,
                              title: 'Delete Account ⛔️',
                              message:
                                  'Your account will be permanently deleted. Please note that this action cannot be undone, continue?',
                              onConfirm: userCubit.deleteUserAccount,
                            );
                          },
                          leading: Icon(
                            FIcons.trash2,
                            color: Colors.red,
                            size: 23.sp,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15.r,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: .center,
                  //   children: [
                  //     FilledButton.icon(
                  //       style: FilledButton.styleFrom(
                  //         backgroundColor: Colors.red,
                  //         minimumSize: Size(300.w, 50.h),
                  //       ),
                  //       onPressed: () {},
                  //       label: const Text('Delete Account'),
                  //       icon: const Icon(FIcons.trash2),
                  //       iconAlignment: .end,
                  //     ),
                  //   ],
                  // ),
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
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
      ),
      hoverColor: Colors.transparent,
      onTap: onTap,
      leading: Icon(leading, color: AppColor.primary, size: 23.sp),
      trailing: Icon(Icons.arrow_forward_ios, size: 15.r),
    );
  }
}
