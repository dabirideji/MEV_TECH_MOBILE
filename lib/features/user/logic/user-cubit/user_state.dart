part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState({
    this.user,
    this.updateUserStatus = const RequestState.initial(),
    this.imageUploadStatus = const RequestState.initial(),
    this.deleteUserAccountStatus = const RequestState.initial(),
    this.message = '',
    this.file,
  });

  final UserModel? user;
  final RequestState updateUserStatus;
  final RequestState imageUploadStatus;
  final RequestState deleteUserAccountStatus;
  final String message;
  final File? file;

  @override
  List<Object?> get props => [
    user,
    updateUserStatus,
    imageUploadStatus,
    deleteUserAccountStatus,
    message,
    file,
  ];
}

final class UserSuccess extends UserState {
  const UserSuccess({
    super.user,
    super.updateUserStatus,
    super.imageUploadStatus,
    super.deleteUserAccountStatus,
    super.message,
    super.file,
  });

  UserSuccess copyWith({
    UserModel? user,
    RequestState? updateUserStatus,
    RequestState? imageUploadStatus,
    RequestState? deleteUserAccountStatus,
    String? message,
    File? file,
  }) {
    return UserSuccess(
      user: user ?? this.user,
      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      deleteUserAccountStatus:
          deleteUserAccountStatus ?? this.deleteUserAccountStatus,
      message: message ?? this.message,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [
    user,
    updateUserStatus,
    imageUploadStatus,
    deleteUserAccountStatus,
    message,
    file,
  ];
}
