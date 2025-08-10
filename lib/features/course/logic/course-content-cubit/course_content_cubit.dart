import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:template/features/course/course-widget/course_content_widgets.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/repository/course_repository.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

part 'course_content_state.dart';

@injectable
class CourseContentCubit extends Cubit<CourseContentState> {
  CourseContentCubit(this.courseRepository)
      : super(const CourseContentInitial());

  final CourseRepository courseRepository;
  YoutubePlayerController? _controller;

  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  // List<CourseContentCommentModel> _comments = [];
  int pageNumber = 1;
  int totalPages = 1;
  bool _hasMoreData = true;
  bool isLoading = false;

  final int _pageSize = 10;

  void clearField() {
    txtNotes.clear();
    txtComment.clear();
  }

  Future<void> tabChange(int index) async {
    clearField();
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;

    if (!isClosed) {
      emit(
        currentState.copyWith(currentIndex: index),
      );
    }

    if (currentState.currentIndex == index) return;

    if (index == 1) {
      if (currentState.comments.isNotEmpty) return;
      await Future.delayed(const Duration(seconds: 1), () {});
      await fetchCourseCommentPagination();
    }

    if (index == 2) {
      if (currentState.notes.isNotEmpty) return;
      await Future.delayed(const Duration(seconds: 1), () {});
      await fetchCourseNotes();
    }
  }

  Future<void> fetchCourseContent(String id) async {
    // https://www.youtube.com/watch?v=AURnISajubk
    try {
      if (!isClosed) {
        emit(const CourseContentLoading(currentIndex: 0));
      }

      final result = await courseRepository.getCourseContentbyID(id);
      if (result.isNotEmpty) {
        final videoUrl = result.first.courseContentVideoUrl;

        // final videoUrl = '';
        if (!videoUrl.contains('https://www.youtube.com')) {
          emit(
            const CourseContentFailure(
              'Invalid Video Link',
              currentIndex: 0,
            ),
          );
          return;
        }
        final controller = await fetchAndPlayVideo(videoUrl);

        if (controller != null) {
          emit(CourseContentSuccess(
            // remove
            contentCommentState: ContentCommentState.initial,
            controller: controller,
            courseContentModel: result.first,
            currentIndex: 0,
          ));
        } else {
          emit(
            const CourseContentFailure(
              'An Error ccured. please try again',
              currentIndex: 0,
            ),
          );
        }

        // if (!isClosed) {
        //   emit(CourseContentSuccess(courseContentModel: result.first, currentIndex: 0,));
        // }
      } else {
        if (!isClosed) {
          emit(
            const CourseContentFailure(
              'No Course Content Found For The Selected Course',
              currentIndex: 0,
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(CourseContentFailure(e.toString(), currentIndex: 0));
      }
    }
  }

  Future<YoutubePlayerController?> fetchAndPlayVideo(String youtubeUrl) async {
    // final youtubeUrl = await fetchYouTubeLink(); dont uncomment this line
    final videoId = getYouTubeVideoId(youtubeUrl);

    if (videoId.isNotEmpty) {
      return _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    } else {
      throw Exception('Requested Video Not Found');
    }
    // return null;
  }

  String getYouTubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  @override
  Future<void> close() {
    _controller?.close();
    _controller = null;

    return super.close();
  }

  void resetCommentAndNoteState() {
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;
    if (!isClosed) {
      emit(
        currentState.copyWith(
          contentNoteState: ContentNoteState.initial,
          contentCommentState: ContentCommentState.initial,
          fetchError: '',
          createSuccess: '',
          repliesExpanded: const {},
          commentUUID: '',
        ),
      );
    }
  }

  Future<void> fetchCourseCommentPagination() async {
    if (isLoading) return;
    if (pageNumber > totalPages && totalPages > 0) {
      _hasMoreData = false;
      isLoading = false;
      return;
    }
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;

    final initialLoading = pageNumber == 1;

    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: initialLoading
                ? ContentCommentState.fetching
                : ContentCommentState.paginating,
          ),
        );
      }
      isLoading = true;

      final queryParams = {
        'PageNumber': pageNumber.toString(),
        'PageSize': _pageSize.toString(),
      };

      final paginationResponse = await courseRepository
          .getContentsCommentPaginated(queryParams: queryParams);

      pageNumber = paginationResponse.pageNumber + 1;
      totalPages = paginationResponse.totalPages;

      final updatedComments =
          List<CourseContentCommentModel>.from(currentState.comments)
            ..addAll(paginationResponse.result);

      if (!isClosed) {
        // pageNumber++;
        emit(
          currentState.copyWith(
            contentCommentState: initialLoading
                ? ContentCommentState.fetched
                : ContentCommentState.paginated,
            comments: updatedComments,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: initialLoading
                ? ContentCommentState.notFetched
                : ContentCommentState.notPaginated,
            fetchError: e.toString(),
          ),
        );
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchCourseNotes() async {
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentNoteState: ContentNoteState.fetching,
          ),
        );
      }

      final result = await courseRepository.getContentsNotes();
      if (result.isNotEmpty) {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              contentNoteState: ContentNoteState.fetched,
              notes: result,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              contentNoteState: ContentNoteState.notFetched,
              fetchError: 'unable to fetch notes',
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentNoteState: ContentNoteState.notFetched,
            fetchError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> createCourseNotes({
    required String userId,
    required String courseContentId,
  }) async {
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentNoteState: ContentNoteState.creating,
          ),
        );
      }

      final jsonData = <String, dynamic>{
        'userId': userId,
        'courseContentId': courseContentId,
        'note': txtNotes.text,
      };

      final result = await courseRepository.createContentNote(jsonData);
      final notes = await courseRepository.getContentsNotes();
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentNoteState: ContentNoteState.created,
            createSuccess: result,
            notes: notes,
          ),
        );
      }
      clearField();
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentNoteState: ContentNoteState.notCreated,
            fetchError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> fetchCourseComment() async {
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.fetching,
          ),
        );
      }

      final result = await courseRepository.getContentsComment();
      if (result.isNotEmpty) {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              contentCommentState: ContentCommentState.fetched,
              comments: result,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              contentCommentState: ContentCommentState.notFetched,
              fetchError: 'unable to fetch notes',
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.notFetched,
            fetchError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> createCourseComment({
    required String userId,
    required String courseContentId,
    required String? parentCommentId,
  }) async {
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.creating,
          ),
        );
      }

      final jsonData = parentCommentId != null && parentCommentId.isNotEmpty
          ? <String, dynamic>{
              'courseContentId': courseContentId,
              'userId': userId,
              'parentCommentId': parentCommentId,
              'message': txtComment.text,
            }
          : <String, dynamic>{
              'courseContentId': courseContentId,
              'userId': userId,
              'message': txtComment.text,
            };

      final result = await courseRepository.createContentComment(jsonData);
      final comment = await courseRepository.getContentsComment();
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.created,
            createSuccess: result,
            comments: comment,
          ),
        );
      }
      clearField();
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.notCreated,
            fetchError: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> replyCourseComment({
    required String userId,
    required String courseContentId,
    required String? parentCommentId,
    required String replyMessage,
  }) async {
    resetCommentAndNoteState();
    if (state is! CourseContentSuccess) return;
    final currentState = state as CourseContentSuccess;

    try {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.replying,
            commentUUID: parentCommentId,
          ),
        );
      }

      final jsonData = parentCommentId != null && parentCommentId.isNotEmpty
          ? <String, dynamic>{
              'courseContentId': courseContentId,
              'userId': userId,
              'parentCommentId': parentCommentId,
              'message': replyMessage,
            }
          : <String, dynamic>{
              'courseContentId': courseContentId,
              'userId': userId,
              'message': replyMessage,
            };

      final result = await courseRepository.createContentComment(jsonData);
      final comment = await courseRepository.getContentsComment();
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.replied,
            createSuccess: result,
            comments: comment,
            commentUUID: '',
          ),
        );
      }
      clearField();
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            contentCommentState: ContentCommentState.notReplied,
            fetchError: e.toString(),
            commentUUID: '',
          ),
        );
      }
    }
  }

  // Future<void> tester() async {
  //   if (state is! CourseContentSuccess) return;
  //   final currentState = state as CourseContentSuccess;

  //   final initialLoading = pageNumber == 1;

  //   emit(
  //     currentState.copyWith(
  //       contentCommentState: initialLoading
  //           ? ContentCommentState.fetching
  //           : ContentCommentState.paginating,
  //     ),
  //   );

  //   await Future.delayed(const Duration(seconds: 3), () {});

  //   var aa =
  //       'Am\ndoing\nwell\nright\nhere\ngo there\nand find\nout what\nthey are\nup to';
  //   log(aa);
  //   emit(
  //     currentState.copyWith(
  //       contentCommentState: ContentCommentState.notPaginated,
  //     ),
  //   );
  //   log(currentState.contentCommentState.toString());
  //   var aaf = 'hjdi';
  // }
}
