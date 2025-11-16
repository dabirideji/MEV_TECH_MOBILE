import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/utils/request_states.dart';
import 'package:template/features/quiz/data/models/question_model.dart';
import 'package:template/features/quiz/data/models/subject_model.dart';
import 'package:template/features/user/data/repository/user_repository.dart';

part 'quiz_state.dart';

@injectable
class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this.userRepository) : super(const QuizState());

  final UserRepository userRepository;

  void selectSubject(String? subjectId) {
    if (!isClosed) {
      emit(state.copyWith(subjectId: subjectId));
    }
  }

  void selectAnswer(int questionIndex, int selectedOptionIndex) {
    final updatedAnswers = List<int?>.from(state.selectedAnswers);

    updatedAnswers[questionIndex] = selectedOptionIndex;

    if (!isClosed) {
      emit(state.copyWith(selectedAnswers: updatedAnswers));
    }
  }

  // selectedAnswers[currentQuizIndex] = index;

  Future<void> fetchSubjects() async {
    try {
      if (!isClosed) {
        emit(state.copyWith(subjectStatus: const RequestState.loading()));
      }

      final subject = await userRepository.getSubjects();

      if (!isClosed) {
        emit(state.copyWith(
          subjectStatus: const RequestState.success(),
          subjects: subject.subjects,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(subjectStatus: RequestState.failure(e.toString())));
      }
    }
  }

  Future<void> fetchQuizQuestions(String subject) async {
    final queryParams = <String, dynamic>{'subject': subject};
    try {
      if (!isClosed) {
        emit(state.copyWith(questionStatus: const RequestState.loading()));
      }
      final questions = await userRepository.getQuizQuestions(
          queryParams: queryParams, count: '10');

      final initialSelections = List<int?>.filled(questions.length, null);

      if (!isClosed) {
        emit(state.copyWith(
          questionStatus: const RequestState.success(),
          questions: questions,
          selectedAnswers: initialSelections,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
            state.copyWith(questionStatus: RequestState.failure(e.toString())));
      }
    }
  }

  void fetchQuizResult() {
    try {
      if (!isClosed) {
        emit(state.copyWith(resultState: ResultState.success));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(resultState: ResultState.failure));
      }
    }
  }

  void resetQuizResult() {
    try {
      if (!isClosed) {
        emit(state.copyWith(resultState: ResultState.none));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(resultState: ResultState.none));
      }
    }
  }
}
