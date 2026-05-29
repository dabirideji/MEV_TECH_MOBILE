import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/user_notification_model.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({super.key});

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  bool _isLoading = false;

  Future<void> loadNotification() async {
    try {
      _isLoading = true;

      await context.read<AuthCubit>().fetchNotifications();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if ((context.read<AuthCubit>().state as AuthLoginSuccess)
        .notifications
        .isEmpty) {
      loadNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final authCubit = context.read<AuthCubit>();
    // final authState = context.watch<AuthCubit>().state as AuthLoginSuccess;
    final notifications = context.watch<AuthCubit>().currentNotifications;
    final unreadNotification = notifications
        .where((notification) => notification.isRead == false)
        .toList();

    // final notifications = authState.notifications;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: FTabs(
        children: [
          FTabEntry(
            label: Text(
              'Unread',
              style: context.theme.typography.lg.copyWith(
                color: context.theme.colors.foreground,
              ),
            ),
            child: Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.r),
                physics: const ClampingScrollPhysics(),
                itemCount: unreadNotification.length,
                itemBuilder: (context, index) {
                  final notification = unreadNotification[index];
                  return Column(
                    children: [
                      FPopover(
                        style: (style) => style.copyWith(
                          barrierFilter: (animation) => ImageFilter.compose(
                            outer: ImageFilter.blur(
                              sigmaX: animation * 5,
                              sigmaY: animation * 5,
                            ),
                            inner: ColorFilter.mode(
                              Color.lerp(
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.2),
                                animation,
                              )!,
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                        popoverAnchor: Alignment.topCenter,
                        childAnchor: Alignment.bottomCenter,
                        constraints: FPortalConstraints(
                          maxHeight: screenHeight * 0.9,
                          maxWidth: screenWidth * 0.9,
                        ),
                        popoverBuilder: (context, _) => Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 14,
                            right: 20,
                            bottom: 10,
                          ),
                          child: SizedBox(
                            // width: 288,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: EdgeInsets.all(10.r),
                                    decoration: BoxDecoration(
                                      color: AppColor.primary.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(FIcons.packageOpen),
                                  ),
                                  title: Text(
                                    notification.title,
                                    style: context.theme.typography.lg.copyWith(
                                      color: context.theme.colors.foreground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  notification.message,
                                  style: context.theme.typography.sm.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 7),
                                Row(
                                  spacing: 5.w,
                                  children: [
                                    const Icon(FIcons.clipboardClock),
                                    Text(
                                      MevTechUtilities.formatDateTime(
                                        notification.createdAt,
                                      ),
                                      style: context.theme.typography.sm
                                          .copyWith(
                                            color: context.theme.colors.primary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                        builder: (_, controller, _) => notificationItem(
                          notification: notification,
                          onTap: () {
                            controller.toggle();
                            authCubit.markAsreadNotification(
                              index: index,
                              notificationId: notification.id,
                            );

                            setState(() {});

                            // context.pushNamed(
                            //   AppRouter.viewNotification,
                            //   extra: notification.id,
                            // );
                          },
                          onLongPress: () {
                            authCubit.deleteNotifications(notification.id);
                          },
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
                  );
                },
              ),
            ),
          ),
          FTabEntry(
            label: Text(
              'All',
              style: context.theme.typography.lg.copyWith(
                color: context.theme.colors.foreground,
              ),
            ),
            child: Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.r),
                physics: const ClampingScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Column(
                    children: [
                      FPopover(
                        style: (style) => style.copyWith(
                          barrierFilter: (animation) => ImageFilter.compose(
                            outer: ImageFilter.blur(
                              sigmaX: animation * 5,
                              sigmaY: animation * 5,
                            ),
                            inner: ColorFilter.mode(
                              Color.lerp(
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.2),
                                animation,
                              )!,
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                        popoverAnchor: Alignment.topCenter,
                        childAnchor: Alignment.bottomCenter,
                        constraints: FPortalConstraints(
                          maxHeight: screenHeight * 0.9,
                          maxWidth: screenWidth * 0.9,
                        ),
                        popoverBuilder: (context, _) => Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 14,
                            right: 20,
                            bottom: 10,
                          ),
                          child: SizedBox(
                            // width: 288,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    padding: EdgeInsets.all(10.r),
                                    decoration: BoxDecoration(
                                      color: AppColor.primary.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(FIcons.packageOpen),
                                  ),
                                  title: Text(
                                    notification.title,
                                    style: context.theme.typography.lg.copyWith(
                                      color: context.theme.colors.foreground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  notification.message,
                                  style: context.theme.typography.sm.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  spacing: 5.w,
                                  children: [
                                    const Icon(FIcons.clipboardClock),
                                    Text(
                                      MevTechUtilities.formatDateTime(
                                        notification.createdAt,
                                      ),
                                      style: context.theme.typography.sm
                                          .copyWith(
                                            color: context.theme.colors.primary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                        builder: (_, controller, _) => notificationItem(
                          notification: notification,
                          onTap: () {
                            controller.toggle();
                            authCubit.markAsreadNotification(
                              index: index,
                              notificationId: notification.id,
                            );
                          },
                          onLongPress: () {
                            authCubit.deleteNotifications(notification.id);
                          },
                        ),
                      ),

                      SizedBox(height: 10.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationItem({
    required NotificationModel notification,
    Widget? leading,
    Widget? trailing,
    void Function()? onTap,
    void Function()? onLongPress,
  }) {
    return ListTile(
      // iconColor: AppColor.primary,
      titleAlignment: ListTileTitleAlignment.top,
      tileColor: Colors.white,
      shape: NonUniformBorder(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
        topWidth: 0.2,
        bottomWidth: 0.5,
        leftWidth: 0.3,
        rightWidth: 0.3,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            notification.message,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5.h),
          // const Divider(color: Colors.black26, thickness: 0.1),
          Row(
            spacing: 5.w,
            children: [
              const Icon(
                FIcons.clipboardClock,
                size: 15,
                color: Colors.black38,
              ),
              Text(
                MevTechUtilities.formatDateTime(notification.createdAt),
                style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  fontSize: 9.sp,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
      // subtitle: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [

      //   ],
      // ),
      hoverColor: Colors.transparent,
      onTap: onTap,
      onLongPress: onLongPress,
      leading: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(FIcons.messageCircle, color: Colors.blue.shade600),
      ),
      trailing: notification.isRead
          ? null
          : const CircleAvatar(backgroundColor: Colors.red, radius: 5),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        FPopover(
          style: (style) => style.copyWith(
            barrierFilter: (animation) => ImageFilter.compose(
              outer: ImageFilter.blur(
                sigmaX: animation * 5,
                sigmaY: animation * 5,
              ),
              inner: ColorFilter.mode(
                Color.lerp(
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  animation,
                )!,
                BlendMode.srcOver,
              ),
            ),
          ),
          popoverAnchor: Alignment.topCenter,
          childAnchor: Alignment.bottomCenter,
          popoverBuilder: (context, _) => Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 14,
              right: 20,
              bottom: 10,
            ),
            child: SizedBox(
              // width: 288,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dimensions', style: context.theme.typography.base),
                  const SizedBox(height: 7),
                  Text(
                    'Set the dimensions for the layer.',
                    style: context.theme.typography.sm.copyWith(
                      color: context.theme.colors.mutedForeground,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          builder: (_, controller, _) => FButton(
            style: FButtonStyle.outline(),
            mainAxisSize: MainAxisSize.min,
            onPress: controller.toggle,
            child: const Text('Open popover'),
          ),
        ),
      ],
    );
  }
}
