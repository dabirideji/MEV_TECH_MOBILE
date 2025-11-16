import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class ViewNotificationPage extends StatelessWidget {
  const ViewNotificationPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final notification = (context.read<AuthCubit>().state as AuthLoginSuccess)
        .notifications
        .firstWhere((notification) => notification.id == id);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Details',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(30.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                notification.message,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20.h),
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
        ),
      ),
    );
  }
}
