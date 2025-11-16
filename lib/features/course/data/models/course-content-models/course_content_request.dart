import 'dart:io';

class CreateCourseContentRequest {
  CreateCourseContentRequest({
    required this.courseContentCourseId,
    required this.courseContentTitle,
    required this.courseContentDescription,
    required this.courseContentVideoUrl,
    required this.courseContentSummary,
    required this.courseContentTranscript,
    required this.order,
    required this.isPreview,
    required this.isFree,
    this.courseContentThumbnailFile,
    this.courseContentThumbnailUrl,
  });

  final String courseContentCourseId;
  final String courseContentTitle;
  final String courseContentDescription;
  final String courseContentVideoUrl;
  final File? courseContentThumbnailFile;
  final String? courseContentThumbnailUrl;
  final String courseContentTranscript;
  final String courseContentSummary;
  final int order;
  final bool isPreview;
  final bool isFree;

  Map<String, String> toJson() => {
        'CourseContentCourseId': courseContentCourseId,
        'CourseContentTitle': courseContentTitle,
        'CourseContentDescription': courseContentDescription,
        'CourseContentVideoUrl': courseContentVideoUrl,
        // 'CourseContentThumbnailFile': courseContentThumbnailFile,
        'CourseContentThumbnailUrl': courseContentThumbnailUrl ?? '',
        'CourseContentTranscript': courseContentTranscript,
        'CourseContentSummary': courseContentSummary,
        'Order': order.toString(),
        'IsPreview': isPreview.toString(),
        'IsFree': isFree.toString(),
      };
}

class CourseContentUpdateRequest {
  CourseContentUpdateRequest({
    required this.id,
    required this.courseContentTitle,
    required this.courseContentVideoUrl,
    required this.courseContentDescription,
    required this.courseContentTranscript,
    required this.courseContentSummary,
    required this.order,
    required this.isPreview,
    required this.isFree,
  });

  final String id;
  final String courseContentTitle;
  final String courseContentVideoUrl;
  final String courseContentDescription;
  final String courseContentTranscript;
  final String courseContentSummary;
  final int order;
  final bool isPreview;
  final bool isFree;

  Map<String, dynamic> toJson() => {
        'courseContentTitle': courseContentTitle,
        'courseContentVideoUrl': courseContentVideoUrl,
        'courseContentDescription': courseContentDescription,
        'courseContentTranscript': courseContentTranscript,
        'courseContentSummary': courseContentSummary,
        'order': order,
        'isPreview': isPreview,
        'isFree': isFree,
      };
}

// Course content Features Request Classes

class CourseContentComment {
  CourseContentComment(
      {required this.courseContentId,
      required this.userId,
      required this.parentCommentId,
      required this.message});

  final String courseContentId;
  final String userId;
  final String parentCommentId;
  final String message;

  Map<String, dynamic> toJson() => {
        'courseContentId': courseContentId,
        'userId': userId,
        'parentCommentId': parentCommentId,
        'message': message,
      };
}

class CourseContentCommentLike {}

class CourseContentCommentReport {}

class CourseContentResource {}

class CourseContentReview {}

class CourseEnrollment {}

class CourseLesson {}

class CourseProgress {}

class CourseQuiz {}

class CourseTag {}

class CourseTagMap {}

class CourseWishlist {}
