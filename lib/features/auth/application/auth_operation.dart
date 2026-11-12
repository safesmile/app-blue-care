import 'package:flutter/foundation.dart';
import '../domain/auth_repository.dart';

/// One pending operation per form. Completion after disposal has no UI effects.
class AuthOperation extends ChangeNotifier {
  bool _disposed = false;
  bool _busy = false;
  String? _error;
  bool get busy => _busy;
  String? get error => _error;

  void showError(String message) {
    if (_disposed || busy) return;
    _error = message;
    notifyListeners();
  }

  Future<bool> run(Future<void> Function() action) async {
    if (_disposed || busy) return false;
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return !_disposed;
    } on AuthFailure catch (failure) {
      if (!_disposed) _error = failure.message;
      return false;
    } catch (_) {
      if (!_disposed) _error = 'No pudimos continuar. Intenta de nuevo.';
      return false;
    } finally {
      if (!_disposed) {
        _busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
