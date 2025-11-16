part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState({
    this.user,
    this.updateUserStatus = const RequestState.initial(),
    this.imageUploadStatus = const RequestState.initial(),
    this.message = '',
    this.file,
  });

  final UserModel? user;
  final RequestState updateUserStatus;
  final RequestState imageUploadStatus;
  final String message;
  final File? file;

  @override
  List<Object?> get props =>
      [user, updateUserStatus, imageUploadStatus, message, file];
}

final class UserSuccess extends UserState {
  const UserSuccess({
    super.user,
    super.updateUserStatus,
    super.imageUploadStatus,
    super.message,
    super.file,
  });

  UserSuccess copyWith({
    UserModel? user,
    RequestState? updateUserStatus,
    RequestState? imageUploadStatus,
    String? message,
    File? file,
  }) {
    return UserSuccess(
      user: user ?? this.user,
      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      message: message ?? this.message,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props =>
      [user, updateUserStatus, imageUploadStatus, message, file];
}
