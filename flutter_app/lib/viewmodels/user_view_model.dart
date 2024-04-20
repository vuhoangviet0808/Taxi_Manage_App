import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/authentication_service.dart';

class UserViewModel extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();

  String _message = '';
  String get message => _message;

  Future<void> login(String username, String password) async {
    var user = User(username: username, password: password);
    var result = await _authService.login(user);
    _message = result;
    notifyListeners();
  }
}
