import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../services/authentication_service.dart';

class AccountLoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  Account? _account ;
  String _errorMessage = '';
  bool _isLoading = false;
  String _role = 'admin';

  Account? get account => _account;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get role => _role;


  void setBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    setBusy(true);
    try {
    
      _account = await _authenticationService.login(username, password);
      setBusy(false);
      if(_account != null) {
        return true;
      } else  {
        _errorMessage = 'Login Failed: Invalid username or password';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login Failed: Exception occurred during login ';
      setBusy(false);
      return false;
    }
  } 

}