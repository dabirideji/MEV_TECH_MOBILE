part of 'auth_cubit.dart';

enum AuthActionType {
  login,
  register,
  sessionCheck,
  sendPasswordRequest,
  verifyPasswordRequest,
  resetPassword,
  updateData,
}

enum AuthStatus { initial, loading, success, failure }

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  const AuthLoading(this.actionType);

  final AuthActionType actionType;

  @override
  List<Object> get props => [actionType];
}

// final class AuthAuthenticated extends AuthState {
//   const AuthAuthenticated(this.user);

//   final UserModel user;
// }

final class AuthUnAuthenticated extends AuthState {}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess(
    this.model, {
    this.actionType = AuthActionType.login,
    this.status = const Status.initial(),
    this.isSubscribed = false,
    this.notifications = const [],
  });
  final LoginModel model;
  final AuthActionType actionType;
  final Status status;
  final bool isSubscribed;
  final List<NotificationModel> notifications;

  AuthLoginSuccess copyWith({
    LoginModel? model,
    AuthActionType? actionType,
    Status? status,
    bool? isSubscribed,
    List<NotificationModel>? notifications,
  }) {
    return AuthLoginSuccess(
      model ?? this.model,
      actionType: actionType ?? this.actionType,
      status: status ?? this.status,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props =>
      [model, actionType, status, isSubscribed, notifications];
}

final class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess(
    this.message, {
    this.sendStatus = const RequestState.initial(),
    this.verifyStatus = const RequestState.initial(),
  });

  final String message;
  final RequestState sendStatus;
  final RequestState verifyStatus;

  AuthRegisterSuccess copyWith({
    String? message,
    RequestState? sendStatus,
    RequestState? verifyStatus,
  }) {
    return AuthRegisterSuccess(
      message ?? this.message,
      sendStatus: sendStatus ?? this.sendStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
    );
  }

  @override
  List<Object> get props => [message, sendStatus, verifyStatus];
}

final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess(this.message, {required this.actionType});

  final String message;
  final AuthActionType actionType;

  @override
  List<Object> get props => [message];
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.errorMessage, {required this.actionType});

  final String errorMessage;
  final AuthActionType actionType;

  @override
  List<Object> get props => [errorMessage, actionType];
}
