// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/app/router/app_router.dart';
import 'package:mevtech/core/extensions/context_extensions.dart';
import 'package:mevtech/core/network/signalr_cubit.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';
import 'package:mevtech/features/chat/data/chat-data/chat_data_cubit.dart';
import 'package:mevtech/features/course/logic/selected_course_cubit.dart';
import 'package:mevtech/features/home/home_cubit.dart';
import 'package:mevtech/features/presentation/dashboard/dashboard_cubit.dart';
import 'package:mevtech/features/presentation/landing/landing_cubit.dart';
import 'package:mevtech/injector.dart';
// import 'package:mevtech/l10n/app_localizations.dart';

// import 'package:mevtech/l10n/l10n.dart';
import 'package:mevtech/shared/flash/presentation/blocs/cubit/flash_cubit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final _appTextTheme = GoogleFonts.poppinsTextTheme();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<FlashCubit>()),
        BlocProvider(create: (context) => getIt<LandingCubit>()),
        // BlocProvider(
        //   create: (context) => getIt<AuthCubit>(),
        // ),
        BlocProvider.value(value: getIt<AuthCubit>()),
        // BlocProvider(create: (context) => getIt<HomeCubit>()),
        // BlocProvider(create: (context) => getIt<SelectedCourseCubit>()),
        // BlocProvider<SignalRCubit>(
        //   create: (context) => getIt<SignalRCubit>(),
        // ),
        BlocProvider.value(value: getIt<SignalRCubit>()),
        // BlocProvider(create: (context) => getIt<ChatDataCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FlashCubit, FlashState>(
            listener: (context, state) {
              switch (state) {
                case FlashDisappeared():
                  break;
                case FlashAppeared():
                  context.showSnackbar(message: state.message);
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, authState) {
              final signalRCubit = context.read<SignalRCubit>();
              if (authState is AuthLoginSuccess) {
                context.read<AuthCubit>().loginOnesignal(
                  authState.model.user.id,
                );
                signalRCubit.connect(
                  userId: authState.model.user.id,
                  token: authState.model.accessToken,
                );
              } else if (authState is AuthUnAuthenticated) {
                signalRCubit.disconnect();
              }
            },
          ),
          BlocListener<SignalRCubit, SignalRState>(
            listenWhen: (prev, curr) =>
                prev.overallStatus != curr.overallStatus,
            listener: (context, signalRState) {
              // This is a global listener for any connection event.
              if (signalRState.overallStatus == ConnectionStatus.disconnected ||
                  signalRState.overallStatus == ConnectionStatus.error) {
                final authState = context.read<AuthCubit>().state;
                final authCubit = context.read<AuthCubit>();
                if (authState is AuthLoginSuccess) {
                  // A slight delay to avoid overwhelming the server, then retry.
                  Future.delayed(const Duration(seconds: 3), () async {
                    await authCubit.refreshAndAuthenticate(
                      isTokenExpired:
                          signalRState.message?.contains('400') ?? false,
                    );
                  });
                }
              }
            },
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(ScreenUtilSize.width, ScreenUtilSize.height),
          // designSize: const Size(390, 844),
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              // scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: ThemeData(
                useMaterial3: true,
                primaryColor: AppColor.primary,
                colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
                // textTheme: GoogleFonts.poppinsTextTheme(),
                textTheme: _appTextTheme,
              ),
              // localizationsDelegates: const [
              //   AppLocalizations.delegate,
              //   GlobalMaterialLocalizations.delegate,
              // ],
              // supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: appRouter,
              builder: (context, widget) {
                // return MediaQuery(
                //   data: MediaQuery.of(context)
                //       .copyWith(textScaler: TextScaler.noScaling),
                //   child: widget!,
                // );

                return FAnimatedTheme(
                  data: FThemeData(
                    colors: FThemes.zinc.light.colors.copyWith(
                      primary: AppColor.primary,
                      primaryForeground: Colors.white,
                    ),
                    typography: FThemes.zinc.light.typography
                        .copyWith(xs: const TextStyle(fontSize: 12, height: 1))
                        .scale(sizeScalar: 0.8),
                  ),
                  child: MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.noScaling),
                    child: widget!,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// theme: ThemeData(
//   textTheme: poppinsTextTheme,
//   colorScheme: ColorScheme.fromSeed(
//     seedColor: Colors.deepPurple,
//     primary: Colors.deepPurple,
//     onPrimary: Colors.white,
//     onBackground: Colors.black, // Used for general text color
//   ),
// ),
// final poppinsTextTheme = GoogleFonts.poppinsTextTheme().copyWith(
//   headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
//   headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
//   titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
//   bodyLarge: GoogleFonts.poppins(fontSize: 16),
//   bodyMedium: GoogleFonts.poppins(fontSize: 14),
//   labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500), late final GoRouter _router;
// );
