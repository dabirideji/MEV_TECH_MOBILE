import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/data/models/user_requests.dart.dart';
import 'package:template/features/user/data/repository/user_repository.dart';

part 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());

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

  final UserRepository userRepository;

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void clearField() {
    txtUsername.clear();
    txtFirstName.clear();
    txtLastName.clear();
    txtPhoneNumber.clear();
    txtEmail.clear();
    txtPassword.clear();
  }

  Future<void> updateUser(String? id, {required bool isInstructor}) async {
    final jsonData = UpdateUserRequest(
      id: id ?? '',
      username: txtUsername.text,
      firstName: txtFirstName.text,
      lastName: txtLastName.text,
      email: txtEmail.text,
      phoneNumber: txtPhoneNumber.text,
      password: txtPassword.text,
    );
    try {
      emit(const UserLoading(actionType: UserActionType.update));

      final result = isInstructor
          ? await userRepository.updateInstructor(jsonData, id ?? '')
          : await userRepository.updateStudent(jsonData, id ?? '');

      emit(
        UserSuccess(
          user: result,
          actionType: UserActionType.update,
          message: 'Update Request Successful',
        ),
      );
    } catch (e) {
      emit(UserFailure(e.toString(), actionType: UserActionType.update));
    }
  }
}
