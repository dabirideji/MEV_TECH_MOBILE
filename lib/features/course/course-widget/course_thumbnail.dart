import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/assets.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';

class CourseThumbnail extends StatelessWidget {
  const CourseThumbnail({
    required this.videoUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String videoUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final videoId = MevTechUtilities.extractYoutubeId(videoUrl);

    return CachedNetworkImage(
      imageUrl: 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (context, error, stackTrace) => CachedNetworkImage(
        imageUrl: 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, error, stackTrace) => CachedNetworkImage(
          imageUrl: 'https://img.youtube.com/vi/$videoId/default.jpg',
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) =>
              Center(child: MevTechUtilities.customLoader(scale: 1.5)),
          errorWidget: (context, error, stackTrace) =>
              Icon(FIcons.imageOff, color: Colors.red, size: 25.sp),
        ),
      ),
    );
  }
}
