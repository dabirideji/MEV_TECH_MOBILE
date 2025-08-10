part of 'user_cubit.dart';

enum UserActionType {
  update,
  delete,
}

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {
  const UserLoading({required this.actionType});

  final UserActionType actionType;
  @override
  List<Object> get props => [actionType];
}

final class UserSuccess extends UserState {
  const UserSuccess({
    required this.user,
    required this.actionType,
    this.message = '',
  });

  final UserModel user;
  final UserActionType actionType;
  final String message;

  @override
  List<Object> get props => [user, actionType];
}

final class UserFailure extends UserState {
  const UserFailure(this.errorMessage, {required this.actionType});

  final String errorMessage;
  final UserActionType actionType;

  @override
  List<Object> get props => [errorMessage, actionType];
}
