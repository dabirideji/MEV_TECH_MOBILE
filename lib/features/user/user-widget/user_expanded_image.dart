import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:mevtech/features/user/user-widget/user_image.dart';

class UserFullImage {
  static void expand(BuildContext context, String imageUrl) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        const iconSize = 30;
        return DynamicDialog(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      CachedNetworkImage(
                        // width: 300.w,
                        // height: 300.h,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: MevTechUtilities.customLoader(scale: 1.5),
                          ),
                        ),
                        errorWidget: (context, url, error) => IconButton(
                          onPressed: () {
                            // UserImage(imageUrl);
                          },
                          icon: Icon(
                            FIcons.userRoundX,
                            color: Colors.red,
                            size: 25.sp,
                          ),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -(iconSize / 1.5),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: iconSize.sp,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          onCancel: () {},
        );
      },
    );
  }
}
