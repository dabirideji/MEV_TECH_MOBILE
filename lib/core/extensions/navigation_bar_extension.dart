import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mevtech/app/router/app_router.dart';

extension BottomNavBarContext on BuildContext {
  bool get shouldShowBottomNavBar {
    final routePath = GoRouterState.of(this).fullPath;

    return {
      '/dashboard',
      '/quizMode',
      '/chat',
      '/course',
      // '/landing',
      '/user',
      // remove the below code
      // '/mockTest',
    }.contains(routePath);
  }
}
