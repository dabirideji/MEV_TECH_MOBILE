import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/dropdown_btn.dart';
import 'package:template/features/home/home_cubit.dart';
import 'package:template/features/quiz/logic/quiz_cubit.dart';
import 'package:template/features/quiz/pages/quiz_mode.dart';
import 'package:template/features/quiz/widget/question_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({required this.mode, super.key, this.selectedSubject});

  final String? selectedSubject;
  final String mode;

  // List<List<String>> quizOptions = [
  //   options,
  //   anotherOptions,
  //   furtherOptions,
  //   continueOptions,
  //   lastOptions
  // ];

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<QuizCubit>()
        .fetchQuizQuestions(widget.selectedSubject ?? 'english');
  }

  static int currentQuizIndex = 0;

  int progressIndex(int index) {
    if (index == 0) return 1;
    return index + 1;
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    final screenHeight = MediaQuery.sizeOf(context).height;
    final quizState = context.watch<QuizCubit>().state;
    final quizCubit = context.read<QuizCubit>();

    final isIndexWithinRange =
        currentQuizIndex < quizState.questions.length - 1;
    final isLast = currentQuizIndex == quizState.questions.length - 1;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        currentQuizIndex = 0;
        quizCubit.resetQuizResult();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Mevtech Test System',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state.resultState == ResultState.success) {
              return ResultCard(
                subject: widget.selectedSubject ?? 'Unknown',
                quizMode: widget.mode,
                questions: state.questions,
                selectedAnswersIndex: state.selectedAnswers,
                viewExplanation: () {},
                onPressed: () {
                  currentQuizIndex = 0;
                  quizCubit.resetQuizResult();
                  homeCubit.resetValue();
                  // context.goNamed(AppRouter.dashboard);
                },
              );
            }

            if (state.questionStatus.isLoading) {
              return SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15.r),
                  padding: EdgeInsets.all(50.r),
                  width: double.maxFinite,
                  height: screenHeight * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'CBT Quiz - ${widget.selectedSubject ?? 'Unknown'}\n(${widget.mode})',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.grey,
                          backgroundColor: AppColor.primary,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      const Text(
                        'Loading questions...',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state.questionStatus.isSuccess) {
              final option = state.questions[currentQuizIndex].option;
              final options = <String>[
                option.a,
                option.b,
                option.c,
                option.d,
                option.e ?? '',
              ];

              final quizOptions =
                  options.where((o) => o.trim().isNotEmpty).toSet().toList();

              final selectedValue = (currentQuizIndex >= 0 &&
                      currentQuizIndex < state.selectedAnswers.length)
                  ? state.selectedAnswers[currentQuizIndex]
                  : null;

              return QuizQuestionCard(
                progress:
                    progressIndex(currentQuizIndex) / state.questions.length,
                questionRemaining:
                    'Question ${progressIndex(currentQuizIndex)} of ${state.questions.length}',
                subject: widget.selectedSubject ?? 'Unknown',
                quizMode: widget.mode,
                initialSelected: selectedValue,
                questionSection: state.questions[currentQuizIndex].section,
                question: state.questions[currentQuizIndex].question,
                options: quizOptions,
                onOptionSelected: (index) {
                  // log(index.toString());
                  // selectedAnswers[currentQuizIndex] = index;
                  quizCubit.selectAnswer(currentQuizIndex, index);
                },
                isLast: isLast,
                onNextPressed: isLast
                    ? quizCubit.fetchQuizResult
                    : isIndexWithinRange
                        ? () {
                            setState(() {
                              currentQuizIndex++;
                            });
                          }
                        : null,
                onPreviousPressed: currentQuizIndex > 0
                    ? () {
                        setState(() {
                          currentQuizIndex--;
                        });
                      }
                    : null,

                // initialSubject: state.subjectId,
                // subjects: quizState.subjects,
                // onSubjectChanged: quizCubit.selectSubject,
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Unable to Fetch Quiz Questions',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<QuizCubit>().fetchQuizQuestions(
                                widget.selectedSubject ?? 'english');
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColor.primary,
                            size: 28,
                          ),
                          label: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,

                              // color: Colors.black54,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20.r),
                            backgroundColor: Colors.white,
                            foregroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                width: 0.5,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          state.questionStatus.error ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
