import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/course-widget/course_content_widgets.dart';
import 'package:template/features/course/logic/course-content-cubit/course_content_cubit.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/injector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CourseContentPage extends StatelessWidget {
  const CourseContentPage({required this.courseId, super.key});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CourseContentCubit>()..fetchCourseContent(courseId),
      child: CourseContentView(courseId: courseId),
    );
  }
}

class CourseContentView extends StatefulWidget {
  const CourseContentView({required this.courseId, super.key});

  final String courseId;

  @override
  State<CourseContentView> createState() => _CourseContentViewState();
}

class _CourseContentViewState extends State<CourseContentView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  int tabIndex = 0;

  void tabChange(int index) {
    setState(() {
      tabIndex = index;
    });
    if (index == 2) {}
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 1 &&
        context.read<CourseContentCubit>().pageNumber <=
            context.read<CourseContentCubit>().totalPages) {
      context.read<CourseContentCubit>().fetchCourseCommentPagination();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return BlocConsumer<CourseContentCubit, CourseContentState>(
      listener: (context, state) {
        if (state is CourseContentSuccess) {
          if ((state.contentCommentState == ContentCommentState.created ||
                  state.contentNoteState == ContentNoteState.created ||
                  state.contentCommentState == ContentCommentState.replied) &&
              state.createSuccess.isNotEmpty) {
            MevTechUtilities.successToast(context, state.createSuccess);
            context.read<CourseContentCubit>().resetCommentAndNoteState();
          }

          if ((state.contentCommentState == ContentCommentState.notCreated ||
                  state.contentNoteState == ContentNoteState.notCreated ||
                  state.contentCommentState == ContentCommentState.notFetched ||
                  state.contentNoteState == ContentNoteState.notFetched ||
                  state.contentCommentState == ContentCommentState.notReplied ||
                  state.contentCommentState ==
                      ContentCommentState.notPaginated) &&
              state.fetchError.isNotEmpty) {
            MevTechUtilities.errorToast(context, state.fetchError);
            context.read<CourseContentCubit>().resetCommentAndNoteState();
          }
        }
      },
      builder: (context, state) {
        final contentCubit = context.read<CourseContentCubit>();

        var isInstructor = false;
        if (authState is AuthLoginSuccess) {
          isInstructor = authState.model.user.isInstructor;
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Course Details',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // await contentCubit.fetchCourseContent(widget.courseId);
            },
            color: AppColor.primary,
            backgroundColor: Colors.grey.shade200,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            if (state is CourseContentLoading)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CircularProgressIndicator(
                                                color: Colors.grey,
                                                backgroundColor:
                                                    AppColor.primary,
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                'Loading..',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    const ContentHeaderLoding(),
                                  ],
                                ),
                              ),
                            if (state is CourseContentSuccess)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: state.controller != null
                                            ? YoutubePlayer(
                                                controller: state.controller!,
                                              )
                                            : Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Unknown Error',
                                                ),
                                              ),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        'All categories',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        state.courseContentModel != null
                                            ? state.courseContentModel!
                                                .courseContentTitle
                                            : '',
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Ratings',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '4.5',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                                size: 13.w,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  size: 15.w,
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  '12 hours',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 16.w),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.group_outlined,
                                                  size: 15.w,
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  '45,230 students',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: Text(
                                            'Free',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColor.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            if (state is CourseContentFailure)
                              SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.errorMessage,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          maxLines: 5,
                                          style: const TextStyle(
                                            color: AppColor.secondary,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        TextButton.icon(
                                          onPressed: () {
                                            contentCubit.fetchCourseContent(
                                              widget.courseId,
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade100,
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: AppColor.primary,
                                          ),
                                          label: Text(
                                            'Retry',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 15.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: AppColor.primaryLight2,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TabBar(
                                labelColor: Colors.green.shade900,
                                indicatorColor: AppColor.primary,
                                unselectedLabelColor: Colors.black54,
                                labelPadding: EdgeInsets.zero,
                                onTap: contentCubit.tabChange,
                                controller: _tabController,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                                tabs: [
                                  Tab(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: state.currentIndex == 0
                                            ? AppColor.primaryFaint
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Overview'),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: state.currentIndex == 1
                                            ? AppColor.primaryFaint
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Review'),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: state.currentIndex == 2
                                            ? AppColor.primaryFaint
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Notes'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    child: ContentSizeTabBarView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: _tabController,
                                      children: [
                                        if (state is CourseContentSuccess)
                                          ContentOverview(
                                            courseContentModel:
                                                state.courseContentModel,
                                          )
                                        else if (state is CourseContentLoading)
                                          const ContentOverviewLoading()
                                        else
                                          Container(),
                                        if (state is CourseContentSuccess)
                                          ContentComment(
                                            txtPostController:
                                                contentCubit.txtComment,
                                            comments: state.comments,
                                            commentState:
                                                state.contentCommentState,
                                            onPostComment: () {
                                              contentCubit.createCourseComment(
                                                userId: MevTechUtilities.id,
                                                courseContentId:
                                                    state.courseContentModel !=
                                                            null
                                                        ? state
                                                            .courseContentModel!
                                                            .id
                                                        : '',
                                                parentCommentId: '',
                                              );
                                            },
                                            onReply: (reply, parentCommentId) {
                                              // "ab581f78-3cdf-4c03-af67-e19fb6f9cc3f"

                                              contentCubit.replyCourseComment(
                                                userId: MevTechUtilities.id,
                                                courseContentId:
                                                    state.courseContentModel !=
                                                            null
                                                        ? state
                                                            .courseContentModel!
                                                            .id
                                                        : '',
                                                parentCommentId:
                                                    parentCommentId,
                                                replyMessage: reply,
                                              );
                                            },
                                            pageNumber: contentCubit.pageNumber,
                                            totalPages: contentCubit.totalPages,
                                            loadMoreComments: contentCubit
                                                .fetchCourseCommentPagination,
                                            commentUUID: state.commentUUID,
                                          )
                                        else
                                          Container(),
                                        if (state is CourseContentSuccess)
                                          ContentNote(
                                            textController:
                                                contentCubit.txtNotes,
                                            notes: state.notes,
                                            noteState: state.contentNoteState,
                                            onPressed: () {
                                              contentCubit.createCourseNotes(
                                                userId: MevTechUtilities.id,
                                                courseContentId:
                                                    state.courseContentModel !=
                                                            null
                                                        ? state
                                                            .courseContentModel!
                                                            .id
                                                        : '',
                                              );
                                            },
                                          )
                                        else
                                          Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 8.h),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                ),
                child: Container(
                  height: 45.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Enroll now',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // String formatTimeAgo() {
  //   const dateString = '2025-07-22T17:19:05.8809116Z';
  //   final postedDate = DateTime.parse(dateString);
  //   final now = DateTime.now().toUtc();
  //   final difference = now.difference(postedDate);

  //   if (difference.inMinutes < 1) {
  //     // Less than a minute
  //     return '0m'; // Or 'Just now' if you prefer
  //   } else if (difference.inMinutes < 60) {
  //     // Minutes
  //     return '${difference.inMinutes}m';
  //   } else if (difference.inHours < 24) {
  //     // Hours
  //     return '${difference.inHours}h';
  //   } else if (difference.inDays < 7) {
  //     // Days
  //     return '${difference.inDays}d';
  //   } else {
  //     // Weeks (or more)
  //     final inWeeks = (difference.inDays / 7).floor();
  //     return '${inWeeks}w';
  //   }
  // }
}
