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

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
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
  const AuthLoginSuccess(this.model, {this.actionType = AuthActionType.login});
  final LoginModel model;
  final AuthActionType actionType;

  @override
  List<Object> get props => [model];
}

final class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
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
