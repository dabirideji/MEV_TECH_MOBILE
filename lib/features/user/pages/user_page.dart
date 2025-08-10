import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/home/home_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/logic/user-cubit/user_cubit.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final authCubit = context.read<AuthCubit>();
    final homeCubit = context.read<HomeCubit>();

    UserModel? user;

    if (authState is AuthLoginSuccess) {
      user = authState.model.user;
    }

    return BlocBuilder<UserCubit, UserState>(
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
                        Center(
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: AppColor.primaryTint,
                            child: Icon(
                              Icons.person_pin,
                              size: 100.r,
                            ),
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
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
        ),
      ),
      hoverColor: Colors.transparent,
      onTap: onTap,
      leading: CircleAvatar(
        radius: 18.r,
        backgroundColor: AppColor.primaryTint,
        child: Icon(leading),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 19.r,
      ),
    );
  }
}
