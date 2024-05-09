// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../services/authentication_service.dart';

class AccountLoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  Account? _account ;
  String _errorMessage = '';
  bool _isLoading = false;
  String _role = '';
  String phone = '';

  Account? get account => _account;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get role => _role;
  String get sdt => phone;

  void setBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  Future<bool> login(String sdt, String password) async {
    setBusy(true);
    try {
      final Map<String, dynamic> result = await _authenticationService.login(sdt, password);
      setBusy(false);
      if(result['success'] == true) {
        final _account = result['account'];
        _role = _account.role;
        phone = _account.SDT;
        return true;
      } else  {
        _errorMessage = result['account'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login Failed: Exception occurred during login';
      setBusy(false);
      return false;
    }
  } 

}