import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/storages/local_storages.dart';
import 'package:template/core/utils/constants.dart';
import 'package:template/data/google_signin.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/data/models/login_model.dart';
import 'package:template/features/user/data/models/subscription_model.dart';
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/data/models/user_requests.dart.dart';
import 'package:template/features/user/data/repository/user_repository.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> with ChangeNotifier {
  AuthCubit(this.userRepository, this.localStorage) : super(AuthInitial()) {
    checkUserSession();
  }

  final UserRepository userRepository;
  final LocalStorage localStorage;
  String userEmail = '';

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtToken = TextEditingController();

  void clearField() {
    txtUsername.clear();
    txtFirstName.clear();
    txtLastName.clear();
    txtPhoneNumber.clear();
    txtEmail.clear();
    txtPassword.clear();
    txtConfirmPassword.clear();
    txtToken.clear();
  }

  Future<void> checkUserSession() async {
    // remove this immediate hardcoded code
    txtEmail.text = 'ade@gmail.com';
    txtPassword.text = 'Crypto123#';
    try {
      emit(const AuthLoading(AuthActionType.sessionCheck));

      final token = await localStorage.getApiKey();
      final refreshToken = await localStorage.getApiRefreshToken();
      final id = await localStorage.getUserID();
      final userType = await localStorage.getUserType();

      if (token == null || id == null) {
        emit(AuthUnAuthenticated());
        return;
      }

      final result = await userRepository.checkUserSession(
        token: token,
        refreshToken: refreshToken ?? '',
        id: id,
        userType: userType,
      );

      emit(
        AuthLoginSuccess(result, actionType: AuthActionType.sessionCheck),
      );

      MevTechUtilities.id = id;
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.sessionCheck));
    } finally {
      notifyListeners();
    }
  }

  Future<void> registerUser() async {
    final jsonData = RegisterRequest(
      username: txtUsername.text,
      firstName: txtFirstName.text,
      lastName: txtLastName.text,
      email: txtEmail.text,
      phoneNumber: txtPhoneNumber.text,
      password: txtPassword.text,
      confirmPassword: txtConfirmPassword.text,
    );

    try {
      emit(const AuthLoading(AuthActionType.register));

      final result = await userRepository.createStudent(jsonData);

      emit(AuthRegisterSuccess(result));
      await localStorage.clearUserData();

      clearField();
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.register));
    }
  }

  Future<void> loginUser(String usertype) async {
    final jsonData = LoginRequest(
      email: txtEmail.text,
      password: txtPassword.text,
    );
    try {
      emit(const AuthLoading(AuthActionType.login));

      final result = usertype == UserType.instructor
          ? await userRepository.loginInstructor(jsonData)
          : await userRepository.loginStudent(jsonData);

      await localStorage.setApiKey(result.accessToken);
      await localStorage.setApiRefreshToken(result.refreshToken);
      await localStorage.setUserID(result.user.id);
      await localStorage.setUserType(
        result.user.isInstructor ? UserType.instructor : UserType.student,
      );

      emit(AuthLoginSuccess(result));

      clearField();
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.login));
    } finally {
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    final googleSigninService = GoogleSigninService();
    try {
      final result = await googleSigninService.initiateGoogleSignIn();

      if (result != null) {
        log(result.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await localStorage.clearUserData();
      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthUnAuthenticated());
    } finally {
      notifyListeners();
    }
  }

  void updateUserdata(UserModel? user) {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    final model = LoginModel(
      accessToken: authState.model.accessToken,
      refreshToken: authState.model.refreshToken,
      user: user ?? authState.model.user,
      subscription: authState.model.subscription,
    );

    try {
      if (user != null) {
        emit(AuthLoginSuccess(model, actionType: AuthActionType.updateData));
      }
    } catch (_) {}
  }

  Future<void> sendPasswordResetToken() async {
    final jsonData = PasswordResetTokenRequest(emailAddress: txtEmail.text);
    userEmail = '';
    try {
      emit(const AuthLoading(AuthActionType.sendPasswordRequest));

      final result = await userRepository.sendPasswordResetToken(jsonData);

      if (result.isNotEmpty) {
        userEmail = txtEmail.text;
      }

      emit(
        AuthPasswordResetSuccess(
          result,
          actionType: AuthActionType.sendPasswordRequest,
        ),
      );

      clearField();
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
          actionType: AuthActionType.sendPasswordRequest,
        ),
      );
    }
  }

  Future<void> verifyPasswordResetToken() async {
    final jsonData = VerifyPasswordResetTokenRequest(
      token: txtToken.text,
      userReferenceValue: userEmail,
    );
    try {
      emit(const AuthLoading(AuthActionType.verifyPasswordRequest));

      final result = await userRepository.verifyPasswordResetToken(jsonData);

      emit(
        AuthPasswordResetSuccess(
          result,
          actionType: AuthActionType.verifyPasswordRequest,
        ),
      );

      clearField();
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
          actionType: AuthActionType.verifyPasswordRequest,
        ),
      );
    }
  }

  Future<void> resetPassword({required bool isInstructor}) async {
    final jsonData = ResetPasswordRequest(
      email: userEmail,
      password: txtPassword.text,
      confirmPassword: txtConfirmPassword.text,
    );
    try {
      emit(const AuthLoading(AuthActionType.resetPassword));

      final result = isInstructor
          ? await userRepository.resetPasswordInstructor(jsonData)
          : await userRepository.resetPasswordStudent(jsonData);

      emit(
        AuthPasswordResetSuccess(
          result,
          actionType: AuthActionType.resetPassword,
        ),
      );

      clearField();
    } catch (e) {
      emit(
        AuthFailure(e.toString(), actionType: AuthActionType.resetPassword),
      );
    }
  }
}
