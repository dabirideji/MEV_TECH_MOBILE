import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';

class UserImage extends StatelessWidget {
  const UserImage(this.imageUrl, {super.key, this.onTap});

  final String imageUrl;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: 30.w,

            height: 30.h,
            child: MevTechUtilities.customLoader(scale: 1),
          ),
        ),
        errorWidget: (context, url, error) => IconButton(
          onPressed: () {
            // UserImage(imageUrl);
          },
          icon: const Icon(Icons.person_off),
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}
