import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/course/course-widget/dropdown_btn.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/quiz/logic/quiz_cubit.dart';
import 'package:mevtech/features/quiz/widget/quiz_container.dart';

class QuizModeScreen extends StatefulWidget {
  const QuizModeScreen({super.key});

  @override
  State<QuizModeScreen> createState() => _QuizModeScreenState();
}

class _QuizModeScreenState extends State<QuizModeScreen> {
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizCubit>().fetchSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final quizCubit = context.read<QuizCubit>();
    final quizState = context.read<QuizCubit>().state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: const Icon(Icons.arrow_back),
        // ),
        title: Text(
          'Quiz Mode',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        // actions: [
        //   TextButton(
        //       onPressed: () {
        //         Navigator.of(context)
        //             .push(MaterialPageRoute<dynamic>(builder: (context) {
        //           return TestingPage();
        //         }));
        //       },
        //       child: Text('Testing Class'))
        // ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Subject',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<QuizCubit, QuizState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownButton(
                        enabled: !state.subjectStatus.isLoading,
                        hintText: state.subjectStatus.isLoading
                            ? 'Loading...'
                            : state.subjectStatus.isFailure &&
                                  state.subjects.isEmpty
                            ? 'Unable to fetch subject'
                            : 'Select Subject',
                        initialValue: state.subjectId,
                        items: state.subjects,
                        onChanged: quizCubit.selectSubject,
                      ),
                      Visibility(
                        visible:
                            state.subjects.isEmpty &&
                            state.subjectStatus.isFailure,
                        child: TextButton.icon(
                          onPressed: quizCubit.fetchSubjects,
                          label: Text(
                            'Reload Subject',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          // iconAlignment: IconAlignment.end,
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.black54,
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            backgroundColor: Colors.white,
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      QuizModeContainer(
                        icon: const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: 'Practice Mode',
                        subTitle:
                            'Learn at your own pace with unlimited time and instant feedback',
                        features: const [
                          'Unlimited time',
                          'Instant feedback',
                          'Review answers',
                          'No pressure',
                        ],
                        buttonText: 'Start Practice',
                        // buttonColor: Colors.blue.shade700,
                        onPressed: () async {
                          state.subjectId != null && state.subjectId!.isNotEmpty
                              ? await context
                                    .pushNamed(
                                      AppRouter.quiz,
                                      extra: state.subjectId,
                                      pathParameters: {
                                        'mode': QuizMode.practice.name,
                                      },
                                    )
                                    .then((_) {
                                      quizCubit.selectSubject(state.subjectId);
                                    })
                              : MevTechUtilities.alertDialogBox(
                                  context: context,
                                  message:
                                      'Please select a subject to continue',
                                );
                        },
                      ),
                      SizedBox(height: 20.h),
                      QuizModeContainer(
                        showDuration: true,
                        buttonColor: AppColor.primary,
                        icon: const Icon(
                          Icons.track_changes,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: 'Test Mode',
                        subTitle:
                            'Simulate real exam conditions with time constraints and scoring',
                        features: const [
                          '30-minute timer',
                          'Final scoring',
                          'Exam simulation',
                          'Performance tracking',
                        ],
                        buttonText: 'Start Test',
                        // buttonColor: Colors.blue.shade700,
                        onPressed: () async {
                          state.subjectId != null && state.subjectId!.isNotEmpty
                              ? await context
                                    .pushNamed(
                                      AppRouter.quiz,
                                      extra: state.subjectId,
                                      pathParameters: {
                                        'mode': QuizMode.test.name,
                                      },
                                    )
                                    .then((_) {
                                      quizCubit.selectSubject(state.subjectId);
                                    })
                              : MevTechUtilities.alertDialogBox(
                                  context: context,
                                  message:
                                      'Please select a subject to continue',
                                );
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
