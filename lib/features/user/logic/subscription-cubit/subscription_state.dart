part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.plans = const [],
    this.status = const Status.initial(),
    this.message = '',
    this.userPayment,
  });

  final List<Plans> plans;
  final Status status;
  final String message;
  final UserPayment? userPayment;

  @override
  List<Object?> get props => [plans, status, message, userPayment];
}

final class SubscriptionSuccess extends SubscriptionState {
  const SubscriptionSuccess({
    super.plans,
    super.status,
    super.message,
    super.userPayment,
  });

  SubscriptionSuccess copyWith({
    List<Plans>? plans,
    Status? status,
    String? message,
    UserPayment? userPayment,
  }) {
    return SubscriptionSuccess(
      plans: plans ?? this.plans,
      status: status ?? this.status,
      message: message ?? this.message,
      userPayment: userPayment ?? this.userPayment,
    );
  }
}
