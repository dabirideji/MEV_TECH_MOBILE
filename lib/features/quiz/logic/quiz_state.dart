part of 'quiz_cubit.dart';

enum ResultState { none, loading, success, failure }

class QuizState extends Equatable {
  const QuizState({
    this.subjects = const [],
    this.questions = const [],
    this.subjectId,
    this.subjectStatus = const RequestState.initial(),
    this.questionStatus = const RequestState.initial(),
    this.selectedAnswers = const [],
    this.resultState = ResultState.none,
  });

  final List<String> subjects;
  final List<QuestionModel> questions;
  final String? subjectId;
  final RequestState subjectStatus;
  final RequestState questionStatus;
  final List<int?> selectedAnswers;
  final ResultState resultState;

  QuizState copyWith({
    List<String>? subjects,
    List<QuestionModel>? questions,
    String? subjectId,
    RequestState? subjectStatus,
    RequestState? questionStatus,
    List<int?>? selectedAnswers,
    ResultState? resultState,
  }) {
    return QuizState(
      subjects: subjects ?? this.subjects,
      questions: questions ?? this.questions,
      subjectId: subjectId,
      subjectStatus: subjectStatus ?? this.subjectStatus,
      questionStatus: questionStatus ?? this.questionStatus,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      resultState: resultState ?? this.resultState,
    );
  }

  @override
  List<Object?> get props => [
        subjects,
        questions,
        subjectId,
        subjectStatus,
        questionStatus,
        selectedAnswers,
        resultState,
      ];
}
