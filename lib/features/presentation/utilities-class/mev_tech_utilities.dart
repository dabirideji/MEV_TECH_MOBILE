import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mevtech/core/utils/background_toast.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:toastification/toastification.dart';

class MevTechUtilities {
  static String id = '';
  static String userName = '';
  static String firstName = '';
  static String lastName = '';
  static String userPass = '';
  static String authKey = '';
  static String refreshToken = '';
  static String userType = '';
  static String email = '';
  static String userPhoneNumber = '';
  static String regDate = '';

  static String formatterDouble(double value) {
    final stringValue = NumberFormat.decimalPattern().format(value);
    return stringValue;
  }

  static String nairaSymbol = NumberFormat.simpleCurrency(
    locale: 'en_NG',
  ).currencySymbol;

  static String getNigerianNairaSymbol() {
    final nairaFormat = NumberFormat.currency(
      locale: 'en_NG', // Specify the locale for context, though 'NGN' is key
      name: 'NGN', // Explicitly set the ISO 4217 currency code for Naira
      decimalDigits: 2, // Standard for NGN
    );
    return nairaFormat.currencySymbol;
  }

  static bool _isShowingProgress = false;

  static Widget customLoader({double scale = 2}) {
    return Center(
      child: SizedBox(
        height: 30.h,
        width: 30.h,
        child: Transform.scale(
          scale: scale,
          child: const FCircularProgress.loader(),
        ),
      ),
    );
  }

  //  style: (style) => style.copyWith(
  //           iconStyle: IconThemeData(size: 40.sp),
  //           motion: (motion) => FCircularProgressMotion(),
  //         ),

  static void showProgressIndicator(BuildContext context) {
    if (_isShowingProgress) return;

    _isShowingProgress = true;
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.grey,
                    backgroundColor: AppColor.primary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Loading..',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isShowingProgress = false;
    });
  }

  static void hideProgressIndicator(BuildContext context) {
    if (_isShowingProgress) {
      Navigator.of(context, rootNavigator: true).pop();
      _isShowingProgress = false;
    }
  }

  static String formatDateTime(String? time) {
    try {
      final period = DateTime.parse(time!);
      final result = DateFormat('yyyy-MMM-dd HH:mm:ss').format(period);
      return result;
    } catch (_) {
      return time ?? '000:00';
    }
  }

  static String formatDate(String? date) {
    try {
      final period = DateTime.parse(date!);
      final result = DateFormat('dd-MMM-yyyy').format(period);
      return result;
    } catch (_) {
      return date ?? '000:00';
    }
  }

  static void showAnimatedAlert({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
    String title = 'Confirm Action',
    String cancelText = 'No',
    String confirmText = 'Yes',
    AlignmentGeometry? alignment,
  }) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedAlertDialog(
          title: title,
          message: message,
          cancelText: cancelText,
          confirmText: confirmText,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            Navigator.of(context).pop();
            onConfirm.call();
          },
          alignment: alignment,
        );
      },
    );
  }

  static void alertDialogBox({
    required BuildContext context,
    required String message,
  }) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomAlertDialogue(message: message);
      },
    );
  }

  static Future<dynamic> progressIndicator(BuildContext context) async {
    await showDialog<dynamic>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColor.secondary,
            backgroundColor: AppColor.primary,
          ),
        );
      },
    );
  }

  static void showToast(
    BuildContext context,
    String message, {
    Color color = Colors.green,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static dynamic successToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text(
        'Success',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      description: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      dragToClose: true,
      showIcon: true,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
    );
  }

  static dynamic errorToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text(
        'Failed',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      description: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 5),
      dragToClose: true,
      showIcon: true,
      icon: const Icon(Icons.error_outline, color: Colors.red),
    );
  }

  static dynamic warningToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: const Text(
        'Warning',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      description: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      dragToClose: true,
      showIcon: true,
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.orange),
    );
  }

  static dynamic infoToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: const Text(
        'Info',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      description: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      dragToClose: true,
      showIcon: true,
      icon: const Icon(Icons.info_outline, color: Colors.blue),
    );
  }

  static void backgroundToast(String message, BuildContext context) {
    showCustomToast(
      context: context,
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          // Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.white,
              size: 27,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static dynamic customToast(
    BuildContext context,
    String message, {
    bool isFailure = false,
  }) {
    toastification.showCustom(
      context: context,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      dismissDirection: DismissDirection.none,
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      builder: (context, holder) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isFailure
                    ? Colors.red.withAlpha(100)
                    : Colors.green.withAlpha(100),
                blurRadius: 40,
                spreadRadius: 15,
              ),
            ],
          ),
          child: GestureDetector(
            onTapDown: (_) => holder.pause(), // Pause dismiss timer on hold
            onTapUp: (_) => holder.start(), // Resume dismiss timer on release
            dragStartBehavior: DragStartBehavior.down,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isFailure ? Colors.red : Colors.green,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isFailure ? '❕ Fail' : '☑️ Success',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            message,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Dismiss the toast
                        toastification.dismissById(holder.id);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String extractYoutubeId(String url) {
    final uri = Uri.parse(url);

    // Standard YouTube watch link
    if (uri.host.contains('youtube.com') &&
        uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    // Short youtu.be link
    else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    }
    // Embed link
    else if (uri.host.contains('youtube.com') &&
        uri.pathSegments.contains('embed')) {
      return uri.pathSegments.last;
    }

    throw ArgumentError('Invalid YouTube URL');
  }
}
