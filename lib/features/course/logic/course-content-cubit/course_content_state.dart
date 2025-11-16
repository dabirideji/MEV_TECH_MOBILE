part of 'course_content_cubit.dart';

// enum ContentNoteState {
//   initial,
//   creating,
//   created,
//   notCreated,
//   fetching,
//   fetched,
//   notFetched,
// }

// enum ContentCommentState {
//   initial,
//   creating,
//   created,
//   notCreated,
//   fetching,
//   fetched,
//   notFetched,
//   replying,
//   replied,
//   notReplied,
//   paginating,
//   paginated,
//   notPaginated,
// }

sealed class CourseContentState extends Equatable {
  const CourseContentState({this.currentIndex = 0});

  final int currentIndex;

  @override
  List<Object> get props => [currentIndex];
}

final class CourseContentInitial extends CourseContentState {
  const CourseContentInitial({super.currentIndex});
}

final class CourseContentLoading extends CourseContentState {
  const CourseContentLoading();
}

final class CourseContentSuccess extends CourseContentState {
  const CourseContentSuccess({
    super.currentIndex,
    this.courseContentModel = const [],
    this.notes = const [],
    this.comments = const [],
    this.noteStatus = const Status.initial(),
    this.commentStatus = const Status.initial(),
    this.status = const Status.initial(),
    this.repliesExpanded = const {},
    this.commentUUID = '',
  });

  final List<CourseContentModel> courseContentModel;
  final List<CourseContentNoteModel> notes;
  final List<CourseContentCommentModel> comments;
  final Status noteStatus;
  final Status commentStatus;
  final Status status;
  final Map<String, bool> repliesExpanded;
  final String commentUUID;

  CourseContentSuccess copyWith({
    int? currentIndex,
    List<CourseContentModel>? courseContentModel,
    List<CourseContentNoteModel>? notes,
    List<CourseContentCommentModel>? comments,
    Status? noteStatus,
    Status? commentStatus,
    Status? status,
    Map<String, bool>? repliesExpanded,
    String? commentUUID,
  }) {
    return CourseContentSuccess(
      currentIndex: currentIndex ?? this.currentIndex,
      courseContentModel: courseContentModel ?? this.courseContentModel,
      notes: notes ?? this.notes,
      comments: comments ?? this.comments,
      noteStatus: noteStatus ?? this.noteStatus,
      commentStatus: commentStatus ?? this.commentStatus,
      status: status ?? this.status,
      repliesExpanded: repliesExpanded ?? this.repliesExpanded,
      commentUUID: commentUUID ?? this.commentUUID,
    );
  }

  @override
  List<Object> get props => [
        currentIndex,
        courseContentModel,
        notes,
        comments,
        noteStatus,
        commentStatus,
        status,
        repliesExpanded,
        commentUUID,
      ];
}

final class CourseContentFailure extends CourseContentState {
  const CourseContentFailure(this.errorMessage, {super.currentIndex});

  final String errorMessage;
  @override
  List<Object> get props => [currentIndex, errorMessage];
}
