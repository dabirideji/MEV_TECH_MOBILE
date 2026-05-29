import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/features/auth/logic/auth-cubit/auth_cubit.dart';

@lazySingleton
class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(AuthCubit authCubit) {
    _sub = authCubit.stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// class AuthRouterNotifier extends ChangeNotifier {
//   void refresh() {
//     notifyListeners();
//   }
// }

// step 2
// final authRouterNotifier = AuthRouterNotifier();

// in go router
// refreshListenable: authRouterNotifier,

// BlocListener<AuthCubit, AuthState>(
//   listener: (context, state) {
//     authRouterNotifier.refresh();
//   },
//   child: SplashPage(),
// );
