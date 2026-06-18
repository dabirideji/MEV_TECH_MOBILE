import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/data/google_signin.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // final service = ApiService();
  final googleSigninService = GoogleSigninService();

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();

  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  void clearField() {
    txtUsername.clear();
    txtFirstName.clear();
    txtLastName.clear();
    txtPhoneNumber.clear();
    txtEmail.clear();
    txtPassword.clear();
    txtConfirmPassword.clear();
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     emit(LoginLoading());

  //     final result = await googleSigninService.initiateGoogleSignIn();

  //     if (result != null) {
  //       if (result is Map && result['status'] == true) {
  //         emit(
  //           LoginSuccess(result['responseMessage'] as String),
  //         );
  //         clearField();
  //       } else if (result is Map) {
  //         emit(LoginFailure(result['responseMessage'] as String));
  //       } else {
  //         emit(LoginFailure(result as String));
  //         debugPrint(result);
  //       }
  //     } else {
  //       emit(
  //         const LoginFailure(
  //           'Unable To Unthenticate Your Google Account.\nPlease Try Again',
  //         ),
  //       );
  //       return;
  //     }
  //   } catch (e) {
  //     emit(LoginFailure(e.toString()));
  //   }
  // }
}
