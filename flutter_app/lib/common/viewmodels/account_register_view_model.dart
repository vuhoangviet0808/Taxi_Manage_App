// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import '../services/authentication_service.dart';

class AccountRegisterViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  String _errorMessage = "";
  String phone = "";
  bool _isLoading = false;
  String? _account;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get sdt => phone;
  String? get account => _account;

  void setBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  Future<bool> register(String sdt, String password) async {
    setBusy(true);
    try {
      final _account = await _authenticationService.register(sdt, password);
      setBusy(false);
      if (_account != null) {
        return true;
      } else {
        _errorMessage =
            'Register failed: The phone number is incorrect or already in use';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Register Failed: Exception occurred during register ';
      setBusy(false);
      return false;
    }
  }
}
