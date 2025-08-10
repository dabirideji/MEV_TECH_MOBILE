part of 'course_content_cubit.dart';

enum ContentNoteState {
  initial,
  creating,
  created,
  notCreated,
  fetching,
  fetched,
  notFetched,
}

enum ContentCommentState {
  initial,
  creating,
  created,
  notCreated,
  fetching,
  fetched,
  notFetched,
  replying,
  replied,
  notReplied,
  paginating,
  paginated,
  notPaginated,
}

sealed class CourseContentState extends Equatable {
  const CourseContentState({required this.currentIndex});

  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

final class CourseContentInitial extends CourseContentState {
  const CourseContentInitial({super.currentIndex = 0});
}

final class CourseContentLoading extends CourseContentState {
  const CourseContentLoading({required super.currentIndex});
  @override
  List<Object?> get props => [currentIndex];
}

final class CourseContentSuccess extends CourseContentState {
  const CourseContentSuccess({
    required super.currentIndex,
    required this.contentCommentState,
    this.courseContentModel,
    this.controller,
    this.contentNoteState = ContentNoteState.initial,
    // = ContentCommentState.initial,
    this.notes = const [],
    this.comments = const [],
    this.fetchError = '',
    this.createSuccess = '',
    this.repliesExpanded = const {},
    this.commentUUID = '',
  });

  final CourseContentModel? courseContentModel;
  final YoutubePlayerController? controller;
  final ContentNoteState contentNoteState;
  final ContentCommentState contentCommentState;
  final List<CourseContentNoteModel> notes;
  final List<CourseContentCommentModel> comments;
  final String fetchError;
  final String createSuccess;
  final Map<String, bool> repliesExpanded;
  final String commentUUID;

  CourseContentSuccess copyWith({
    int? currentIndex,
    CourseContentModel? courseContentModel,
    YoutubePlayerController? controller,
    ContentNoteState? contentNoteState,
    ContentCommentState? contentCommentState,
    List<CourseContentNoteModel>? notes,
    List<CourseContentCommentModel>? comments,
    String? fetchError,
    String? createSuccess,
    Map<String, bool>? repliesExpanded,
    String? commentUUID,
  }) {
    return CourseContentSuccess(
      currentIndex: currentIndex ?? this.currentIndex,
      courseContentModel: courseContentModel ?? this.courseContentModel,
      controller: controller ?? this.controller,
      contentNoteState: contentNoteState ?? this.contentNoteState,
      contentCommentState: contentCommentState ?? this.contentCommentState,
      notes: notes ?? this.notes,
      comments: comments ?? this.comments,
      fetchError: fetchError ?? this.fetchError,
      createSuccess: createSuccess ?? this.createSuccess,
      repliesExpanded: repliesExpanded ?? this.repliesExpanded,
      commentUUID: commentUUID ?? this.commentUUID,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        courseContentModel,
        controller,
        contentNoteState,
        contentCommentState,
        notes,
        comments,
        fetchError,
        createSuccess,
        repliesExpanded,
        commentUUID,
      ];
}

final class CourseContentFailure extends CourseContentState {
  const CourseContentFailure(this.errorMessage, {required super.currentIndex});

  final String errorMessage;
  @override
  List<Object?> get props => [currentIndex, errorMessage];
}
