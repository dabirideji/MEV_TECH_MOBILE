import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:mevtech/features/quiz/logic/quiz_cubit.dart';
import 'package:mevtech/features/quiz/widget/question_card.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({
    required this.mode,
    super.key,
    this.selectedSubject,
    this.showReasonDialog = false,
  });

  final String? selectedSubject;
  final String mode;
  final bool showReasonDialog;

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  void initState() {
    super.initState();
    // Only show if the reason was passed
    if (widget.showReasonDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAutoSubmitDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final quizCubit = context.read<QuizCubit>();
    final quizState = context.read<QuizCubit>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Quiz Result',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: ResultCard(
        subject: widget.selectedSubject ?? 'Unknown',
        quizMode: widget.mode,
        questions: quizState.questions,
        selectedAnswersIndex: quizState.selectedAnswers,
        viewExplanation: (msg) {
          // showExplanation(context, msg);
          goToExplanation(context);
        },
        onTapFecthResult: (msg) async {
          try {
            final result = await context.read<QuizCubit>().fetchQuizExplanation(
              msg,
            );
            if (result != null) {
              return result;
            }
            return '';
          } catch (e) {
            if (!context.mounted) return '';
            MevTechUtilities.errorToast(context, e.toString());
            return '';
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 18.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    quizCubit.resetQuizResult();

                    context.goNamed(AppRouter.dashboard);
                    homeCubit.resetValue();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade400, width: 0.2),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.home_filled),
                  label: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // _showAutoSubmitDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200.w, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade400, width: 0.2),
                    ),
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    'Try Again',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAutoSubmitDialog() {
    showFDialog<dynamic>(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: (style) => style.copyWith(
          horizontalStyle: (style) =>
              style.copyWith(bodyTextStyle: TextStyle(fontSize: 13.sp)),
        ),
        animation: animation,

        direction: Axis.horizontal,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
            child: Icon(FIcons.circleX, size: 50.sp, color: Colors.redAccent),
          ),
        ),

        body: Column(
          mainAxisSize: .min,
          children: [
            Text(
              'Quiz Submitted',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 15.h),

            // RichText(text: text)
            const Text(
              'Your quiz was auto-submitted because you switched tabs or '
              'left the app, which is not allowed in TEST MODE',
            ),
          ],
        ),
        actions: [
          Center(
            child: FButton(
              style: FButtonStyle.destructive(),
              child: Text(
                'Ok',
                style: TextStyle(fontWeight: .bold, fontSize: 13.sp),
              ),
              onPress: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  // Get.to(() => SalesEditView(),
  dynamic goToExplanation(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute<dynamic>(
    //     builder: (_) => const ExplanationCard(),
    //     fullscreenDialog: true,
    //   ),
    // );

    Navigator.of(context).push(
      PageRouteBuilder<dynamic>(
        barrierDismissible: true,
        opaque: false, // Prevents the previous screen from being disposed
        fullscreenDialog: true, // Replicates the dialog behavior
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, _, __) => const ExplanationCard(),
      ),
    );
  }

  Future<dynamic> showExplanation(BuildContext context, String message) async {
    return showDialog<dynamic>(
      context: context,
      builder: (ctx) {
        // return const ExplanationCard();

        return StatefulBuilder(
          builder: (ctx, setState) {
            return FutureBuilder(
              future: context.read<QuizCubit>().fetchQuizExplanation(message),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  // 2. *** This is how you handle failure ***
                  if (snapshot.hasError) {
                    // Display an error message or a retry button
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          // Use snapshot.error to display the specific error
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                          // You might add a button here to re-trigger the future
                        ],
                      ),
                    );
                  }
                  // 3. Handle success (if not an error and connectionState is done)
                  return AnimatedAlertDialog(
                    title: 'Explanation',
                    message: snapshot.data ?? 'Unable to fetch Explanation',
                    cancelText: '',
                    confirmText: 'Close',
                    onCancel: () {},
                    onConfirm: () {
                      Navigator.of(context).pop();
                    },
                    showCancelButton: false,
                  ); // Display the successfully loaded data
                }
                return Container();
              },
            );
          },
        );
      },
    );
  }
}

class ExplanationCard extends StatefulWidget {
  const ExplanationCard({super.key});

  @override
  State<ExplanationCard> createState() => _ExplanationCardState();
}

class _ExplanationCardState extends State<ExplanationCard> {
  bool _isLoading = false;
  String? _error;
  String? message;

  Future<void> fetch() async {
    try {
      setState(() {
        _isLoading = true;
      });
      message = await context.read<QuizCubit>().fetchMockExplanation(
        'I am who i says i am, so get that staright',
      );
      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void initState() {
    _isLoading = false;
    _error = null;
    message = null;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(),
      body: Builder(
        builder: (cxt) {
          if (_isLoading) {
            return Center(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          } else if (_error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: <Widget>[
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  // Use snapshot.error to display the specific error
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $_error'),
                  ),
                  // You might add a button here to re-trigger the future
                ],
              ),
            );
          }
          // return AnimatedAlertDialog(
          //   title: 'Explanation',
          //   message: message ?? 'Unable to fetch Explanation',
          //   cancelText: '',
          //   confirmText: 'Close',
          //   onCancel: () {},
          //   onConfirm: () {
          //     Navigator.of(context).pop();
          //   },
          //   showCancelButton: false,
          // ); // Disp

          return Center(
            child: Container(
              // width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                // mainAxisSize: .min,
                mainAxisAlignment: .center,
                children: [
                  const Text('Explanation'),
                  const SizedBox(height: 20),
                  Text(message ?? 'Unable to fetch Explanation'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
