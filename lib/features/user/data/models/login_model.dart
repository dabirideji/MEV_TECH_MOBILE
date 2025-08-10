import 'package:template/features/user/data/models/subscription_model.dart';
import 'package:template/features/user/data/models/user_model.dart';

class LoginModel {
  LoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.subscription,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['userInformation'] as Map<String, dynamic>),
      subscription: json['userSubscription'] != null
          ? UserSubscription.fromJson(
              json['userSubscription'] as Map<String, dynamic>,
            )
          : null,
    );
  }
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final UserSubscription? subscription;
}
