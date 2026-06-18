import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/course/course-widget/dropdown_btn.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/subscription_model.dart';
import 'package:mevtech/features/user/data/models/transaction_model.dart';
import 'package:mevtech/features/user/logic/subscription-cubit/subscription_cubit.dart';
import 'package:mevtech/injector.dart';

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
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final homeCubit = context.read<HomeCubit>();
    final subscriptionCubit = context.read<SubscriptionCubit>();
    final screenHeight = MediaQuery.sizeOf(context).height;

    final currentSubscription = authCubit.currentUser?.userSubscription;

    return FScaffold(
      // backgroundColor: Colors.grey.shade100,
      header: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Subscription/Billing',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
      ),
      child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) async {
          if (state is SubscriptionSuccess && state.status.isCreating) {
            MevTechUtilities.showProgressIndicator(context);
          } else {
            MevTechUtilities.hideProgressIndicator(context);

            if (state is SubscriptionSuccess && state.status.isCreateFailure) {
              MevTechUtilities.errorToast(
                context,
                state.status.error ?? 'An error occured',
              );
            }
            if (state is SubscriptionSuccess &&
                state.status.isCreateSuccess &&
                state.userPayment != null) {
              // context.pushNamed(AppRouter.payment,
              //     extra: state.userPayment!.paymentUrl);
              final paymentResult = await context.pushNamed<bool>(
                AppRouter.payment,
                extra: state.userPayment!.paymentUrl,
              );

              if (!context.mounted) return;

              if (paymentResult != null) {
                showResult(context: context, isSuccess: paymentResult);
                authCubit.updateUserSubscription(isSubscribed: paymentResult);
                if (context.canPop()) {
                  // context.pop(context);
                  context.goNamed(AppRouter.dashboard);
                  homeCubit.resetValue();
                }
              } else {
                showResult(context: context, isSuccess: false);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is SubscriptionSuccess && state.status.isFetching) {
            return Center(child: MevTechUtilities.customLoader());
          } else if (state is SubscriptionSuccess &&
              state.status.isFetchFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 3),
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

          return Column(
            crossAxisAlignment: .start,
            children: [
              // Container(height: 250, width: double.infinity, color: Colors.red),
              if (currentSubscription != null)
                Container(
                  padding: EdgeInsets.all(10.r),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),

                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100.withAlpha(30),
                    border: Border.all(color: Colors.blue.shade200, width: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Plan: ${currentSubscription.planName ?? 'Unknown'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                text: 'Email: ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: currentSubscription.userEmail,
                                    style: TextStyle(
                                      color: Colors.blueAccent.shade400,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              'Your plan expires on ${formatDate(currentSubscription.endDate)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Added on',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black87,
                            ),
                          ),

                          Text(
                            MevTechUtilities.formatDate(
                              currentSubscription.startDate,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          SizedBox(
                            height: 45.h,
                            child: FButton(
                              style: FButtonStyle.destructive(),
                              onPress: () {},
                              child: const Text('Unsubscribe'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 5.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  'Available Plans',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      plansContainer(
                        planTitle: 'Free',
                        amount: 'NGN 0',
                        amountText: ' NGN/month',
                        planDescription: 'Free educatonal plan',
                        screenHeight: screenHeight,
                        onPressed: null,
                        buttonText: 'Subscribed',
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        children: List.generate(state.plans.length, (index) {
                          final plan = state.plans[index];

                          final isCurrent = getCurrentPlan(
                            plan.id,
                            currentSubscription,
                          );

                          return plansContainer(
                            planTitle: plan.name,
                            amount: plan.price.toString(),
                            amountText: ' NGN/month',
                            validity: '${plan.durationInDays}Days',
                            planDescription: plan.description,
                            screenHeight: screenHeight,
                            isCurrent: isCurrent,
                            onPressed: () async {
                              await showFSheet<FSheets>(
                                context: context,
                                side: FLayout.btt,
                                builder: (context) => SubscriptionForm(
                                  side: FLayout.btt,
                                  onSubmit: (selectedProvider) {
                                    log(
                                      'Selected provider : $selectedProvider',
                                    );
                                    // subscriptionCubit.addSubscriptions(
                                    //   provider: selectedProvider,
                                    //   userId: MevTechUtilities.id,
                                    //   planId: plan.id,
                                    // );
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  // 'NGN 4,000', ' NGN/month', 'Premium educatonal plan',

  bool getCurrentPlan(String id, UserSubscription? subscription) {
    if (subscription != null && subscription.planId == id) {
      return true;
    }
    return false;
  }

  Widget plansContainer({
    required String planTitle,
    required String amount,
    required String amountText,
    required String planDescription,
    required double screenHeight,
    required void Function()? onPressed,
    String? validity,
    bool isCurrent = false,
    String buttonText = 'Get Started',
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
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
            child: SizedBox(
              height: 45.h,
              child: FButton(
                onPress: isCurrent ? null : onPressed,
                child: Text(isCurrent ? 'Current Plan' : buttonText),
              ),
            ),

            // ElevatedButton(
            //   onPressed: onPressed,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColor.primary,
            //     foregroundColor: Colors.white,
            //   ),
            //   child: Text(
            //     'Get Started',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 13.sp,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  String formatDate(String? date) {
    try {
      final period = DateTime.parse(date!);
      final result = DateFormat('MMMM dd, yyyy').format(period);
      return result;
    } catch (_) {
      return date ?? '000:00';
    }
  }

  void showResult({required BuildContext context, required bool isSuccess}) {
    if (!context.mounted) return;

    isSuccess
        ? MevTechUtilities.successToast(context, '✅ Payment was successful!')
        : MevTechUtilities.errorToast(
            context,
            '❌ Payment failed or was canceled.',
          );
  }

  // Future<void> startPayment(BuildContext context) async {
  //   final bool? paymentResult = await context.pushNamed<bool>(AppRouter.payment,
  //       extra: 'https://coinmarketcap.com');
  //   if (paymentResult != null) {
  //     showResult(context: context, isSuccess: paymentResult);
  //   } else {
  //     // Handle the case where the user simply pressed the back button.
  //     showResult(context: context, isSuccess: false);
  //   }
  // }

  dynamic confirmBottomSheet({
    required BuildContext context,
    required void Function()? onPressed,
  }) {
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
                    icon: const Icon(Icons.close),
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
                // StatefulBuilder(
                //   builder: (context, setState) {
                //     return MyDropdownButton(
                //       value: provider,
                //       items: providerList,
                //       onChanged: (newValue) {
                //         setState(() {
                //           provider = newValue ?? provider;
                //         });
                //       },
                //     );
                //   },
                // ),
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

class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({required this.side, super.key, this.onSubmit});
  final FLayout side;
  final void Function(String)? onSubmit;

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  String selectedProvider = 'Paystack';
  final providerList = ['Paystack', 'Flutterwave', 'Stripe'];

  @override
  Widget build(BuildContext context) => Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      color: context.theme.colors.background,
      border: widget.side.vertical
          ? Border.symmetric(
              horizontal: BorderSide(color: context.theme.colors.border),
            )
          : Border.symmetric(
              vertical: BorderSide(color: context.theme.colors.border),
            ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Subscription Payment',
            style: context.theme.typography.xl2.copyWith(
              fontWeight: FontWeight.w600,
              color: context.theme.colors.foreground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Make changes to your subscription plan here. Click confirm when you are done or cancel to go back.',
            style: context.theme.typography.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 40),

          Text(
            'Select Payment Provider',
            style: context.theme.typography.lg.copyWith(
              fontWeight: FontWeight.w500,
              color: context.theme.colors.foreground,
              height: 1,
            ),
          ),

          const SizedBox(height: 10),

          FSelect<String>.rich(
            control: .managed(
              initial: selectedProvider,

              onChange: (value) {
                selectedProvider = value ?? selectedProvider;
              },
            ),
            style: (style) => style.copyWith(
              selectFieldStyle: style.selectFieldStyle
                  .copyWith(
                    contentTextStyle: FWidgetStateMap({
                      WidgetState.any: context.theme.typography.xl,
                    }),
                  )
                  .call,
            ),
            hint: 'Select a provider',
            format: (s) => s,

            children: providerList
                .map(
                  (provider) => FSelectItem(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(provider, style: context.theme.typography.xl),
                    ),
                    value: provider,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: FButton(
                    style: FButtonStyle.destructive(),
                    onPress: () => Navigator.of(context).pop(),
                    child: Text(
                      'cancel',
                      style: context.theme.typography.xl.copyWith(
                        color: context.theme.colors.primaryForeground,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: FButton(
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onSubmit?.call(selectedProvider);
                    },
                    child: Text(
                      'Confirm',
                      style: context.theme.typography.xl.copyWith(
                        color: context.theme.colors.primaryForeground,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
