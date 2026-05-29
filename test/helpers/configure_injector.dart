import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/injector.dart';

Future<void> configureInjector() async {
  await configureDependencies(environment: Environment.test);
}
