import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:mevtech/core/error/failure_response.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/core/storages/DatabaseHandler.dart';
import 'package:mevtech/features/quiz/data/models/question_model.dart';
import 'package:mevtech/features/quiz/data/models/subject_model.dart';

@lazySingleton
class QuizRepository {
  QuizRepository(this.apiService);

  final ApiService apiService;

  final db = DatabaseHandler();

  // Future<List<String>> getLocalSubjects() async {
  //   final local = await db.getSubjects();
  //   unawaited(getSubjects());
  //   return local;
  // }

  Future<void> _refreshSubjectInBackground() async {
    try {
      final result = await apiService.getJsonRequest('v1/quiz/subjects');
      if (result != null) {
        if (result is Map && result['status'] == true) {
          final data = result['data'] as Map<String, dynamic>;

          final subjects = Subject.fromJson(data).subjects;

          await db.saveSubjects(subjects);
        } else {
          return;
        }
      } else {
        return;
      }
    } catch (_) {}
  }

  Future<List<String>> getSubjects() async {
    final hasLocal = await db.hasSubjects();

    if (hasLocal) {
      unawaited(_refreshSubjectInBackground());
      final local = await db.getSubjects();
      return local;
    }

    final result = await apiService.getJsonRequest('v1/quiz/subjects');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;

        final subjects = Subject.fromJson(data).subjects;

        await db.saveSubjects(subjects);

        final local = await db.getSubjects();
        return local;

        // return subjects;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Future<List<QuestionModel>> getLocalQuizQuestions(String subject) async {
  //   final local = await db.getQuestionBySubject(subject, 40);
  //   unawaited(getQuizQuestions(subject: subject, count: '120'));
  //   return local;
  // }

  Future<void> _refreshQuestionInBackground(String subject) async {
    try {
      final queryParams = <String, dynamic>{'subject': subject};

      const apiCount = 120;

      final result = await apiService.getJsonRequest(
        // 'v1/quiz/questions/many',
        'v1/quiz/questions/huge/$apiCount',
        queryParams: queryParams,
        timeOut: 180,
      );
      if (result != null) {
        if (result is Map && result['status'] == true) {
          final data = result['data'] as Map<String, dynamic>;
          final actualData = data['data'] as List<dynamic>;

          final questions = actualData
              .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList();

          await db.saveQuestions(subject.toLowerCase().trim(), questions);
        } else {
          return;
        }
      } else {
        return;
      }
    } catch (_) {}
  }

  Future<List<QuestionModel>> getQuizQuestions({
    required String subject,
    required int count,
  }) async {
    final queryParams = <String, dynamic>{'subject': subject};

    final hasLocal = await db.hasQuestions(subject.toLowerCase().trim());

    if (hasLocal) {
      // return local immediately
      unawaited(_refreshQuestionInBackground(subject.toLowerCase().trim()));
      final local = await db.getQuestionBySubject(
        subject.toLowerCase().trim(),
        count,
      );
      return local;
    }

    const apiCount = 120;

    final result = await apiService.getJsonRequest(
      // 'v1/quiz/questions/many',
      // 'v1/quiz/questions/$count',
      'v1/quiz/questions/huge/$apiCount',
      queryParams: queryParams,
      timeOut: 180,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final actualData = data['data'] as List<dynamic>;

        final questions = actualData
            .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
            .toList();

        await db.saveQuestions(subject.toLowerCase().trim(), questions);
        final local = await db.getQuestionBySubject(
          subject.toLowerCase().trim(),
          count,
        );
        return local;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> getQuizExplanation(String message) async {
    // log(message);
    final jsonData = <String, dynamic>{'message': message};
    final result = await apiService.postJsonRequest(jsonData, 'chat');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final returnedMessage = data['response'] as String;
        return returnedMessage;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }
}
