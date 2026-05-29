// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/injector.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// OneSignal App Id : 05bd96fb-6411-4db2-b882-3f5951dc1f0c

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> bootstrap(Widget builder, {required String environment}) async {
  WidgetsFlutterBinding.ensureInitialized();

  const initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const initializationSettingsDarwin = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // Enable verbose logging for debugging (remove in production)
  await OneSignal.Debug.setLogLevel(OSLogLevel.none);
  // Initialize with your OneSignal App ID
  OneSignal.initialize('05bd96fb-6411-4db2-b882-3f5951dc1f0c');

  OneSignal.User.pushSubscription.addObserver((state) {
    log('Push subscription state:');
    // log('  optedIn: ${state.current.optedIn}');
    // log('  id: ${state.current.id}');
    // log('  token: ${state.current.token}');
  });

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await configureDependencies(environment: environment);

  await getIt.allReady();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();
  // await SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.immersive,
  //   overlays: [],
  // );

  runApp(builder);
}
