import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/core/extensions/string_extension.dart';
import 'package:mevtech/core/utils/request_states.dart';
import 'package:mevtech/features/quiz/data/models/question_model.dart';
import 'package:mevtech/features/quiz/data/repository/quiz_repository.dart';

part 'quiz_state.dart';

@injectable
class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this.quizRepository) : super(const QuizState());

  final QuizRepository quizRepository;

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

      final subjects = await quizRepository.getSubjects();

      if (!isClosed) {
        emit(
          state.copyWith(
            subjectStatus: const RequestState.success(),
            subjects: subjects.map((e) => e.capitalize()).toList(),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(subjectStatus: RequestState.failure(e.toString())));
      }
    }
  }

  Future<void> fetchQuizQuestions(String subject) async {
    try {
      if (!isClosed) {
        emit(state.copyWith(questionStatus: const RequestState.loading()));
      }

      final questions = await quizRepository.getQuizQuestions(
        subject: subject,
        count: 40,
      );

      final initialSelections = List<int?>.filled(questions.length, null);

      if (!isClosed) {
        emit(
          state.copyWith(
            questionStatus: const RequestState.success(),
            questions: questions,
            selectedAnswers: initialSelections,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(questionStatus: RequestState.failure(e.toString())),
        );
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

  Future<String?> fetchQuizExplanation(String message) async {
    try {
      // if (!isClosed) {
      //   emit(state.copyWith());
      // }

      final explanationMessage = await quizRepository.getQuizExplanation(
        message,
      );

      return explanationMessage;
    } catch (e) {
      // if (!isClosed) {
      //   emit(state.copyWith());
      // }

      rethrow;
    }
  }

  Future<String?> fetchMockExplanation(String message) async {
    try {
      if (!isClosed) {
        emit(state.copyWith());
      }
      // final explanationMessage = await quizRepository.getQuizExplanation(
      //   message,
      // );
      final explanationMessage = await Future.delayed(
        const Duration(seconds: 4),
        () {
          return 'The Transaction was succesful';
          // return {'high'} as String;
        },
      );

      return explanationMessage;
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith());
      }
      // return null;
      rethrow;
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
