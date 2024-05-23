import 'package:flutter/foundation.dart';
import '../services/authentication_service.dart';


class AccountInputInforViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService = AuthenticationService();
  String _errorMessage = "";
  bool _isLoading = false;
  late Map<String, dynamic> _user;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  void setBusy(bool isBusy) {
    _isLoading = isBusy;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<bool> inputinfor(String sdt, String firstname, String lastname, String sex, String DOB, String CCCD) async {
    setBusy(true);
    try{
      _user = await _authenticationService.infoinput(sdt, firstname, lastname, sex, DOB, CCCD);
      setBusy(false);
      if(_user['success'] == true) {
        return true;
      } else {
        _errorMessage = _user['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Register Failed: Exception occurred during input information';
      setBusy(false);
      return false;
    }
  }
}