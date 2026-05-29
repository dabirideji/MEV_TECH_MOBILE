import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/core/utils/request_states.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/data/models/user_requests.dart.dart';
import 'package:mevtech/features/user/data/repository/user_repository.dart';

part 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(const UserSuccess());

  final UserRepository userRepository;

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void populateData(UserModel? user) {
    if (user != null) {
      txtUsername.text = user.username;
      txtFirstName.text = user.firstName;
      txtLastName.text = user.lastName;
      txtPhoneNumber.text = user.phoneNumber;
      txtEmail.text = user.email;
      txtPassword.text = user.password ?? '';
    }
  }

  void fetchSavedUserData(UserModel? user) {
    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    if (user != null) {
      emit(current.copyWith(user: user));
    }
  }

  void clearField() {
    txtUsername.clear();
    txtFirstName.clear();
    txtLastName.clear();
    txtPhoneNumber.clear();
    txtEmail.clear();
    txtPassword.clear();
  }

  Future<void> updateUser(String? id) async {
    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    try {
      if (id != null) {
        final jsonData = UpdateUserRequest(
          id: id,
          username: txtUsername.text,
          firstName: txtFirstName.text,
          lastName: txtLastName.text,
          email: txtEmail.text,
          phoneNumber: txtPhoneNumber.text,
          password: txtPassword.text,
        );

        emit(current.copyWith(updateUserStatus: const RequestState.loading()));

        final result = await userRepository.updateStudent(jsonData, id);

        emit(
          current.copyWith(
            updateUserStatus: const RequestState.success(),
            user: result,
            message: 'Update Request Successful',
          ),
        );
      } else {
        emit(
          current.copyWith(
            updateUserStatus: const RequestState.failure(
              'Invalid user ID, please re-login',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        current.copyWith(updateUserStatus: RequestState.failure(e.toString())),
      );
    }
  }

  Future<void> deleteUserAccount() async {
    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    try {
      emit(
        current.copyWith(deleteUserAccountStatus: const RequestState.loading()),
      );

      final result = await userRepository.deleteAccount();

      emit(
        current.copyWith(
          deleteUserAccountStatus: const RequestState.success(),

          message: '$result\nAccount Deleted Successfully',
        ),
      );
    } catch (e) {
      emit(
        current.copyWith(
          deleteUserAccountStatus: RequestState.failure(e.toString()),
        ),
      );
    }
  }

  File? nullFile;

  Future<void> uploadProfilePic(File? imageFile) async {
    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    try {
      if (current.user != null && imageFile != null) {
        if (!isClosed) {
          emit(
            current.copyWith(imageUploadStatus: const RequestState.loading()),
          );
        }

        final result = await userRepository.uploadProfileImage(
          userId: current.user!.id,
          imageFile: imageFile,
        );

        if (!isClosed) {
          emit(
            current.copyWith(
              imageUploadStatus: const RequestState.success(),
              user: result,
              message: 'Image upload successful',
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          current.copyWith(
            imageUploadStatus: RequestState.failure(e.toString()),
            file: nullFile,
          ),
        );

        emit(UserSuccess(user: current.user));
      }
    }
  }

  Future<void> compresseAndGetImage() async {
    resetState();

    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    try {
      final image = await getImageFile();

      if (image != null) {
        final result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          '${image.path}.jpg',
          quality: 5,
        );
        if (result != null) {
          final file = File(result.path);

          if (!isClosed) {
            emit(current.copyWith(file: file));
          }

          await uploadProfilePic(file);
        } else {
          throw Exception('An Error Occured');
        }
      } else {
        return;
      }
    } catch (e) {
      if (!isClosed) {
        emit(current.copyWith(message: e.toString()));
      }
    }
  }

  void resetState() {
    if (state is! UserSuccess) return;
    final current = state as UserSuccess;

    if (!isClosed) {
      emit(
        current.copyWith(
          imageUploadStatus: const RequestState.initial(),
          message: '',
          updateUserStatus: const RequestState.initial(),
          deleteUserAccountStatus: const RequestState.initial(),
        ),
      );
    }
  }

  // Future<void> resetInitialState() async {
  //   // await Future.delayed(const Duration(seconds: 1), () {});

  //   if (state is! UserSuccess) return;
  //   final current = state as UserSuccess;
  //   if (!isClosed) {
  //     emit(UserSuccess(user: current.user));
  //   }
  // }

  Future<File?> getImageFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      return file;
    } else {
      return null;
    }
  }
}
