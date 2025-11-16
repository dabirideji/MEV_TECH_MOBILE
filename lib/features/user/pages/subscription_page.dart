import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/course/course-widget/dropdown_btn.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/logic/subscription-cubit/subscription_cubit.dart';
import 'package:template/injector.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubscriptionCubit>()..fetchSubscriptions(),
      child: const SubscriptionView(),
    );
  }
}

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  String provider = '';

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final subscriptionCubit = context.read<SubscriptionCubit>();
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Pricing',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) async {
          if (state is SubscriptionSuccess && state.status.isCreating) {
            MevTechUtilities.showProgressIndicator(context);
          } else {
            MevTechUtilities.hideProgressIndicator(context);

            if (state is SubscriptionSuccess && state.status.isCreateFailure) {
              MevTechUtilities.errorToast(
                  context, state.status.error ?? 'An error occured');
            }
            if (state is SubscriptionSuccess &&
                state.status.isCreateSuccess &&
                state.userPayment != null) {
              // context.pushNamed(AppRouter.payment,
              //     extra: state.userPayment!.paymentUrl);
              final paymentResult = await context.pushNamed<bool>(
                  AppRouter.payment,
                  extra: state.userPayment!.paymentUrl);

              if (!context.mounted) return;

              if (paymentResult != null) {
                showResult(context: context, isSuccess: paymentResult);
                authCubit.updateUserSubscription(isSubscribed: paymentResult);
                if (context.canPop()) context.pop(context);
              } else {
                showResult(context: context, isSuccess: false);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is SubscriptionSuccess && state.status.isFetching) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.secondary,
                backgroundColor: AppColor.primary,
              ),
            );
          } else if (state is SubscriptionSuccess &&
              state.status.isFetchFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Unable to Fetch Plans',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        IconButton(
                          onPressed: subscriptionCubit.fetchSubscriptions,
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColor.secondary,
                          ),
                        ),
                        Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                plansContainer(
                  planTitle: 'Free',
                  amount: 'NGN 0',
                  amountText: ' NGN/month',
                  planDescription: 'Free educatonal plan',
                  screenHeight: screenHeight,
                  onPressed: null,
                ),
                SizedBox(height: 10.h),
                Column(
                  children: List.generate(state.plans.length, (index) {
                    final plan = state.plans[index];
                    // const provider = 'Flutterwave';
                    return plansContainer(
                      planTitle: plan.name,
                      amount: plan.price.toString(),
                      amountText: ' NGN/month',
                      validity: '${plan.durationInDays}Days',
                      planDescription: plan.description,
                      screenHeight: screenHeight,
                      onPressed: () async {
                        confirmBottomSheet(
                          context: context,
                          onPressed: () {
                            context.pop();
                            subscriptionCubit.addSubscriptions(
                              provider: provider,
                              userId: MevTechUtilities.id,
                              planId: plan.id,
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  // 'NGN 4,000', ' NGN/month', 'Premium educatonal plan',

  Widget plansContainer({
    required String planTitle,
    required String amount,
    required String amountText,
    required String planDescription,
    required double screenHeight,
    required void Function()? onPressed,
    String? validity,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
      height: screenHeight * 0.4,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              text: amount,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
              children: [
                TextSpan(
                  text: ' $amountText',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          if (validity != null) SizedBox(height: 10.h),
          if (validity != null)
            Text(
              validity,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.black54,
              ),
            ),
          SizedBox(height: 10.h),
          Text(
            planDescription,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: Colors.black38,
            ),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showResult({required BuildContext context, required bool isSuccess}) {
    if (!context.mounted) return;

    isSuccess
        ? MevTechUtilities.successToast(context, '✅ Payment was successful!')
        : MevTechUtilities.errorToast(
            context, '❌ Payment failed or was canceled.');
  }

  Future<void> startPayment(BuildContext context) async {
    final bool? paymentResult = await context.pushNamed<bool>(AppRouter.payment,
        extra: 'https://coinmarketcap.com');
    if (paymentResult != null) {
      showResult(context: context, isSuccess: paymentResult);
    } else {
      // Handle the case where the user simply pressed the back button.
      showResult(context: context, isSuccess: false);
    }
  }

  dynamic confirmBottomSheet(
      {required BuildContext context, required void Function()? onPressed}) {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 100.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.w),
                  title: Text(
                    'Confirm Payment',
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  leading: const Text(''),
                  trailing: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Select Provider',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 7.h),
                StatefulBuilder(
                  builder: (context, setState) {
                    return MyDropdownButton(
                      value: provider,
                      items: const ['', 'Flutterwave', 'Paystack', 'Stripe'],
                      onChanged: (newValue) {
                        setState(() {
                          provider = newValue ?? '';
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 35.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: AppColor.secondary,
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.secondary,
                      ),
                      child: Container(
                        // height: 35.h,
                        // width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150.w, 35.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            // color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Container(
                        // height: 40.h,
                        // width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
