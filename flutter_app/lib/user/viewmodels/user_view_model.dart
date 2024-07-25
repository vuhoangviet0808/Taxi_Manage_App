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

class CabRidesViewModel with ChangeNotifier {
  final CabRideInfoService _cabRideInfoService = CabRideInfoService();
  List<CabRide> _cabRides = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<CabRide> get cabRides => _cabRides;
  Future<void> fetchCabRides(int userID) async {
    _isLoading = true;
    notifyListeners();
    try {
      final cabRides = await _cabRideInfoService.getCabRide(userID);
      _cabRides = cabRides;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}