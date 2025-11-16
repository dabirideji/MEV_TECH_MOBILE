import 'package:flutter/foundation.dart';

class Loader<K extends Enum> extends ChangeNotifier {
  final Map<K, bool> _loaders = {};
  String? _errorMessage;
  String? _successMessage;

  // void setLoading(K key, {required bool value}) {
  //   final updated = Map<K, bool>.from(_loaders);
  //   updated[key] = value;
  // }

  // void show(K key) => setLoading(key, value: true);
  // void hide(K key) => setLoading(key, value: false);

  void show(K key) {
    _loaders[key] = true;
    notifyListeners();
  }

  void hide(K key) {
    _loaders[key] = false;
    notifyListeners();
  }

  bool isLoading(K key) => _loaders[key] ?? false;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSuccess(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  // bool anyLoading() => _loaders.values.any((v) => v == true);

  Future<T?> executeFunction<T>(
    K key,
    Future<T> Function() action, {
    String? successMessage,
    String Function(Object error)? errorMessageBuilder,
    bool rethrowError = false,
  }) async {
    show(key);
    try {
      final result = await action();
      hide(key);
      if (successMessage != null) setSuccess(successMessage);
      return result;
    } catch (e) {
      hide(key);
      setError(
        errorMessageBuilder?.call(e) ?? e.toString(),
      );
      if (rethrowError) rethrow;
      return null;
    }
  }

  @override
  String toString() =>
      'Loader($_loaders, error: $errorMessage, success: $successMessage)';
}

class StateLoader<K extends Enum> {
  final Map<K, bool> loaders;
  final String? errorMessage;
  final String? successMessage;

  // ignore: sort_constructors_first
  const StateLoader({
    this.loaders = const {},
    this.errorMessage,
    this.successMessage,
  });

  /// Shows a specific loader (returns a *new* StateLoader instance)
  StateLoader<K> show(K key) {
    final updated = Map<K, bool>.from(loaders)..[key] = true;
    return StateLoader(
      loaders: updated,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  /// Hides a specific loader
  StateLoader<K> hide(K key) {
    final updated = Map<K, bool>.from(loaders)..[key] = false;
    return StateLoader(
      loaders: updated,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  /// Returns whether a loader is active
  bool isLoading(K key) => loaders[key] ?? false;

  /// Returns a new StateLoader with an error message
  StateLoader<K> setError(String message) => StateLoader(
        loaders: loaders,
        errorMessage: message,
        successMessage: null,
      );

  /// Returns a new StateLoader with a success message
  StateLoader<K> setSuccess(String message) => StateLoader(
        loaders: loaders,
        errorMessage: null,
        successMessage: message,
      );

  /// Resets messages (keeps loaders)
  StateLoader<K> resetMessages() => StateLoader(
        loaders: loaders,
      );

  @override
  String toString() =>
      'StateLoader(loaders: $loaders, error: $errorMessage, success: $successMessage)';
}
