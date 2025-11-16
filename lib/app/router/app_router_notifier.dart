import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:template/features/auth/logic/auth-cubit/auth_cubit.dart';

@lazySingleton
class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(AuthCubit authCubit) {
    authCubit.stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
