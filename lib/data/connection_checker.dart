import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

class InternetCheck {
  static Future<bool> connectionStatus() async {
    final hasInternet = await InternetConnectivity().hasInternetConnection;

    return hasInternet;
  }
}
