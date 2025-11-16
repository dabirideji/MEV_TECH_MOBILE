import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:template/core/utils/colors.dart';

class UserImage extends StatelessWidget {
  const UserImage(this.imageUrl, {super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
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
