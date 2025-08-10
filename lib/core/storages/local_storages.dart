import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<String?> getApiKey();
  Future<void> setApiKey(String apiKey);

  Future<String?> getApiRefreshToken();
  Future<void> setApiRefreshToken(String apiRefreshToken);

  Future<void> clearUserData();

  Future<String?> getUserEmail();
  Future<void> setUserEmail(String email);

  Future<String?> getUserType();
  Future<void> setUserType(String type);

  Future<String?> getUserID();
  Future<void> setUserID(String id);
}

@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  const LocalStorageImpl(this._storage);
  final SharedPreferences _storage;
  static const _apiKeyKey = 'apiKey';
  static const _apiRefreshTokenKey = 'apiRefreshToken';
  static const _userEmailKey = 'userEmail';
  static const _userTypeKey = 'userType';
  static const _userIDKey = 'userID';

  @override
  Future<String?> getApiKey() {
    return Future.value(
      _storage.getString(_apiKeyKey),
    );
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await Future.value(
      _storage.setString(_apiKeyKey, apiKey),
    );
  }

  @override
  Future<String?> getApiRefreshToken() {
    return Future.value(
      _storage.getString(_apiRefreshTokenKey),
    );
  }

  @override
  Future<void> setApiRefreshToken(String apiRefreshToken) async {
    await Future.value(
      _storage.setString(_apiRefreshTokenKey, apiRefreshToken),
    );
  }

  @override
  Future<void> setUserID(String id) async {
    await Future.value(
      _storage.setString(_userIDKey, id),
    );
  }

  @override
  Future<String?> getUserID() {
    return Future.value(
      _storage.getString(_userIDKey),
    );
  }

  @override
  Future<void> setUserEmail(String email) async {
    await _storage.setString(_userEmailKey, email);
  }

  @override
  Future<String?> getUserEmail() => Future.value(
        _storage.getString(_userEmailKey),
      );

  @override
  Future<void> setUserType(String type) async {
    await _storage.setString(_userTypeKey, type);
  }

  @override
  Future<String?> getUserType() =>
      Future.value(_storage.getString(_userTypeKey));

  @override
  Future<void> clearUserData() async {
    await _storage.remove(_userEmailKey);
    await _storage.remove(_userTypeKey);
    await _storage.remove(_apiKeyKey);
    await _storage.remove(_userIDKey);
  }
}
