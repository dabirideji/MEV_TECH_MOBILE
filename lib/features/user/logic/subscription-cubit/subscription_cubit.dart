import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/utils/multiple_status_states.dart';
import 'package:template/features/user/data/models/subscription_model.dart';
import 'package:template/features/user/data/repository/user_repository.dart';

part 'subscription_state.dart';

@injectable
class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this.userRepository) : super(const SubscriptionSuccess());

  final UserRepository userRepository;

  Future<void> fetchSubscriptions() async {
    if (state is! SubscriptionSuccess) return;
    final current = state as SubscriptionSuccess;
    try {
      emit(current.copyWith(status: const Status.loading(CrudAction.fetch)));

      final result = await userRepository.fetchAll<Plans>(
        endPoint: 'Plan/GetAllAsQueryable',
        fromJson: Plans.fromJson,
      );

      emit(
        current.copyWith(
          status: const Status.success(CrudAction.fetch),
          plans: result,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          status: Status.failure(action: CrudAction.fetch, error: e.toString()),
        ),
      );
    }
  }

  Future<void> addSubscriptions({
    required String provider,
    required String userId,
    required String planId,
  }) async {
    if (state is! SubscriptionSuccess) return;
    final current = state as SubscriptionSuccess;
    const callbackUrl = 'https://www.google.com';
    // 'dev.adryanev.template.dev://payment_complete';
    // getRedirectUri();

    try {
      final userPayment = UserPayment(
          userId: userId,
          planId: planId,
          currency: 'NGN',
          narration: 'Premium Subscription',
          callbackUrl: callbackUrl);

      if (provider.isEmpty) {
        emit(current.copyWith(
          status: const Status.failure(
              action: CrudAction.create,
              error: 'Please select a payment provider to continue'),
        ));
        return;
      }

      emit(current.copyWith(status: const Status.loading(CrudAction.create)));

      final result = await userRepository.createModel<UserPayment>(
        jsonData: userPayment.toJson(),
        endPoint: 'payment/$provider/initialize',
        fromJson: UserPayment.fromJson,
      );

      emit(
        current.copyWith(
          status: const Status.success(CrudAction.create),
          userPayment: result,
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          status:
              Status.failure(action: CrudAction.create, error: e.toString()),
        ),
      );
    }
  }

  String getRedirectUri() {
    const currentFlavor = String.fromEnvironment('FLAVOR');
    switch (currentFlavor) {
      case 'production':
        return 'dev.adryanev.template://auth-callback';
      case 'staging':
        return 'dev.adryanev.template.stg://auth-callback';
      case 'development':
        return 'dev.adryanev.template.dev://auth-callback';
      default:
        throw Exception('Unknown or missing FLAVOR');
    }
  }
}
