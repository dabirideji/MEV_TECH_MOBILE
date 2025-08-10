import 'package:template/core/utils/constants.dart';
import 'package:template/features/course/data/models/course-models/course_model.dart';
import 'package:template/features/user/data/models/user_model.dart';

class CourseContentModel {
  CourseContentModel({
    required this.id,
    required this.courseContentCourseId,
    required this.courseContentTitle,
    required this.courseContentVideoUrl,
    required this.courseContentType,
    required this.courseContentDescription,
    required this.courseContentTranscript,
    required this.courseContentSummary,
    required this.order,
    required this.isPreview,
    required this.isFree,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseContentModel.fromJson(Map<String, dynamic> json) {
    return CourseContentModel(
      id: json['id'] as String,
      courseContentCourseId: json['courseContentCourseId'] as String,
      courseContentTitle: json['courseContentTitle'] as String,
      courseContentVideoUrl: json['courseContentVideoUrl'] as String,
      courseContentType: json['courseContentType'] as String,
      courseContentDescription: json['courseContentDescription'] as String,
      courseContentTranscript: json['courseContentTranscript'] as String,
      courseContentSummary: json['courseContentSummary'] as String,
      order: json['order'] as int,
      isPreview: json['isPreview'] as bool,
      isFree: json['isFree'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
  final String id;
  final String courseContentCourseId;
  final String courseContentTitle;
  final String courseContentVideoUrl;
  final String courseContentType;
  final String courseContentDescription;
  final String courseContentTranscript;
  final String courseContentSummary;
  final int order;
  final bool isPreview;
  final bool isFree;
  final String? createdAt;
  final String? updatedAt;
}

// Course content Features Model Classes

// CourseContent Comment Model

class CourseContentCommentModel {
  CourseContentCommentModel({
    required this.id,
    required this.courseContentId,
    required this.userId,
    required this.message,
    required this.isDeleted,
    required this.createdAt,
    this.replies = const [],
    this.user,
    this.parentCommentId,
    this.userFullName,
    this.courseContent,
  });

  factory CourseContentCommentModel.fromJson(Map<String, dynamic> json) {
    return CourseContentCommentModel(
      id: json['id'] as String,
      courseContentId: json['courseContentId'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      isDeleted: json['isDeleted'] as bool,
      createdAt: json['createdAt'] as String,
      replies: (json['replies'] as List<dynamic>?)
              ?.map(
                (e) => CourseContentCommentModel.fromJson(
                    e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      parentCommentId: (json['parentCommentId'] ?? '') as String,
      userFullName: json['userFullName'] != null
          ? (json['userFullName'] ?? '') as String
          : null,
      courseContent: json['courseContent'] != null
          ? CourseContentModel.fromJson(
              json['courseContent'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  // CORRECT WAY TO HANDLE NESTED LIST OF MODELS:
  // replies: (json['replies'] as List<dynamic>?) // Cast to nullable List<dynamic>
  //     ?.map((replyJson) => CourseContentCommentModel.fromJson(replyJson as Map<String, dynamic>)) // Map each item
  //     .toList() ?? // Convert back to a list
  //     [], // Provide an empty list if 'replies' was null

  // user: UserModel.fromJson(json['user'] as Map<String, dynamic>),

  // replies: (json['replies'] as List<dynamic>)
  //   .map((replyJson) => CourseContentCommentModel.fromJson(replyJson as Map<String, dynamic>))
  //   .toList(),

  final String id;
  final String courseContentId;
  final String userId;
  final UserModel? user;
  final String? parentCommentId;
  final String message;
  final bool isDeleted;
  final String? userFullName;
  final String createdAt;
  final CourseContentModel? courseContent;
  final List<CourseContentCommentModel>? replies;

  // comment create
//   {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "courseContentId": "2a532062-e919-40a8-8874-2f47b3ab330a",
//     "userId": "78862329-6df3-4217-9201-08ddb81acddf",
//     "parentCommentId": null,
//     "message": "Testing the comment endpoint",
//     "isDeleted": false,
//     "user": null,
//     "courseContent": CourseContentModel.fromJson(json),
//     "parentComment": null,
//     "replies": null,
//     "reports": null,
//     "likes": null,
//     "id": "f712dace-900b-4260-a50f-d0c3db003843",
//     "createdAt": "2025-07-13T09:59:38.0204111+00:00",
//     "updatedAt": "2025-07-13T09:59:38.0204118+00:00"
//   }
// }
}

// Student CourseContent Note

class CourseContentNoteModel {
  CourseContentNoteModel({
    required this.id,
    required this.userId,
    required this.courseContentId,
    required this.note,
    required this.createdAt,
    this.updatedAt,
    this.courseContent,
    this.user,
    this.userEmail,
    this.courseContentTitle,
  });

  factory CourseContentNoteModel.fromJson(Map<String, dynamic> json) {
    return CourseContentNoteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      courseContentId: json['courseContentId'] as String,
      note: json['note'] as String,
      createdAt: json['createdAt'] as String,
      userEmail: (json['userEmail'] ?? '') as String,
      courseContentTitle: (json['courseContentTitle'] ?? '') as String,
    );
  }

  factory CourseContentNoteModel.fromCreateJson(Map<String, dynamic> json) {
    return CourseContentNoteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      courseContentId: json['courseContentId'] as String,
      note: json['note'] as String,
      createdAt: json['createdAt'] as String,
      user: json['userEmail'] as UserModel,
      courseContent: (json['updatedAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }

  final String id;
  final String userId;
  final String courseContentId;
  final String note;
  final String createdAt;
  final String? updatedAt;
  final String? courseContent;
  final UserModel? user;
  final String? userEmail;
  final String? courseContentTitle;

// create
//   {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "userId": "78862329-6df3-4217-9201-08ddb81acddf",
//     "courseContentId": "2a532062-e919-40a8-8874-2f47b3ab330a",
//     "user": null,
//     "courseContent": null,
//     "note": "Example Note for testing",
//     "id": "3dbe8ae1-c72f-4f62-9989-c5bc2baeaa95",
//     "createdAt": "2025-07-13T09:10:32.9586144+00:00",
//     "updatedAt": "2025-07-13T09:10:32.9586168+00:00"
//   }
// }

// get all
// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": [
//     {
//       "id": "3dbe8ae1-c72f-4f62-9989-c5bc2baeaa95",
//       "userId": "78862329-6df3-4217-9201-08ddb81acddf",
//       "userEmail": null,
//       "courseContentId": "2a532062-e919-40a8-8874-2f47b3ab330a",
//       "courseContentTitle": null,
//       "note": "Example Note for testing",
//       "createdAt": "2025-07-13T09:10:32.9586144"
//     }
//   ]
// }
}

class CourseEnrollmentModel {
  CourseEnrollmentModel({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.enrolledAt,
    required this.isCompleted,
    required this.studentName,
    required this.courseTitle,
    this.course,
    this.completedAt,
  });

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return CourseEnrollmentModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      studentId: json['studentId'] as String,
      enrolledAt: json['enrolledAt'] as String,
      completedAt: checkNullString(json['completedAt']),
      isCompleted: json['isCompleted'] as bool,
      course: json['course'] != null
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      studentName: checkNullString(json['studentName']),
      courseTitle: json['courseTitle'] as String,
    );
  }
  final String id;
  final String courseId;
  final String studentId;
  final String enrolledAt;
  final String? completedAt;
  final bool isCompleted;
  final CourseModel? course;
  final String? studentName;
  final String courseTitle;

  // Map<String, dynamic> toJson() => {
  //       'courseId': courseId,
  //       'studentId': studentId,
  //     };

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'courseId': courseId,
  //     'studentId': studentId,
  //     'enrolledAt': enrolledAt.toIso8601String(),
  //     'completedAt': completedAt?.toIso8601String(),
  //     'isCompleted': isCompleted,
  //     'course': course.toJson(),
  //     'studentName': studentName,
  //     'courseTitle': courseTitle,
  //   };
  // }
}

class CourseEnrollmentOld {
  // create response

//  {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "courseId": "9a7f7df7-cd16-4edb-8072-8e132bddd076",
//     "course": {
//       "courseName": "Python Tutorial",
//       "courseTitle": "Python Full Course",
//       "description": "Python Full Course for Beginners [2025]",
//       "isFree": true,
//       "courseImageUrl": "https://img.youtube.com/vi/K5KVEU3aaeQ/default.jpg",
//       "instructorId": "3a3dfce3-ac47-4526-0218-08ddb94398df",
//       "instructor": null,
//       "contents": [],
//       "categories": [],
//       "tags": [],
//       "lessons": [],
//       "quizzes": [],
//       "id": "9a7f7df7-cd16-4edb-8072-8e132bddd076",
//       "createdAt": "2025-07-05T18:23:10.3895498",
//       "updatedAt": "2025-07-05T18:23:10.3895507"
//     },
//     "studentId": "70c4e4f6-cba1-4635-5e92-08ddb88cec3b",
//     "student": {
//       "oAuthProfilePictureUrl": null,
//       "oAuthProvider": null,
//       "oAuthProviderUserId": null,
//       "firstName": "kunle",
//       "lastName": "kelani",
//       "isAdmin": false,
//       "isSuperAdmin": false,
//       "isDeleted": false,
//       "isActive": true,
//       "isInstructor": true,
//       "profilePictureUrl": null,
//       "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdWJqZWN0IjoiQkFTRV9BVVRIRU5USUNBVElPTiIsIlVzZXJJZCI6IjcwYzRlNGY2LWNiYTEtNDYzNS01ZTkyLTA4ZGRiODhjZWMzYiIsIkVtYWlsQWRkcmVzcyI6Imt1bmxlQGdtYWlsLmNvbSIsIlVzZXJOYW1lIjoia3VubGU3IiwibmJmIjoxNzU0NjU3MTI4LCJleHAiOjE3NTQ2NjA3MjgsImlhdCI6MTc1NDY1NzEyOCwiaXNzIjoiTUVWIFRFQ0gifQ.JgROsJE7hn0P-ZNNxmSr1s22JkJrVd1X6tlhtAbSlBo",
//       "refreshToken": "RYPAwDEiSYvq5g7pgsWw3z0fVnVbNeMf1GrNZASiP9U=",
//       "refreshTokenExpiryTime": "2025-08-18T12:45:28.992455",
//       "userWallet": null,
//       "userRoles": [],
//       "studentCourseContentNotes": [],
//       "wishlistCourses": [],
//       "createdAt": "2025-07-01T10:49:15.2842169",
//       "updatedAt": "2025-07-01T10:49:15.2842172",
//       "id": "70c4e4f6-cba1-4635-5e92-08ddb88cec3b",
//       "userName": "kunle7",
//       "normalizedUserName": "KUNLE7",
//       "email": "kunle@gmail.com",
//       "normalizedEmail": "KUNLE@GMAIL.COM",
//       "emailConfirmed": false,
//       "passwordHash": "AQAAAAIAAYagAAAAEIs8qRTpa482tlP7P/pTnrRm+QXGxD6jFZQN0X7hJvdh4Zkl66m+kUFNqR56Y1Ysyg==",
//       "securityStamp": "QEKQYWE5QUYJT5QB4YPR66WFCLWDHJ5E",
//       "concurrencyStamp": "593e4db3-211b-4fd0-8bf2-91b2ea1afe2e",
//       "phoneNumber": "08023456721",
//       "phoneNumberConfirmed": false,
//       "twoFactorEnabled": false,
//       "lockoutEnd": null,
//       "lockoutEnabled": true,
//       "accessFailedCount": 0
//     },
//     "enrolledAt": "2025-08-08T12:56:56.1470187Z",
//     "completedAt": null,
//     "isCompleted": false,
//     "id": "23494448-ea3e-4451-aa0a-a906d316877f",
//     "createdAt": "2025-08-08T12:56:56.1470256+00:00",
//     "updatedAt": "2025-08-08T12:56:56.147028+00:00"
//   }
// }
}
