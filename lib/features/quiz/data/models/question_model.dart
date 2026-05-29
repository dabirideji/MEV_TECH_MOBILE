import 'dart:convert';

import 'package:mevtech/core/utils/constants.dart';

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

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int,
      question: map['question'] as String,
      option: OptionModel.fromJson(
        jsonDecode(map['option'] as String) as Map<String, dynamic>,
      ),
      section: map['section'] as String,
      image: map['image'] as String,
      answer: map['answer'] as String,
      solution: map['solution'] as String,
      examtype: map['examtype'] as String,
      examyear: map['examyear'] as String,
      questionNub: map['questionNub'] as int,
      hasPassage: map['hasPassage'] as int,
      category: map['category'] as String,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'option': option.toJsonString(), // ✅ JSON STRING
      'section': section,
      'image': image,
      'answer': answer,
      'solution': solution,
      'examtype': examtype,
      'examyear': examyear,
      'questionNub': questionNub,
      'hasPassage': hasPassage,
      'category': category,
    };
  }
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

  Map<String, dynamic> toMap() {
    return {'a': a, 'b': b, 'c': c, 'd': d, 'e': e};
  }

  /// Convert to JSON string for Sqflite
  String toJsonString() => jsonEncode(toMap());
}
