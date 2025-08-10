class CourseModel {
  CourseModel({
    required this.id,
    required this.courseName,
    required this.courseTitle,
    required this.description,
    required this.isFree,
    required this.courseImageUrl,
    required this.instructorId,
    required this.categoryNames,
    required this.tagNames,
    required this.contentCount,
    required this.lessonCount,
    required this.quizCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      courseTitle: json['courseTitle'] as String,
      description: json['description'] as String,
      isFree: json['isFree'] as bool,
      courseImageUrl: (json['courseImageUrl'] ?? '') as String,
      instructorId: json['instructorId'] as String,
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
  final String instructorId;
  final List<String> categoryNames;
  final List<String> tagNames;
  final int contentCount;
  final int lessonCount;
  final int quizCount;
}

// Course Category Model

class CourseCategoryModel {
  CourseCategoryModel({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
    this.id,
    this.courseCount,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
      categoryDescription: json['categoryDescription'] as String,
      categoryImageUrl: json['categoryImageUrl'] as String,
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
}

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
    return {
      'tagName': tagName,
      'tagDescription': tagDescription,
    };
  }

  final String? id;
  final String tagName;
  final String tagDescription;
  final int? courseCount;
}
