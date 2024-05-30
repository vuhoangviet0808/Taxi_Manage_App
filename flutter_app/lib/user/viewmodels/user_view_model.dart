import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_info_services.dart';

class UserViewModel with ChangeNotifier {
  final UserUpdateService _userService = UserUpdateService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> updateUSerInfo(User user) async {
    _isLoading = true;
    notifyListeners();
    final success = await _userService.updateUserInfo(user);
    if (success) {
      print("Updated");
    } else {
      print("Updated failed in VM");
    }
    _isLoading = false;
    notifyListeners();
  }
}