// AIzaSyD3eeJNbQ8fdjn3vmRWW0asUMcJdJccsr0  // youtube data api key
import 'dart:developer';

class CourseVideoModel {
  const CourseVideoModel({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    this.description,
  });

  // maxres

  factory CourseVideoModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    // log(snippet.toString());
    final resourceId = snippet['resourceId'] as Map<String, dynamic>;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
    final medium = thumbnails['medium'] as Map<String, dynamic>;

    return CourseVideoModel(
      videoId: (resourceId['videoId'] ?? '') as String,
      title: (snippet['title'] ?? '') as String,
      thumbnailUrl: (medium['url'] ?? '') as String,
      channelName: (snippet['channelTitle'] ?? '') as String,
      description: (snippet['description'] ?? '') as String,
    );
  }

  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String? description;

  // return CourseVideoModel(
  //     videoId: json['snippet']['resourceId']['videoId'] as String,
  //     title: json['snippet']['title'],
  //     thumbnailUrl: json['snippet']['thumbnails']['medium']['url'],
  //     description: json['snippet']['description'],
  //   );
}
