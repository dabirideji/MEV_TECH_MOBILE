import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/course/data/models/course-content-models/course_video_model.dart';

class YouTubeVideoCard extends StatelessWidget {
  const YouTubeVideoCard({required this.videoModel, this.onPressed, super.key});

  final CourseVideoModel videoModel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.4,
      width: double.maxFinite,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Card(
            color: Colors.blue,
            margin: EdgeInsets.all(10.r),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(videoModel.thumbnailUrl),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    videoModel.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    videoModel.channelName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '100k',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: onPressed,
              // () {
              //   // Navigator.push(
              //   //     context,
              //   //     MaterialPageRoute(
              //   //       builder: (_) =>
              //   //           videoModelPlayer(videoId: videoModel.videoId),
              //   //     ));
              // },
              icon: const Icon(
                Icons.play_circle,
                color: Colors.red,
                size: 30,
              ))
        ],
      ),
    );
  }
}
