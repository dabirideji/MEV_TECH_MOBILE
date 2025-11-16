import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/data/models/user_notification_model.dart';

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
    final authCubit = context.read<AuthCubit>();
    // final authState = context.watch<AuthCubit>().state as AuthLoginSuccess;
    final notifications = context.watch<AuthCubit>().currentNotifications;

    // final notifications = authState.notifications;
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.r),
        physics: const ClampingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Column(
            children: [
              notificationItem(
                notification: notification,
                onTap: () {
                  authCubit.markAsreadNotification(
                    index: index,
                    notificationId: notification.id,
                  );

                  context.pushNamed(AppRouter.viewNotification,
                      extra: notification.id);

                  // authCubit.showNotification(
                  //   id: 1,
                  //   title: notification.title,
                  //   body: notification.message,
                  // );
                },
                onLongPress: () {
                  authCubit.deleteNotifications(notification.id);
                },
              ),
              SizedBox(height: 10.h),
            ],
          );
        },
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
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
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
          const Divider(
            color: Colors.black26,
            thickness: 0.1,
          ),
          Text(
            MevTechUtilities.formatDateTime(notification.createdAt),
            style: TextStyle(
              // fontWeight: FontWeight.w600,
              fontSize: 9.sp,
              color: Colors.black38,
            ),
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
      leading: CircleAvatar(
        radius: 10.r,
        backgroundColor: AppColor.primaryTint,
        child: const Icon(
          Icons.notifications_on_sharp,
          size: 12,
        ),
      ),
      trailing: notification.isRead
          ? null
          : const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 5,
            ),
    );
  }
}
