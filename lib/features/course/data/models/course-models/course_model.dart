import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/data/database_model.dart';

class CourseModel implements DatabaseModel {
  CourseModel({
    required this.id,
    required this.courseName,
    required this.courseTitle,
    required this.description,
    required this.isFree,
    required this.courseImageUrl,
    required this.categoryNames,
    required this.tagNames,
    required this.contentCount,
    required this.lessonCount,
    required this.quizCount,
    this.instructorId,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      courseTitle: json['courseTitle'] as String,
      description: (json['description'] ?? '') as String,
      isFree: json['isFree'] as bool,
      courseImageUrl: (json['courseImageUrl'] ?? '') as String,
      instructorId: json['instructorId'] as String?,
      categoryNames: (json['categoryNames'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      tagNames: (json['tagNames'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      contentCount: (json['contentCount'] ?? 0) as int,
      lessonCount: (json['lessonCount'] ?? 0) as int,
      quizCount: (json['quizCount'] ?? 0) as int,
    );
  }

  final String id;
  final String courseName;
  final String courseTitle;
  final String description;
  final bool isFree;
  final String courseImageUrl;
  final String? instructorId;
  final List<String> categoryNames;
  final List<String> tagNames;
  final int contentCount;
  final int lessonCount;
  final int quizCount;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'courseTitle': courseTitle,
      'description': description,
      'isFree': isFree ? 1 : 0,
      'courseImageUrl': courseImageUrl,
      'instructorId': instructorId,
      'categoryNames': jsonEncode(categoryNames),
      'tagNames': jsonEncode(tagNames),
      'contentCount': contentCount,
      'lessonCount': lessonCount,
      'quizCount': quizCount,
    };
  }

  // ignore: sort_constructors_first
  factory CourseModel.fromMap(Map<String, dynamic> map) {
    // final catNames = listFromDbMap(
    //   map['categoryNames'],
    // ).map((e) => e.toString()).toList();

    // final g = catNames;

    return CourseModel(
      id: map['id'] as String,
      courseName: map['courseName'] as String,
      courseTitle: map['courseTitle'] as String,
      description: map['description'] as String,
      isFree: (map['isFree'] ?? 0) == 1,
      courseImageUrl: (map['courseImageUrl'] ?? '') as String,
      instructorId: map['instructorId'] as String?,

      categoryNames: listFromDbMap(
        map['categoryNames'],
      ).map((e) => e.toString()).toList(),
      // map['categoryNames'] != null &&
      //     (map['categoryNames'] as String).isNotEmpty
      // ? (jsonDecode(map['categoryNames'] as String) as List<dynamic>)
      //       .map((e) => e.toString())
      //       .toList()
      // : <String>[],

      // (map['categoryNames'] as List<dynamic>? ?? [])
      //     .map((e) => e.toString())
      //     .toList(),
      tagNames:
          map['tagNames'] != null && (map['tagNames'] as String).isNotEmpty
          ? (jsonDecode(map['tagNames'] as String) as List<dynamic>)
                .map((e) => e.toString())
                .toList()
          : <String>[],

      contentCount: (map['contentCount'] ?? 0) as int,
      lessonCount: (map['lessonCount'] ?? 0) as int,
      quizCount: (map['quizCount'] ?? 0) as int,
    );
  }
}

// extension CourseModelMapper on CourseModel {}

// Course Category Model

class CourseCategoryModel implements DatabaseModel {
  CourseCategoryModel({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
    this.id,
    this.courseCount,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: (json['id'] ?? '') as String,
      categoryName: (json['categoryName'] ?? '') as String,
      categoryDescription: (json['categoryDescription'] ?? '') as String,
      categoryImageUrl: (json['categoryImageUrl'] ?? '') as String,
      courseCount: (json['courseCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'categoryImageUrl': categoryImageUrl,
    };
  }

  final String? id;
  final String categoryName;
  final String categoryDescription;
  final String categoryImageUrl;
  final int? courseCount;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'categoryImageUrl': categoryImageUrl,
      'courseCount': courseCount,
    };
  }

  // ignore: sort_constructors_first
  factory CourseCategoryModel.fromMap(Map<String, dynamic> map) {
    return CourseCategoryModel(
      id: map['id'] as String,
      categoryName: map['categoryName'] as String,
      categoryDescription: map['categoryDescription'] as String,
      categoryImageUrl: map['categoryImageUrl'] as String,
      courseCount: (map['courseCount'] ?? 0) as int,
    );
  }
}

// extension CourseCategoryModelMapper on CourseCategoryModel {}

// CourseTag Model

class CourseTagModel {
  CourseTagModel({
    required this.tagName,
    required this.tagDescription,
    this.id,
    this.courseCount,
  });

  factory CourseTagModel.fromJson(Map<String, dynamic> json) {
    return CourseTagModel(
      id: json['id'] as String,
      tagName: json['tagName'] as String,
      tagDescription: json['tagDescription'] as String,
      courseCount: (json['courseCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'tagName': tagName, 'tagDescription': tagDescription};
  }

  final String? id;
  final String tagName;
  final String tagDescription;
  final int? courseCount;
}
