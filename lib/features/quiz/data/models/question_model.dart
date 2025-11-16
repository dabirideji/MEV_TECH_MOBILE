import 'package:template/core/utils/constants.dart';

class QuestionModel {
  QuestionModel({
    required this.id,
    required this.question,
    required this.option,
    required this.section,
    required this.image,
    required this.answer,
    required this.solution,
    required this.examtype,
    required this.examyear,
    required this.questionNub,
    required this.hasPassage,
    required this.category,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: (json['id'] ?? 0) as int,
      question: (json['question'] ?? '') as String,
      option: OptionModel.fromJson(json['option'] as Map<String, dynamic>),
      section: (json['section'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      answer: (json['answer'] ?? '') as String,
      solution: (json['solution'] ?? '') as String,
      examtype: (json['examtype'] ?? '') as String,
      examyear: (json['examyear'] ?? '') as String,
      questionNub: (json['questionNub'] ?? 0) as int,
      hasPassage: (json['hasPassage'] ?? 0) as int,
      category: (json['category'] ?? '') as String,
    );
  }
  final int id;
  final String question;
  final OptionModel option;
  final String section;
  final String image;
  final String answer;
  final String solution;
  final String examtype;
  final String examyear;
  final int questionNub;
  final int hasPassage;
  final String category;
}

class OptionModel {
  OptionModel({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    this.e,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      a: (json['a'] ?? '') as String,
      b: (json['b'] ?? '') as String,
      c: (json['c'] ?? '') as String,
      d: (json['d'] ?? '') as String,
      e: checkNullString(json['e']),
    );
  }
  final String a;
  final String b;
  final String c;
  final String d;
  final String? e;
}
