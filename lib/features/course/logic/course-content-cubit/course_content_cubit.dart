import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/utils/multiple_status_states.dart';
import 'package:template/core/utils/request_states.dart';
import 'package:template/features/course/course-widget/course_content_widgets.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/data/models/course-content-models/course_video_model.dart';
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

  Future<void> fetchCourseContent(String courseId) async {
    try {
      if (!isClosed) {
        emit(const CourseContentLoading());
      }

      final result = await courseRepository.getCourseContentbyID(courseId);

      if (result.isNotEmpty) {
        emit(CourseContentSuccess(
          courseContentModel: result,
        ));
      } else {
        if (!isClosed) {
          emit(
            const CourseContentFailure(
              'No Course Content Found For The Selected Course',
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(CourseContentFailure(e.toString()));
      }
    }
  }

  Future<void> deleteCourseContent(String id) async {
    if (state is! CourseContentSuccess) return;
    final current = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        emit(current.copyWith(status: const Status.loading(CrudAction.delete)));
      }

      await courseRepository.deleteCourseContent(id);
      emit(current.copyWith(
        status: const Status.success(CrudAction.delete),
      ));
    } catch (e) {
      emit(
        current.copyWith(
          status: Status.failure(
            action: CrudAction.delete,
            error: e.toString(),
          ),
        ),
      );
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
          noteStatus: const Status.initial(),
          commentStatus: const Status.initial(),
          repliesExpanded: const {},
          commentUUID: '',
        ),
      );
    }
  }

  Future<void> fetchCoursePlayListContent(String playlistId) async {
    // if (state is! CourseContentSuccess) return;
    // final currentState = state as CourseContentSuccess;
    try {
      if (!isClosed) {
        // emit(
        //   currentState.copyWith(
        //     contentNoteState: ContentNoteState.fetching,
        //   ),
        // );
      }

      final result = await courseRepository.getYoutubeVideos(playlistId);
      if (result.isNotEmpty) {
        if (!isClosed) {
          // emit(
          //   currentState.copyWith(
          //       // contentNoteState: ContentNoteState.fetched,
          //       // notes: result,
          //       ),
          // );
        }
      } else {
        if (!isClosed) {
          // emit(
          //   currentState.copyWith(
          //       // contentNoteState: ContentNoteState.notFetched,
          //       // fetchError: 'unable to fetch notes',
          //       ),
          // );
        }
      }
    } catch (e) {
      if (!isClosed) {
        // emit(
        //   currentState.copyWith(
        //       // contentNoteState: ContentNoteState.notFetched,
        //       // fetchError: e.toString(),
        //       ),
        // );
      }
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
            commentStatus: initialLoading
                ? const Status.loading(CrudAction.fetch)
                : const Status.loading(CrudAction.paginate),
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
            commentStatus: initialLoading
                ? const Status.success(CrudAction.fetch)
                : const Status.success(CrudAction.paginate),
            comments: updatedComments,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            commentStatus: initialLoading
                ? Status.failure(action: CrudAction.fetch, error: e.toString())
                : Status.failure(
                    action: CrudAction.paginate, error: e.toString()),
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
            noteStatus: const Status.loading(CrudAction.fetch),
          ),
        );
      }

      final result = await courseRepository.getContentsNotes();
      if (result.isNotEmpty) {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              noteStatus: const Status.success(CrudAction.fetch),
              notes: result,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              noteStatus: const Status.failure(
                action: CrudAction.fetch,
                error: 'unable to fetch notes',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            noteStatus: Status.failure(
              action: CrudAction.fetch,
              error: e.toString(),
            ),
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
            noteStatus: const Status.loading(CrudAction.create),
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
            noteStatus: const Status.success(CrudAction.create),
            notes: notes,
          ),
        );
      }
      clearField();
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            noteStatus:
                Status.failure(action: CrudAction.create, error: e.toString()),
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
            commentStatus: const Status.loading(CrudAction.fetch),
          ),
        );
      }

      final result = await courseRepository.getContentsComment();
      if (result.isNotEmpty) {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              commentStatus: const Status.success(CrudAction.fetch),
              comments: result,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(
            currentState.copyWith(
              commentStatus: const Status.failure(
                  action: CrudAction.fetch, error: 'unable to fetch Comments'),
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            commentStatus:
                Status.failure(action: CrudAction.fetch, error: e.toString()),
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
            commentStatus: const Status.loading(CrudAction.create),
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
            commentStatus: const Status.success(CrudAction.create),
            comments: comment,
          ),
        );
      }
      clearField();
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            commentStatus: Status.failure(
              action: CrudAction.create,
              error: e.toString(),
            ),
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
            commentStatus:
                const Status.loading(CrudAction.create, subtype: 'reply'),
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
            commentStatus:
                const Status.success(CrudAction.create, subtype: 'reply'),
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
            commentStatus: Status.failure(
                action: CrudAction.create,
                error: e.toString(),
                subtype: 'reply'),
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
