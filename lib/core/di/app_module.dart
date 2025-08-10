import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:template/core/network/api_service.dart';

@module
abstract class AppModule {
  @lazySingleton
  http.Client get client => http.Client();

  // @lazySingleton
  // ApiService apiService(http.Client client) => ApiService(client);
}
