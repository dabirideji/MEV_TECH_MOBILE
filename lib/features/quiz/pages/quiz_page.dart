import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/extensions/string_extension.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/course/course-widget/dropdown_btn.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:mevtech/features/quiz/logic/quiz_cubit.dart';
import 'package:mevtech/features/quiz/pages/quiz_mode.dart';
import 'package:mevtech/features/quiz/widget/question_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({required this.mode, super.key, this.selectedSubject});

  final String? selectedSubject;
  final String mode;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    currentQuizIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizCubit>().fetchQuizQuestions(
        widget.selectedSubject ?? 'English',
      );
      context.read<QuizCubit>().resetQuizResult();
    });
  }

  @override
  void dispose() {
    startTme.dispose();
    _timer?.cancel();
    super.dispose();
  }

  static int currentQuizIndex = 0;

  Timer? _timer;
  final startTme = ValueNotifier<int>(0);

  int progressIndex(int index) {
    if (index == 0) return 1;
    return index + 1;
  }

  void resetTimerValues() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
      startTme.value = 0;
    }
  }

  void startCoundown(QuizCubit quizCubit, int value) {
    if (_timer?.isActive ?? false) return;
    startTimer(quizCubit, value);
  }

  void startTimer(QuizCubit quizCubit, int value) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }

    startTme.value = value;
    // timeRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (startTme.value < 1) {
        timer.cancel();
        quizCubit.fetchQuizResult();
      } else {
        startTme.value -= 1;
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resumeTimer(QuizCubit quizCubit, int value) {
    if (value > 0) {
      startTimer(quizCubit, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final quizState = context.watch<QuizCubit>().state;
    final quizCubit = context.read<QuizCubit>();

    final isIndexWithinRange =
        currentQuizIndex < quizState.questions.length - 1;
    final isLast = currentQuizIndex == quizState.questions.length - 1;

    if (widget.mode == QuizMode.test.name) {
      return FocusDetector(
        onForegroundLost: () {
          // log('Foreground Lost');
          _timer?.cancel();
        },
        onForegroundGained: () {
          // log('Foreground Gained');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (quizState.questionStatus.isSuccess) {
              context.pushReplacementNamed(
                AppRouter.quizResult,
                queryParameters: {'auto_submit': 'true'},
                extra: widget.selectedSubject,
                pathParameters: {'mode': widget.mode},
              );
            }
          });
        },
        child: PopScope(
          canPop: !quizState.questionStatus.isSuccess,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            _pauseTimer();

            final shouldPop = await showExitAlert(context) ?? false;
            if (context.mounted && shouldPop) {
              context.pushReplacementNamed(
                AppRouter.quizResult,
                extra: widget.selectedSubject,
                pathParameters: {'mode': widget.mode},
              );
            } else if (!shouldPop) {
              _resumeTimer(quizCubit, startTme.value);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Mevtech Test System',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
              ),
            ),
            body: BlocConsumer<QuizCubit, QuizState>(
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) {
                if (state.resultState == ResultState.success &&
                    state.questionStatus.isSuccess) {
                  context.pushReplacementNamed(
                    AppRouter.quizResult,
                    extra: widget.selectedSubject,
                    pathParameters: {'mode': widget.mode},
                  );
                }
              },
              builder: (context, state) {
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
                            'MevTech Quiz - ${widget.selectedSubject ?? 'Unknown'}\n(${widget.mode.toUpperCase()} MODE)',
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

                  final quizOptions = options
                      .where((o) => o.trim().isNotEmpty)
                      .toSet()
                      .toList();

                  final selectedValue =
                      (currentQuizIndex >= 0 &&
                          currentQuizIndex < state.selectedAnswers.length)
                      ? state.selectedAnswers[currentQuizIndex]
                      : null;

                  startCoundown(quizCubit, 1800);

                  return QuizQuestionCard(
                    startTme: startTme,
                    progress:
                        progressIndex(currentQuizIndex) /
                        state.questions.length,
                    questionRemaining:
                        'Question ${progressIndex(currentQuizIndex)} of ${state.questions.length}',
                    subject: widget.selectedSubject ?? 'Unknown',
                    quizMode: widget.mode,
                    initialSelected: selectedValue,
                    questionSection: state.questions[currentQuizIndex].section,
                    question: state.questions[currentQuizIndex].question,
                    options: quizOptions,
                    totalQuestion: state.questions.length,
                    questionCompleted: currentQuizIndex,
                    onOptionSelected: (index) {
                      quizCubit.selectAnswer(currentQuizIndex, index);
                    },
                    isLast: isLast,
                    onNextPressed: isLast
                        ? () {
                            quizCubit.fetchQuizResult();
                            resetTimerValues();
                          }
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
                                  widget.selectedSubject ?? 'english',
                                );
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
        ),
      );
    } else {
      return PopScope(
        canPop: !quizState.questionStatus.isSuccess,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldPop = await showExitAlert(context) ?? false;
          if (context.mounted && shouldPop) {
            context.pushReplacementNamed(
              AppRouter.quizResult,
              extra: widget.selectedSubject,
              pathParameters: {'mode': widget.mode},
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Mevtech Test System',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
            ),
          ),
          body: BlocConsumer<QuizCubit, QuizState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state.resultState == ResultState.success &&
                  state.questionStatus.isSuccess) {
                context.pushReplacementNamed(
                  AppRouter.quizResult,
                  extra: widget.selectedSubject,
                  pathParameters: {'mode': widget.mode},
                );
              }
            },
            builder: (context, state) {
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
                          'MevTech Quiz - ${widget.selectedSubject ?? 'Unknown'}\n(${widget.mode.toUpperCase()} MODE)',
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

                final quizOptions = options
                    .where((o) => o.trim().isNotEmpty)
                    .toSet()
                    .toList();

                final selectedValue =
                    (currentQuizIndex >= 0 &&
                        currentQuizIndex < state.selectedAnswers.length)
                    ? state.selectedAnswers[currentQuizIndex]
                    : null;

                return QuizQuestionCard(
                  startTme: startTme,
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
                    quizCubit.selectAnswer(currentQuizIndex, index);
                  },
                  isLast: isLast,
                  onNextPressed: isLast
                      ? () {
                          quizCubit.fetchQuizResult();
                          resetTimerValues();
                        }
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
                                widget.selectedSubject ?? 'english',
                              );
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

  Future<bool?> showExitAlert(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedAlertDialog(
          title: 'Confirm Exit',
          message: 'Are you sure you want to exit and submit?',
          cancelText: 'No',
          confirmText: 'Yes',
          onCancel: () {
            Navigator.of(context).pop(false);
          },
          onConfirm: () {
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }
}
