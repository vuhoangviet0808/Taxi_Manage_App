import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';

class UserViewModel extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  User? _user;
  String _errorMessage = '';
  bool _isLoading = false;

  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    setBusy(true);
    try {
      _user = await _authService.login(username, password);
      setBusy(false);
      if(_user != null) {
        return true;
      } else {
        _errorMessage = 'Login Failed: Invalid username or password';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login Failed: Exception occurred during login';
      setBusy(false);
      return false;
    }
  }
}