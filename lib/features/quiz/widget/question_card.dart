import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/course-widget/dropdown_btn.dart';
import 'package:template/features/quiz/data/models/question_model.dart';
import 'package:template/features/quiz/widget/html_text.dart';

class QuizQuestionCard extends StatefulWidget {
  const QuizQuestionCard({
    // required this.currentQuizIndex,
    required this.question,
    required this.options,
    required this.onOptionSelected,
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
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'CBT Quiz - ${widget.subject} \n(${widget.quizMode})',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                const Divider(thickness: 0.4),
                SizedBox(height: 5.h),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  value: widget.progress,
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(5),
                  minHeight: 10.h,
                ),
                SizedBox(height: 7.h),
                Text(
                  widget.questionRemaining,
                  style: TextStyle(
                    fontSize: 13.sp,
                    // fontWeight: FontWeight.w600,
                  ),
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
                    color: Colors.grey.shade50,
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
                          final label =
                              String.fromCharCode(65 + index); // 65 = 'A'

                          // alpha.add(label);
                          // log(alpha.first);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.white,
                              ),
                              child: RadioListTile<int>(
                                splashRadius: 0,
                                contentPadding: EdgeInsets.zero,
                                visualDensity:
                                    const VisualDensity(horizontal: -4),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    required this.questions,
    required this.selectedAnswersIndex,
    super.key,
    this.subject = 'Unknown',
    this.viewExplanation,
    this.onPressed,
    this.quizMode = '',
  });

  final List<QuestionModel> questions;
  final List<int?> selectedAnswersIndex;
  final VoidCallback? viewExplanation;
  final void Function()? onPressed;
  final String subject;
  final String quizMode;

  @override
  Widget build(BuildContext context) {
    final summaryCorrectAnswers =
        summaryCorrectAnwerCount(selectedAnswersIndex, questions);

    return SafeArea(
      child: Container(
        height: double.maxFinite,
        margin: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
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
                    'CBT Quiz - $subject \n($quizMode)',
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
                    side: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade300,
                    ),
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
                              '${questions.length}',
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
                                '$summaryCorrectAnswers out of ${questions.length.toString()}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
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
                            Text(
                              '${((summaryCorrectAnswers / questions.length) * 100).round()}%',
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
                                  horizontal: 12.w, vertical: 4.4),
                              decoration: BoxDecoration(
                                color: summaryCorrectAnswers >=
                                        (questions.length * 0.6)
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                summaryCorrectAnswers >=
                                        (questions.length * 0.6)
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
                    child: Column(
                      children: List.generate(questions.length, (index) {
                        final option = questions[index].option;
                        final section = questions[index].section;

                        final selectedAlphabetAnswer = String.fromCharCode(
                          65 +
                              (selectedAnswersIndex[index] != null
                                  ? selectedAnswersIndex[index]!
                                  : 10),
                        );
                        final question = questions[index].question;
                        final alphabetAnswer =
                            questions[index].answer.toUpperCase();

                        final answer = correctAnswer(
                            option: option, alphabetAnswer: alphabetAnswer);
                        final selectedAnswer = userAnswer(
                            option: option,
                            selectedAlphabetAnswer: selectedAlphabetAnswer);

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
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(7.r),
                                      child: HtmlText(
                                        section,
                                        fontSize: 13.sp,
                                      ),
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
                                    height: question.isNotEmpty ? 10.h : 0),

                                RichText(
                                  text: TextSpan(
                                    text: 'Your Answer: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: isValidAlphabet(
                                                selectedAlphabetAnswer)
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
                                        text: selectedAlphabetAnswer ==
                                                alphabetAnswer
                                            ? '  ✅'
                                            : '  ❌',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: selectedAlphabetAnswer ==
                                                alphabetAnswer
                                            ? 'Correct'
                                            : 'Incorrect',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: selectedAlphabetAnswer ==
                                                  alphabetAnswer
                                              ? Colors.green.shade700
                                              : Colors.red,
                                        ),
                                      )
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
                                SizedBox(height: 15.h),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                  ),
                                  child: Text(
                                    '💡 See Explanation',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.blueAccent.shade700,
                                    ),
                                  ),
                                ),

                                const Divider(thickness: 0.6),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onPressed,
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
                    'Go back to dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 13.sp,
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
    final answer =
        intAnswer >= 0 && intAnswer < options.length ? options[intAnswer] : '';

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
    final answer =
        intAnswer >= 0 && intAnswer < options.length ? options[intAnswer] : '';

    return answer;
  }

  int summaryCorrectAnwerCount(
      List<int?> selectedAnswersIndex, List<QuestionModel> questions) {
    // final opt = ['A', 'B', 'C', 'D', 'E'];
    var correctAnswers = 0;
    final alphabetAnswers =
        questions.map((question) => question.answer.toUpperCase()).toList();

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
