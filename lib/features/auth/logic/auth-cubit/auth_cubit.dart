import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/core/network/notification_service.dart';
import 'package:mevtech/core/storages/DatabaseHandler.dart';
import 'package:mevtech/core/storages/local_storages.dart';
import 'package:mevtech/core/utils/multiple_status_states.dart';
import 'package:mevtech/core/utils/request_states.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/user/data/models/login_model.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/data/models/user_notification_model.dart';
import 'package:mevtech/features/user/data/models/user_requests.dart.dart';
import 'package:mevtech/features/user/data/repository/user_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> with ChangeNotifier {
  AuthCubit(this.userRepository, this.localStorage, this.notificationService)
    : super(AuthInitial()) {
    // checkUserSession();
  }

  final UserRepository userRepository;
  final LocalStorage localStorage;
  final NotificationService notificationService;

  final db = DatabaseHandler();

  String userEmail = '';
  int _notifReadTryCount = 0;
  int _notifFetchTryCount = 0;

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtToken = TextEditingController();

  UserModel? get currentUser =>
      state is AuthLoginSuccess ? (state as AuthLoginSuccess).model.user : null;

  List<NotificationModel> get currentNotifications => state is AuthLoginSuccess
      ? (state as AuthLoginSuccess).notifications
      : [];

  Future<void> printAccessToken() async {
    final token = await localStorage.getApiKey();
    if (token != null) {
      log('Bearer $token');
      return;
    }
    log('token not found');
  }

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

  Future<void> refreshAndAuthenticate({bool isTokenExpired = false}) async {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    try {
      final token = await localStorage.getApiKey();
      final refreshToken = await localStorage.getApiRefreshToken();

      if (token == null || refreshToken == null) return;

      if (isTokenExpired) {
        await userRepository.refreshToken(
          token: token,
          refreshToken: refreshToken,
        );
      }

      final newToken = await localStorage.getApiKey() ?? token;

      final newRefreshToken =
          await localStorage.getApiRefreshToken() ?? refreshToken;

      final model = LoginModel(
        accessToken: newToken,
        refreshToken: newRefreshToken,
        user: authState.model.user,
        subscription: authState.model.subscription,
      );

      emit(
        authState.copyWith(
          model: model,
          isSubscribed: authState.isSubscribed,
          actionType: AuthActionType.updateData,
        ),
      );
    } catch (e) {
      emit(
        authState.copyWith(
          model: authState.model,
          isSubscribed: authState.isSubscribed,
          actionType: AuthActionType.updateData,
        ),
      );
    }
  }

  Future<void> testOneSignalNotifications(String userId) async {
    try {
      final result = await userRepository.testNotifiion(userId);
      // log(result);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loginOnesignal(String userId) async {
    try {
      final id = await OneSignalUser().getExternalId();
      if (id != null) {
        // log('UserId: $id');
      }

      final isSubscribed = OneSignalPushSubscription().optedIn;
      if (isSubscribed ?? false) {
        // log('$isSubscribed');
      }

      await OneSignal.login(userId);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> checkUserSession() async {
    // remove this immediate hardcoded code
    // txtEmail.text = 'ade@gmail.com';
    // txtPassword.text = 'Crypto123#';
    try {
      emit(const AuthLoading(AuthActionType.sessionCheck));

      final token = await localStorage.getApiKey();
      final refreshToken = await localStorage.getApiRefreshToken();
      final id = await localStorage.getUserID();

      if (token == null || id == null) {
        emit(AuthUnAuthenticated());
        return;
      }
      // log(token);

      final result = await userRepository.checkUserSession(
        token: token,
        refreshToken: refreshToken ?? '',
        id: id,
      );

      final isSubscribed = result.subscription != null;
      final notifications = await getStorageNotifications();

      emit(
        AuthLoginSuccess(
          result,
          isSubscribed: isSubscribed,
          notifications: notifications,
          actionType: AuthActionType.sessionCheck,
        ),
      );

      MevTechUtilities.id = id;
      MevTechUtilities.authKey = token;
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.sessionCheck));
    } finally {
      notifyListeners();
    }
  }

  // Future<void> checkUserSessionMock() async {
  //   try {
  //     emit(const AuthLoading(AuthActionType.sessionCheck));
  //     final token = await localStorage.getApiKey();
  //     final refreshToken = await localStorage.getApiRefreshToken();
  //     final id = await localStorage.getUserID();
  //     if (token == null || id == null) {
  //       emit(AuthUnAuthenticated());
  //       return;
  //     }
  //     final result = await Future.delayed(const Duration(seconds: 3), () {
  //       return 'Hurray';
  //     });
  //     emit(AuthFailure('test', actionType: AuthActionType.sessionCheck));
  //     log(result);
  //   } catch (e) {
  //     emit(AuthFailure(e.toString(), actionType: AuthActionType.sessionCheck));
  //   }
  // }

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
      userEmail = txtEmail.text;

      emit(AuthRegisterSuccess(result));
      await localStorage.clearUserData();

      clearField();
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.register));
    }
  }

  Future<void> loginUser() async {
    final jsonData = LoginRequest(
      email: txtEmail.text,
      password: txtPassword.text,
    );
    try {
      emit(const AuthLoading(AuthActionType.login));

      final result = await userRepository.loginStudent(jsonData);

      // await db.openDatabaseForUser(result.user.id);

      await localStorage.setApiKey(result.accessToken);
      await localStorage.setApiRefreshToken(result.refreshToken);
      await localStorage.setUserID(result.user.id);
      final isSubscribed = result.subscription != null;

      MevTechUtilities.id = result.user.id;

      emit(AuthLoginSuccess(result, isSubscribed: isSubscribed));
      // log('Bearer ${result.accessToken}');

      clearField();
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.login));
    } finally {
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthLoading(AuthActionType.login));

      final result = await userRepository.googleSignIn();
      final isSubscribed = result.subscription != null;

      await localStorage.setApiKey(result.accessToken);
      await localStorage.setApiRefreshToken(result.refreshToken);
      await localStorage.setUserID(result.user.id);

      emit(AuthLoginSuccess(result, isSubscribed: isSubscribed));
    } catch (e) {
      emit(AuthFailure(e.toString(), actionType: AuthActionType.login));
    } finally {
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    try {
      await localStorage.clearUserData();

      await db.close();
      // await db.deleteUserDatabase(currentUser?.id);

      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthUnAuthenticated());
    } finally {
      notifyListeners();
    }
  }

  // notifications

  void showNotification({
    required int id,
    required String title,
    required String body,
  }) {
    notificationService.showNotification(id: id, title: title, body: body);
  }

  Future<void> saveReadNotifications(
    List<NotificationModel> notifications,
  ) async {
    final stored = await localStorage.getUserNotifications() ?? [];
    final existing = stored
        .map(
          (e) => NotificationModel.fromJson(
            json.decode(e) as Map<String, dynamic>,
          ),
        )
        .toList();

    final readOnly = notifications.where((n) => n.isRead).toList();

    final mergedMap = {
      for (final n in existing) n.id: n,
      for (final n in readOnly) n.id: n,
    };

    // final uniqueMap = {for (final n in readOnly) n.id: n};

    final uniqueList = mergedMap.values.toList();

    await localStorage.setUserNotifications(uniqueList);
  }

  Future<List<NotificationModel>> getStorageNotifications() async {
    final jsonList = await localStorage.getUserNotifications();

    if (jsonList == null) return [];

    return jsonList
        .map(
          (jsonStr) => NotificationModel.fromJson(
            json.decode(jsonStr) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> fetchNotifications({bool shouldShowNotif = false}) async {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    final notifications = await getStorageNotifications();

    if (_notifFetchTryCount == 10) return;

    // /api/Notification/GetUserUnreadNotifications/{userId}/unread
    // /api/Notification/GetUserNotifications/{userId}/all

    final endPoint = notifications.isEmpty
        ? 'Notification/GetUserNotifications/${authState.model.user.id}/all'
        : 'Notification/GetUserUnreadNotifications/${authState.model.user.id}/unread';

    try {
      final result = await userRepository.fetchAll<NotificationModel>(
        endPoint: endPoint,
        fromJson: NotificationModel.fromJson,
      );

      if (result.isEmpty && notifications.isNotEmpty) return;

      final map = <String, NotificationModel>{
        for (final n in result) n.id: n,
        for (final n in notifications) n.id: n,
      };

      final merged = map.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await saveReadNotifications(merged);

      _notifFetchTryCount = 0;

      emit(authState.copyWith(notifications: merged));

      if (shouldShowNotif) {
        showNotification(
          id: 1,
          title: '🔔 Alert',
          body: 'You have new unread notification!',
        );
      }
    } catch (e) {
      _notifFetchTryCount++;
      await fetchNotifications();
    }
  }

  Future<void> deleteNotifications(String id) async {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    // /api/Notification/GetUserUnreadNotifications/{userId}/unread
    // /api/Notification/GetUserNotifications/{userId}/all

    try {
      final result = await userRepository.delete<NotificationModel>(
        id: id,
        endPoint: 'Notification/Delete',
        fromJson: NotificationModel.fromJson,
      );

      log(result);

      emit(authState.copyWith());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> markAsreadNotification({
    required int index,
    required String notificationId,
  }) async {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    _notifReadTryCount = 0;
    try {
      final notification = authState.notifications.firstWhere(
        (notif) => notif.id == notificationId,
      );
      if (notification.isRead) return;

      _markAsreadLocal(index: index);
      unawaited(_markAsreadRemote(notificationId: notificationId));
    } catch (e) {
      log('error encountered');
    }
  }

  Future<void> _markAsreadRemote({required String notificationId}) async {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    if (_notifReadTryCount == 7) return;

    try {
      final result = await userRepository.markNotifAsread(notificationId);

      if (result) {
        final notification = authState.notifications.firstWhere(
          (notif) => notif.id == notificationId,
        );
        await saveReadNotifications([notification]);

        _notifReadTryCount = 0;
        await fetchNotifications(); // might need to remove
      }
    } catch (e) {
      _notifReadTryCount++;
      await _markAsreadRemote(notificationId: notificationId);
    }
  }

  void _markAsreadLocal({required int index}) {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    try {
      final updatedNotification = NotificationModel(
        userId: authState.notifications[index].userId,
        title: authState.notifications[index].title,
        message: authState.notifications[index].message,
        isRead: true,
        id: authState.notifications[index].id,
        createdAt: authState.notifications[index].createdAt,
        updatedAt: authState.notifications[index].updatedAt,
      );

      final notifications = authState.notifications.map((notification) {
        return notification.id == updatedNotification.id
            ? updatedNotification
            : notification;
      }).toList();

      emit(authState.copyWith(notifications: notifications));
    } catch (e) {
      log('error encountered');
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

    final isSubscribed = model.subscription != null;

    try {
      if (user != null) {
        emit(
          authState.copyWith(
            model: model,
            isSubscribed: isSubscribed,
            actionType: AuthActionType.updateData,
          ),
        );
      }
    } catch (_) {}
  }

  void updateUserSubscription({required bool isSubscribed}) {
    if (state is! AuthLoginSuccess) return;
    final authState = state as AuthLoginSuccess;

    final model = LoginModel(
      accessToken: authState.model.accessToken,
      refreshToken: authState.model.refreshToken,
      user: authState.model.user,
      subscription: authState.model.subscription,
    );

    try {
      emit(
        authState.copyWith(
          model: model,
          isSubscribed: isSubscribed,
          actionType: AuthActionType.updateData,
        ),
      );
    } catch (_) {}
  }

  // email verify for signup

  Future<void> sendEmailConfirmToken() async {
    final jsonData = <String, dynamic>{
      'emailAddress': userEmail,
      'title': 'USER SIGNUP VERICATION',
    };
    if (state is! AuthRegisterSuccess) return;
    final current = state as AuthRegisterSuccess;
    try {
      emit(current.copyWith(sendStatus: const RequestState.loading()));

      final result = await userRepository.sendEmailConfirmToken(jsonData);

      emit(
        current.copyWith(
          sendStatus: const RequestState.success(),
          message: result,
        ),
      );
    } catch (e) {
      emit(current.copyWith(sendStatus: RequestState.failure(e.toString())));
    }
  }

  Future<void> verifyEmailConfirmToken() async {
    final jsonData = <String, dynamic>{
      'tk': txtToken.text,
      'reference': userEmail,
    };
    if (state is! AuthRegisterSuccess) return;
    final current = state as AuthRegisterSuccess;
    try {
      emit(current.copyWith(verifyStatus: const RequestState.loading()));

      final result = await userRepository.verifyEmailConfirmToken(jsonData);

      emit(
        current.copyWith(
          verifyStatus: const RequestState.success(),
          message: result,
        ),
      );

      clearField();
    } catch (e) {
      emit(current.copyWith(verifyStatus: RequestState.failure(e.toString())));
    }
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
      emit(AuthFailure(e.toString(), actionType: AuthActionType.resetPassword));
    }
  }

  // Future<String?> fetchQuizExplanation(String message) async {
  //   try {
  //     final explanationMessage = await userRepository.getQuizExplanation(
  //       message,
  //     );

  //     return explanationMessage;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
