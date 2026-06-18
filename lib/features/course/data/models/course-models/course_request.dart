import 'dart:io';

class CreateCourseRequest {
  CreateCourseRequest({
    required this.courseName,
    required this.courseTitle,
    required this.description,
    required this.isFree,
    required this.instructorId,
    this.courseImageFile,
    this.courseImageUrl,
    this.categories = const [],
    this.tags = const [],
  });

  final String courseName;
  final String courseTitle;
  final String description;
  final bool isFree;
  final File? courseImageFile;
  final String? courseImageUrl;
  final String instructorId;
  final List<dynamic> categories;
  final List<dynamic> tags;

  Map<String, dynamic> toJson() => {
        'CourseName': courseName,
        'CourseTitle': courseTitle,
        'Description': description,
        'IsFree': isFree,
        'CourseImageFile': courseImageFile,
        'CourseImageUrl': courseImageUrl,
        'InstructorId': instructorId,
        'Categories': categories,
        'Tags': tags,
      };
}

class DeleteCourseRequest {
  const DeleteCourseRequest({required this.id});

  final String id;

  Map<String, dynamic> toJson() => {'id': id};
}

class UpdateCourseRequest {
  UpdateCourseRequest({
    required this.courseName,
    required this.courseTitle,
    required this.description,
    required this.isFree,
    this.id,
    this.courseImageFile,
    this.courseImageUrl,
    this.categories = const [],
    this.tags = const [],
  });

  final String? id;
  final String courseName;
  final String courseTitle;
  final String description;
  final bool isFree;
  final File? courseImageFile;
  final String? courseImageUrl;
  final List<String> categories;
  final List<String> tags;

  Map<String, dynamic> toJson() => {
        'id': id,
        'CourseName': courseName,
        'CourseTitle': courseTitle,
        'Description': description,
        'IsFree': isFree,
        'CourseImageFile': courseImageFile,
        'CourseImageUrl': courseImageUrl,
        'Categories': categories,
        'Tags': tags,
      };
}

// course content request

// Course Category Request

class CourseCategoryCreateRequest {
  CourseCategoryCreateRequest({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  final String categoryName;
  final String categoryDescription;
  final String categoryImageUrl;

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'categoryDescription': categoryDescription,
        'categoryImageUrl': categoryImageUrl,
      };
}

class CourseCategoryUpdateRequest {
  CourseCategoryUpdateRequest({
    required this.id,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  final String id;
  final String categoryName;
  final String categoryDescription;
  final String categoryImageUrl;

  Map<String, dynamic> toJson() => {
        'categoryName': categoryName,
        'categoryDescription': categoryDescription,
        'categoryImageUrl': categoryImageUrl,
      };
}

// CourseTag Request

class CourseTagCreateRequest {
  CourseTagCreateRequest({
    required this.tagName,
    required this.tagDescription,
  });

  final String tagName;
  final String tagDescription;

  Map<String, dynamic> toJson() => {
        'tagName': tagName,
        'tagDescription': tagDescription,
      };
}

class CourseTagUpdateRequest {
  CourseTagUpdateRequest({
    required this.id,
    required this.tagName,
    required this.tagDescription,
  });

  final String id;
  final String tagName;
  final String tagDescription;

  Map<String, dynamic> toJson() => {
        'tagName': tagName,
        'tagDescription': tagDescription,
      };
}

// create course response
// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "courseName": "n8n Ai-Agent Tutorial",
//     "courseTitle": "Master n8n Ai-Agent in 2 Hours",
//     "description": "Master n8n in 2 Hours: Complete Beginner’s Guide for 2025",
//     "isFree": true,
//     "courseImageUrl": "https://img.youtube.com/vi/AURnISajubk/default.jpg",
//     "instructorId": "3a3dfce3-ac47-4526-0218-08ddb94398df",
//     "instructor": {
//       "firstName": "adekola",
//       "lastName": "jacob",
//       "isAdmin": false,
//       "isSuperAdmin": false,
//       "isDeleted": false,
//       "isActive": true,
//       "isInstructor": true,
//       "userRoles": [],
//       "studentCourseContentNotes": [],
//       "wishlistCourses": [],
//       "createdAt": "2025-07-02T08:36:52.7868491",
//       "updatedAt": "2025-07-02T08:36:52.7868491",
//       "id": "3a3dfce3-ac47-4526-0218-08ddb94398df",
//       "userName": "ade77",
//       "normalizedUserName": "ADE77",
//       "email": "ade@gmail.com",
//       "normalizedEmail": "ADE@GMAIL.COM",
//       "emailConfirmed": false,
//       "passwordHash": "AQAAAAIAAYagAAAAEA1JVJe/bu6u6H+f6weLQBEmiLCs23bnllzvzyDmWYI1TisAU0qan70BVsCCCqMrrw==",
//       "securityStamp": "OQZUPLQOBVO2XYAGIH4K4VRMJ42AL66Z",
//       "concurrencyStamp": "7417c7e8-531b-4144-9854-8110680681c3",
//       "phoneNumber": "08034672343",
//       "phoneNumberConfirmed": false,
//       "twoFactorEnabled": false,
//       "lockoutEnd": null,
//       "lockoutEnabled": true,
//       "accessFailedCount": 0
//     },
//     "contents": [],
//     "categories": [],
//     "tags": [],
//     "lessons": [],
//     "quizzes": [],
//     "id": "180ec84a-349a-41b1-abc2-a5c9eb791dcd",
//     "createdAt": "2025-07-05T18:14:08.306448+00:00",
//     "updatedAt": "2025-07-05T18:14:08.3064487+00:00"
//   }
// }
