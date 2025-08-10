import 'dart:developer';

import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/comment_nodes.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_model.dart';
import 'package:template/features/course/logic/course-content-cubit/course_content_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

class ContentHeaderLoding extends StatelessWidget {
  const ContentHeaderLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 250.w,
                height: 20.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h),
              ),
              Container(
                width: 60.w,
                height: 16.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h),
              ),
            ],
          ),
          Container(
            width: 300.w,
            height: 20.h,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 8.h),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 180.w,
                height: 16.h,
                color: Colors.white,
              ),
              Container(
                width: 60.w,
                height: 16.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentOverview extends StatelessWidget {
  const ContentOverview({required this.courseContentModel, super.key});

  final CourseContentModel? courseContentModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Information',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          Icons.thumb_up_outlined,
                          size: 15.w,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          Icons.thumb_down_outlined,
                          size: 15.w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              // Course Description
              Text(
                courseContentModel != null
                    ? courseContentModel!.courseContentDescription
                    : '',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
            ],
          ),
          Divider(
            thickness: 0.7,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'Instructor:',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: 7.w),
              Text(
                'Willy Morgan',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentComment extends StatefulWidget {
  const ContentComment({
    required this.comments,
    required this.commentState,
    required this.pageNumber,
    required this.totalPages,
    required this.commentUUID,
    this.onPostComment,
    this.onReply,
    this.txtPostController,
    this.txtReplyController,
    super.key,
    this.loadMoreComments,
  });

  final List<CourseContentCommentModel> comments;
  final ContentCommentState commentState;
  final void Function()? onPostComment;
  final void Function(String, String)? onReply;
  final TextEditingController? txtPostController;
  final TextEditingController? txtReplyController;
  final int pageNumber;
  final int totalPages;
  final void Function()? loadMoreComments;
  final String commentUUID;

  @override
  State<ContentComment> createState() => _ContentCommentState();
}

class _ContentCommentState extends State<ContentComment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: AppColor.primary,
                child: Text(
                  'YO',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: widget.txtPostController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  cursorHeight: 17.h,
                  cursorColor: Colors.black54,
                  maxLength: 500,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: widget.commentState == ContentCommentState.creating
                  ? null
                  : widget.onPostComment,
              label: Text(
                widget.commentState == ContentCommentState.creating
                    ? 'Posting..'
                    : 'Post Comment',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: widget.commentState == ContentCommentState.creating
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.commentState == ContentCommentState.creating
                        ? AppColor.primaryFaint
                        : AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Builder(
            builder: (context) {
              if (widget.commentState == ContentCommentState.fetching) {
                return const Center(
                  child: ContentCommentLoading(),
                );
              } else if (widget.commentState ==
                  ContentCommentState.notFetched) {
                return const Center(
                  child: Text('Failed to load comments.'),
                );
              } else {
                if (widget.comments.isEmpty) {
                  return const Center(
                    child: Text('No comments yet. Be the first to comment!'),
                  );
                }
                if (widget.commentState == ContentCommentState.replied) {
                  setState(() {});
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 10.h),
                  itemCount: widget.comments.length +
                      (widget.commentState == ContentCommentState.paginating
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index < widget.comments.length) {
                      final rootComment = widget.comments[index];
                      return ExpandableCommentTree(
                        rootComment: rootComment,
                        onReply: widget.onReply,
                        commentState: widget.commentState,
                        commentUUID: widget.commentUUID,
                      );
                    } else {
                      if (widget.commentState ==
                          ContentCommentState.paginating) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Center(
                            child: SizedBox(
                              height: 30.h,
                              width: 30.h,
                              child: const CircularProgressIndicator(
                                color: Colors.grey,
                                backgroundColor: AppColor.primary,
                              ),
                            ),
                          ),
                        );
                      }
                      // else if (widget.commentState ==
                      //     ContentCommentState.notPaginated) {
                      //   return Padding(
                      //     padding: EdgeInsets.all(8.r),
                      //     child: Center(
                      //       child: ElevatedButton(
                      //         onPressed: () {},
                      //         child: const Text('Retry'),
                      //       ),
                      //     ),
                      //   );
                      // }
                    }

                    // if (index == widget.comments.length) {
                    //   if (widget.commentState ==
                    //       ContentCommentState.paginating) {
                    //     return Padding(
                    //       padding: EdgeInsets.all(8.r),
                    //       child:
                    //           const Center(child: CircularProgressIndicator()),
                    //     );
                    //   }
                    // }
                    return const SizedBox.shrink();
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ExpandableCommentTree extends StatefulWidget {
  const ExpandableCommentTree({
    required this.rootComment,
    required this.commentState,
    required this.commentUUID,
    this.onReply,
    this.avatarRootSize = 18,
    this.avatarChildSize = 12,
    this.commentTreePadding = const EdgeInsets.symmetric(vertical: 3),
    this.avatarRootFontSize = 14,
    this.isNestedChild = false,
    super.key,
  });

  final CourseContentCommentModel rootComment;
  final void Function(String, String)? onReply;
  final double avatarRootSize;
  final double avatarChildSize;
  final EdgeInsetsGeometry? commentTreePadding;
  final double avatarRootFontSize;
  final bool isNestedChild;
  final ContentCommentState commentState;
  final String commentUUID;

  @override
  State<ExpandableCommentTree> createState() => _ExpandableCommentTreeState();
}

class _ExpandableCommentTreeState extends State<ExpandableCommentTree> {
  bool _isExpanded = false;
  final _formKey = GlobalKey<FormState>();

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showReplyBottomSheet({
    required BuildContext context,
    required String userFullName,
    required String parentCommentId,
    void Function(String, String)? onSend,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // This is crucial for keyboard to push sheet up
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final txtMessage = TextEditingController();
        final textFocus = FocusNode();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjusts for keyboard
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Make column take minimum space
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  const Text('Replying to '),
                  Text(
                    userFullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: txtMessage,
                  focusNode: textFocus,
                  autofocus: true, // Automatically open keyboard
                  maxLines: null, // Allow multiple lines
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Enter your reply',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(fontSize: 14),
                  validator: FormValidator.customField,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onSend?.call(txtMessage.text, parentCommentId);

                      txtMessage.clear();
                      textFocus.unfocus();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String formatTimeAgo(String dateString) {
    final postedDate = DateTime.parse('${dateString}Z');
    final now = DateTime.now().toUtc();
    final difference = now.difference(postedDate);

    if (difference.inMinutes < 1) {
      // Less than a minute
      return '0m'; // Or 'Just now' if you prefer
    } else if (difference.inMinutes < 60) {
      // Minutes
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      // Hours
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      // Days
      return '${difference.inDays}d';
    } else {
      // Weeks (or more)
      final inWeeks = (difference.inDays / 7).floor();
      return '${inWeeks}w';
    }
  }

  String _userFullname(CourseContentCommentModel comment) {
    final userFullname = comment.user != null
        ? '${comment.user!.firstName} ${comment.user!.lastName}'
        : comment.userFullName != null
            ? comment.userFullName!
            : 'Deleted User';

    return userFullname;
  }

  String _nameInitial(CourseContentCommentModel comment) {
    final nameInitial = comment.user != null
        ? '${comment.user!.firstName[0]} ${comment.user!.lastName[0]}'
        : comment.userFullName != null
            ? comment.userFullName!.substring(
                0,
                comment.userFullName!.length.clamp(0, 2),
              )
            : 'NA';
    return nameInitial.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasReplies = widget.rootComment.replies?.isNotEmpty ?? false;
    List<CommentTreeNode>? repliesToRender = <CommentTreeNode>[];

    if (_isExpanded &&
        widget.rootComment.replies != null &&
        widget.rootComment.replies!.isNotEmpty) {
      // If expanded, render all actual replies as RegularCommentNodes
      repliesToRender =
          widget.rootComment.replies?.map(RegularCommentNode.new).toList();
    } else if (hasReplies) {
      // If collapsed BUT has replies, render ONE ViewMoreRepliesNode
      repliesToRender = [
        ViewMoreRepliesNode(
          widget.rootComment.replies!.length,
          widget.rootComment.id,
        ),
      ];
    }

    return Container(
      padding: widget.commentTreePadding,
      child: CommentTreeWidget<CourseContentCommentModel, CommentTreeNode>(
        widget.rootComment,
        repliesToRender ?? [],
        treeThemeData:
            TreeThemeData(lineColor: Colors.grey.shade300, lineWidth: 3),
        avatarRoot: (context, comment) => PreferredSize(
          preferredSize: Size.fromRadius(widget.avatarRootSize),
          child: widget.isNestedChild
              ? const CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.transparent,
                )
              : CircleAvatar(
                  radius: widget.avatarRootSize,
                  backgroundColor: AppColor.secondary,
                  child: Text(
                    _nameInitial(comment),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.avatarRootFontSize.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        avatarChild: (context, node) {
          if (node is ViewMoreRepliesNode) {
            return PreferredSize(
              preferredSize: Size.fromRadius(widget.avatarChildSize),
              child: TextButton(
                onPressed: _toggleExpansion,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                child: Text(
                  node.count == 1
                      ? 'View ${node.count} reply...'
                      : node.count > 1
                          ? 'View ${node.count} replies...'
                          : '',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          } else if (node is RegularCommentNode) {
            final comment = node.comment;
            return PreferredSize(
              preferredSize: Size.fromRadius(widget.avatarChildSize),
              child: CircleAvatar(
                radius: widget.avatarChildSize,
                backgroundColor: AppColor.secondaryFade,
                child: Text(
                  _nameInitial(comment),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }

          return const PreferredSize(
            preferredSize: Size.fromRadius(12),
            child: SizedBox.shrink(),
          );
        },
        contentChild: (context, node) {
          if (node is ViewMoreRepliesNode) {
            return const PreferredSize(
              preferredSize: Size.fromRadius(12),
              child: SizedBox.shrink(),
            );
          } else if (node is RegularCommentNode) {
            final comment = node.comment;
            final hasNestedReplies = comment.replies?.isNotEmpty ?? false;
            final isReplying = (widget.commentUUID == comment.id) &&
                (widget.commentState == ContentCommentState.replying);

            if (hasNestedReplies) {
              return ExpandableCommentTree(
                rootComment: comment,
                onReply: widget.onReply,
                commentTreePadding: EdgeInsets.zero,
                avatarRootSize: 12,
                avatarRootFontSize: 11.sp,
                isNestedChild: true,
                commentState: widget.commentState,
                commentUUID: widget.commentUUID,
              );
            } else {
              // Regular leaf comment content

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userFullname(comment),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          comment.message,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                    child: Row(
                      children: [
                        Text(
                          formatTimeAgo(comment.createdAt),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                          ),
                          child: Text(
                            'Like',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        if (isReplying)
                          Center(
                            child: SizedBox(
                              height: 15.h,
                              width: 15.h,
                              child: const CircularProgressIndicator(
                                color: Colors.grey,
                                backgroundColor: AppColor.primary,
                              ),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              _showReplyBottomSheet(
                                context: context,
                                // txtMessage: widget.txtReplyController,
                                userFullName: _userFullname(comment),
                                parentCommentId: comment.id,
                                onSend: (replyMessage, parentCommentId) {
                                  widget.onReply
                                      ?.call(replyMessage, parentCommentId);
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                            ),
                            child: Text(
                              'Reply',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }

          return const SizedBox.shrink();
        },
        contentRoot: (context, comment) {
          final isReplying = (widget.commentUUID == comment.id) &&
              (widget.commentState == ContentCommentState.replying);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColor.primaryLight2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userFullname(comment),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      comment.message,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                child: Row(
                  children: [
                    Text(
                      formatTimeAgo(comment.createdAt),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      child: Text(
                        'Like',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (isReplying)
                      Center(
                        child: SizedBox(
                          height: 15.h,
                          width: 15.h,
                          child: const CircularProgressIndicator(
                            color: Colors.grey,
                            backgroundColor: AppColor.primary,
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          _showReplyBottomSheet(
                            context: context,
                            // txtMessage: widget.txtReplyController,
                            userFullName: _userFullname(comment),
                            parentCommentId: comment.id,
                            onSend: (replyMessage, parentCommentId) {
                              widget.onReply
                                  ?.call(replyMessage, parentCommentId);
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        child: Text(
                          'Reply',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContentNote extends StatelessWidget {
  const ContentNote({
    required this.notes,
    required this.noteState,
    required this.onPressed,
    super.key,
    this.textController,
  });

  final List<CourseContentNoteModel> notes;
  final ContentNoteState noteState;
  final void Function()? onPressed;
  final TextEditingController? textController;

  @override
  Widget build(BuildContext context) {
    Widget noteListWidget;

    if (noteState == ContentNoteState.fetching) {
      noteListWidget = const Center(
        child: ContentNoteLoding(),
      );
    } else if (noteState == ContentNoteState.notFetched) {
      noteListWidget = const Center(
        child: Text('Failed to load notes.'),
      );
    } else {
      noteListWidget = _buildNotesList(notes);
    }

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent.shade400,
                child: const Text(
                  'YO',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Add Notes...',
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  cursorHeight: 17.h,
                  cursorColor: Colors.black54,
                  maxLines: 3,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed:
                  noteState == ContentNoteState.creating ? null : onPressed,
              label: Text(
                noteState == ContentNoteState.creating
                    ? 'Saving..'
                    : 'Save Note',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: noteState == ContentNoteState.creating
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child:
                          const CircularProgressIndicator(color: Colors.white),
                    )
                  : const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: noteState == ContentNoteState.creating
                    ? AppColor.primaryFaint
                    : AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          noteListWidget,
        ],
      ),
    );
  }

  Widget _buildNotesList(List<CourseContentNoteModel> notes) {
    if (notes.isEmpty) {
      return const Center(
        child: Text('Add notes!'),
      );
    }
    return Column(
      children: List.generate(notes.length, (index) {
        final note = notes[index];
        return Container(
          margin: EdgeInsets.only(top: 10.h),
          width: double.infinity,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(
              color: Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.note),
              SizedBox(height: 5.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  MevTechUtilities.formatDateTime(note.createdAt),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColor.secondaryFade,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ContentOverviewLoading extends StatelessWidget {
  const ContentOverviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200.w,
                height: 20.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 15.h),
              ),
              Container(
                width: 70.w,
                height: 25.h,
                margin: EdgeInsets.only(bottom: 15.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: double.infinity,
            height: 16.h,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: double.infinity,
            height: 16.h,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: double.infinity,
            height: 16.h,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: double.infinity,
            height: 16.h,
            color: Colors.white,
          ),
          Row(
            children: [
              Container(
                width: 100.w,
                height: 20.h,
                color: Colors.white,
                margin: EdgeInsets.only(top: 20.h),
              ),
              Container(
                width: 100.w,
                height: 20.h,
                margin: EdgeInsets.only(top: 20.h, left: 10.w),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContentNoteLoding extends StatelessWidget {
  const ContentNoteLoding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.4),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 10.h,
              margin: EdgeInsets.only(bottom: 3.h),
              color: Colors.white,
            ),
            Container(
              width: double.infinity,
              height: 10.h,
              margin: EdgeInsets.only(bottom: 3.h),
              color: Colors.white,
            ),
            Container(
              width: double.infinity,
              height: 10.h,
              margin: EdgeInsets.only(bottom: 3.h),
              color: Colors.white,
            ),
            Container(
              width: double.infinity,
              height: 10.h,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ContentCommentLoading extends StatelessWidget {
  const ContentCommentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                width: 40.w,
                height: 8.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h, left: 10),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35.w,
                height: 35.h,
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                children: [
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                width: 40.w,
                height: 8.h,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h, left: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
