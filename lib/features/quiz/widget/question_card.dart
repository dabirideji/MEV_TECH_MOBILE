import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/core/extensions/string_extension.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/quiz/data/models/question_model.dart';
import 'package:mevtech/features/quiz/logic/quiz_cubit.dart';
import 'package:mevtech/features/quiz/widget/html_text.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

class QuizQuestionCard extends StatefulWidget {
  const QuizQuestionCard({
    // required this.currentQuizIndex,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    required this.startTme,
    this.onNextPressed,
    super.key,
    this.onPreviousPressed,
    this.initialSelected,
    this.subjects = const [],
    this.onSubjectChanged,
    this.initialSubject,
    this.progress = 0.0,
    this.questionRemaining = '',
    this.questionSection = '',
    this.isLast = false,
    this.subject = 'Unknown',
    this.quizMode = '',
    this.totalQuestion = 0,
    this.questionCompleted = 0,
  });

  final String question;
  final List<String> options;
  final void Function(int) onOptionSelected;
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed;
  final int? initialSelected;
  final List<String> subjects;
  final void Function(String?)? onSubjectChanged;
  final String? initialSubject;
  final double progress;
  final String questionRemaining;
  final String questionSection;
  final bool isLast;
  final String subject;
  final String quizMode;
  final ValueNotifier<int> startTme;
  final int totalQuestion;
  final int questionCompleted;

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialSelected;
  }

  @override
  void didUpdateWidget(covariant QuizQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      // Reset selection when new question comes in
      selectedOption = widget.initialSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.maxFinite,
        margin: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MevTech Quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '${widget.subject} - ${widget.quizMode.capitalize()} Mode',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ],
                    ),
                    if (widget.quizMode == QuizMode.test.name)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.greenAccent.shade700,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: ValueListenableBuilder<int>(
                            valueListenable: widget.startTme,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  Text(
                                    'Time Remaining',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: value < 180
                                          ? Colors.red
                                          : Colors.green.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: value < 180
                                            ? Colors.red
                                            : Colors.green.shade800,
                                      ),
                                      SizedBox(width: 7.w),
                                      Text(
                                        textAlign: TextAlign.center,
                                        formatCountDownTime(value),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: value < 180
                                              ? Colors.red
                                              : Colors.green.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 5.h),
                const Divider(thickness: 0.4),
                SizedBox(height: 5.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.questionRemaining,
                      style: TextStyle(
                        fontSize: 13.sp,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.totalQuestion > 0)
                      Text(
                        completionPercent(
                          widget.questionCompleted,
                          widget.totalQuestion,
                        ),
                        style: TextStyle(
                          fontSize: 13.sp,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 7.h),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  value: widget.progress,
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(5),
                  minHeight: 8.h,
                ),

                SizedBox(height: 10.h),
                if (widget.questionSection.isNotEmpty)
                  Text(
                    'Section:',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                // SizedBox(height: widget.questionSection.isNotEmpty ? 3.h : 0),
                if (widget.questionSection.isNotEmpty)
                  Card(
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(7.r),
                      child: HtmlText(widget.questionSection),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // SizedBox(height: 5.h),
                // CustomDropdownButton(
                //   hintText: 'Select Subject',
                //   initialValue: widget.initialSubject,
                //   items: widget.subjects,
                //   onChanged: widget.onSubjectChanged,
                // ),
                // SizedBox(height: 10.h),
                Card(
                  shadowColor: Colors.grey.shade100,
                  elevation: 0.01,
                  color: Colors.grey.shade50,
                  margin: EdgeInsets.all(10.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        if (widget.question.trim().isNotEmpty)
                          HtmlText(widget.question)
                        else
                          const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        ...List.generate(widget.options.length, (index) {
                          final optionText = widget.options[index];
                          final label = String.fromCharCode(
                            65 + index,
                          ); // 65 = 'A'

                          // alpha.add(label);
                          // log(alpha.first);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: Theme(
                              data: ThemeData(splashColor: Colors.white),
                              child: RadioListTile<int>(
                                splashRadius: 0,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                ),
                                activeColor: AppColor.primary,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$label:   ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        // textAlign: TextAlign.center,
                                        optionText,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                value: index,
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                  if (value != null) {
                                    widget.onOptionSelected(value);
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            // if (widget.onPreviousPressed != null)
                            ElevatedButton(
                              onPressed: widget.onPreviousPressed,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 0.2,
                                  ),
                                ),
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black87,
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: widget.onNextPressed,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 0.2,
                                  ),
                                ),
                                backgroundColor: AppColor.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                widget.isLast ? 'Submit' : ' Next ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatCountDownTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60; // Integer division
    final seconds = totalSeconds % 60; // Remainder

    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');

    return '$minStr:$secStr';
  }

  String completionPercent(int completed, int total) {
    if (total == 0) return '0% complete'; // avoid division by zero

    final percent = (completed / total) * 100;

    // Round to whole numbers (3%, 4%, etc)
    final rounded = percent.toStringAsFixed(0);

    return '$rounded% complete';
  }
}

class ResultCard extends StatefulWidget {
  const ResultCard({
    required this.questions,
    required this.selectedAnswersIndex,
    required this.onTapFecthResult,
    super.key,
    this.subject = 'Unknown',
    this.viewExplanation,
    this.quizMode = '',
  });

  final List<QuestionModel> questions;
  final List<int?> selectedAnswersIndex;
  final void Function(String)? viewExplanation;
  final String subject;
  final String quizMode;
  final Future<String> Function(String) onTapFecthResult;

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  List<String> returnedExplanations = [];

  Future<void> fetchExplanation() async {}

  @override
  void initState() {
    super.initState();
    returnedExplanations = List.filled(widget.questions.length, '');
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final summaryCorrectAnswers = summaryCorrectAnwerCount(
      widget.selectedAnswersIndex,
      widget.questions,
    );

    return SafeArea(
      child: Container(
        height: double.maxFinite,
        margin: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Mevtech Quiz - ${widget.subject} \n(${widget.quizMode.capitalize()})',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(thickness: 0.4),
                SizedBox(height: 5.h),
                Text(
                  'Quiz Result',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.grey.shade100,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 0.5, color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Question :',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '${widget.questions.length}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        // Correct Answers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Correct Answers:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '$summaryCorrectAnswers',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Score:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '$summaryCorrectAnswers out of ${widget.questions.length}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Percentage
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Percentage:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            if (summaryCorrectAnswers > 0)
                              Text(
                                '${((summaryCorrectAnswers / widget.questions.length) * 100).round()}%',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )
                            else
                              Text(
                                '0%',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Pass/Fail
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    summaryCorrectAnswers >=
                                        (widget.questions.length * 0.6)
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                summaryCorrectAnswers >=
                                        (widget.questions.length * 0.6)
                                    ? 'Pass'
                                    : 'Needs Improvement',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Card(
                  shadowColor: Colors.grey.shade100,
                  elevation: 0.03,
                  color: Colors.grey.shade50,
                  // margin: EdgeInsets.all(5.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.questions.length,
                      itemBuilder: (context, index) {
                        final option = widget.questions[index].option;
                        final section = widget.questions[index].section;

                        final selectedAlphabetAnswer = String.fromCharCode(
                          65 +
                              (widget.selectedAnswersIndex[index] != null
                                  ? widget.selectedAnswersIndex[index]!
                                  : 10),
                        );
                        final question = widget.questions[index].question;
                        final alphabetAnswer = widget.questions[index].answer
                            .toUpperCase();

                        final answer = correctAnswer(
                          option: option,
                          alphabetAnswer: alphabetAnswer,
                        );
                        final selectedAnswer = userAnswer(
                          option: option,
                          selectedAlphabetAnswer: selectedAlphabetAnswer,
                        );

                        final itemKey = ValueKey('result_$index');

                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: ShapeDecoration(
                            shape: NonUniformBorder(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedAlphabetAnswer == alphabetAnswer
                                  ? Colors.green.shade500
                                  : Colors.red,
                              topWidth: 0,
                              bottomWidth: 0,
                              leftWidth: 1.5,
                              rightWidth: 0,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            // margin: EdgeInsets.only(bottom: 10.h),
                            decoration: ShapeDecoration(
                              shape: NonUniformBorder(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black12,
                                topWidth: 0.5,
                                bottomWidth: 2.5,
                                leftWidth: 0.7,
                                rightWidth: 0.7,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (section.isNotEmpty)
                                  Text(
                                    'Section:',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                // SizedBox(height: widget.questionSection.isNotEmpty ? 3.h : 0),
                                if (section.isNotEmpty)
                                  Card(
                                    color: Colors.blue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(7.r),
                                      child: HtmlText(section, fontSize: 13.sp),
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),
                                SizedBox(height: 15.h),
                                if (question.isNotEmpty)
                                  HtmlText(
                                    question,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  )
                                else
                                  const SizedBox.shrink(),
                                SizedBox(
                                  height: question.isNotEmpty ? 10.h : 0,
                                ),

                                RichText(
                                  text: TextSpan(
                                    text: 'Your Answer: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            isValidAlphabet(
                                              selectedAlphabetAnswer,
                                            )
                                            ? '$selectedAlphabetAnswer - '
                                            : 'NIL',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: selectedAnswer,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            selectedAlphabetAnswer ==
                                                alphabetAnswer
                                            ? '  ✅'
                                            : '  ❌',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            selectedAlphabetAnswer ==
                                                alphabetAnswer
                                            ? 'Correct'
                                            : 'Incorrect',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              selectedAlphabetAnswer ==
                                                  alphabetAnswer
                                              ? Colors.green.shade700
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                RichText(
                                  text: TextSpan(
                                    text: 'Correct Answer: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$alphabetAnswer - ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: answer,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                if (widget.quizMode == QuizMode.practice.name)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: ExpalantionWidget(
                                      message: messageQuery(
                                        question: widget.questions[index],
                                        selectedAnswer: selectedAnswer,
                                        correctAnswer: answer,
                                      ),
                                      onTapFecthResult: widget.onTapFecthResult,
                                    ),
                                  ),

                                // const Divider(thickness: 0.6),

                                // FAccordion(
                                //   // key: itemKey,
                                //   control: FAccordionControl.managed(
                                //     onChange: (value) {
                                //       log(value.toString());
                                //       // setState(() {
                                //       //   _initiallyExpanded[index] =
                                //       //       !_initiallyExpanded[index];
                                //       // });
                                //     },
                                //   ),
                                //   children: const [
                                //     FAccordionItem(
                                //       title: Text('Production Information'),
                                //       child: Text('This is is a Test'),
                                //       // SizedBox.shrink(),
                                //     ),
                                //   ],
                                // ),
                                // TextButton(
                                //   onPressed: () =>
                                //       widget.viewExplanation?.call(answer),
                                //   style: TextButton.styleFrom(
                                //     visualDensity: const VisualDensity(
                                //       horizontal: -4,
                                //       vertical: -4,
                                //     ),
                                //   ),
                                //   child: Text(
                                //     '💡 See Explanation',
                                //     style: TextStyle(
                                //       fontSize: 13.sp,
                                //       color: Colors.blueAccent.shade700,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String messageQuery({
    required QuestionModel question,
    required String selectedAnswer,
    required String correctAnswer,
  }) {
    var message = '';
    if (question.section.isEmpty) {
      message =
          'This is a Quiz exercise where the user is asked to pick a question\n'
          'This is the question: ${question.question}.\n'
          'These are the answers: ${question.option.a},${question.option.b},${question.option.c},${question.option.d}.\n'
          'This is the correct answer: $correctAnswer.\n'
          'This is what the user choose: $selectedAnswer\n'
          'pls explain why the answer is correct and why other answers are wrong '
          'and also give tips on how to get this and know this better '
          'and for better clearance for the user next time. and dont make it too long, '
          'just summarize the whole thing thank you';
    } else {
      message =
          'This is a Quiz exercise where the user is asked to pick a question\n'
          'This is the section which has the instructions : ${question.section}.\n'
          'This is the question: ${question.question}.\n'
          'These are the answers: ${question.option.a},${question.option.b},${question.option.c},${question.option.d}.\n'
          'This is the correct answer: $correctAnswer.\n'
          'This is what the user choose: $selectedAnswer\n'
          'pls explain why the answer is correct and why other answers are wrong '
          'and also give tips on how to get this and know this better '
          'and for better clearance for the user next time. and dont make it too long, '
          'just summarize the whole thing thank you';
    }

    return message;
  }

  String correctAnswer({
    required OptionModel option,
    required String alphabetAnswer,
  }) {
    final opt = ['A', 'B', 'C', 'D', 'E'];

    final options = <String>[
      option.a,
      option.b,
      option.c,
      option.d,
      option.e ?? '',
    ].where((o) => o.trim().isNotEmpty).toSet().toList();

    // final quizOptions =
    //               options.where((o) => o.trim().isNotEmpty).toSet().toList();

    final intAnswer = opt.indexOf(alphabetAnswer.toUpperCase());
    final answer = intAnswer >= 0 && intAnswer < options.length
        ? options[intAnswer]
        : '';

    return answer;
  }

  String userAnswer({
    required OptionModel option,
    required String selectedAlphabetAnswer,
  }) {
    final opt = ['A', 'B', 'C', 'D', 'E'];

    final options = <String>[
      option.a,
      option.b,
      option.c,
      option.d,
      option.e ?? '',
    ].where((o) => o.trim().isNotEmpty).toSet().toList();

    final intAnswer = opt.indexOf(selectedAlphabetAnswer.toUpperCase());
    final answer = intAnswer >= 0 && intAnswer < options.length
        ? options[intAnswer]
        : '';

    return answer;
  }

  int summaryCorrectAnwerCount(
    List<int?> selectedAnswersIndex,
    List<QuestionModel> questions,
  ) {
    // final opt = ['A', 'B', 'C', 'D', 'E'];
    var correctAnswers = 0;
    final alphabetAnswers = questions
        .map((question) => question.answer.toUpperCase())
        .toList();

    final selectedAlphabetAnswers = selectedAnswersIndex
        // .whereType<int>() // Filters out any null values
        .map((index) => String.fromCharCode(65 + (index ?? 10)))
        .toList();

    // final selectedAlphabetAnswers = <String>[];

    // for (final index in selectedAnswersIndex) {
    //   if (index != null) {
    //     selectedAlphabetAnswers.add(String.fromCharCode(65 + index));
    //   }
    // }

    for (var i = 0; i < alphabetAnswers.length; i++) {
      if (selectedAlphabetAnswers.isNotEmpty &&
          selectedAlphabetAnswers[i] == alphabetAnswers[i]) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  bool isValidAlphabet(String value) {
    final opt = ['A', 'B', 'C', 'D', 'E'];
    return opt.contains(value);
  }
}

class ExpalantionWidget extends StatefulWidget {
  const ExpalantionWidget({
    required this.message,
    required this.onTapFecthResult,
    super.key,
  });

  final String message;
  final Future<String> Function(String) onTapFecthResult;
  // final void Function(String)? onPressed;

  @override
  State<ExpalantionWidget> createState() => _ExpalantionWidgetState();
}

class _ExpalantionWidgetState extends State<ExpalantionWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String title = '';

  Future<void> toggle(FPopoverController controller) async {
    try {
      if (title.isNotEmpty) {
        await controller.toggle();
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final data = await widget.onTapFecthResult(widget.message);

      setState(() {
        _isLoading = false;
      });

      if (data.isNotEmpty) {
        setState(() {
          title = data;
        });

        await controller.toggle();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return FPopover(
      popoverAnchor: Alignment.topCenter,
      childAnchor: Alignment.bottomCenter,
      constraints: FPortalConstraints(
        maxHeight: screenHeight * 0.45,
        maxWidth: screenWidth * 0.9,
      ),
      popoverBuilder: (context, _) {
        if (title.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 14.h,
              right: 20.w,
              bottom: 10.h,
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),
                    Text(title, style: GoogleFonts.inter(fontWeight: .w500)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      // => SizedBox.shrink(),
      builder: (_, controller, _) => FButton(
        style: FButtonStyle.outline(),
        mainAxisSize: MainAxisSize.min,
        onPress: () {
          toggle(controller);
        },

        child: Text(_isLoading ? 'Loading Explanation' : 'See Explanation'),
      ),
    );
  }
}
