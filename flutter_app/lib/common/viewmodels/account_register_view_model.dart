// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart';
import '../services/authentication_service.dart';

class AccountRegisterViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  String _errorMessage = "";
  String phone = "";
  bool _isLoading = false;
  late Map<String, dynamic> _account ;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get sdt => phone;


  void setBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<bool> register(String SDT, String password) async {
    setBusy(true);
    try {
      _account = await _authenticationService.register(SDT, password);
      setBusy(false);
      if(_account['success'] == true) {
        return true;
      } else {
        _errorMessage = _account['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Register Failed: Exception occurred during register';
      setBusy(false);
      return false;
    }
  }
}
