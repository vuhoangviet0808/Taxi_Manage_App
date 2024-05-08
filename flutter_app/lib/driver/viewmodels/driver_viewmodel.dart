import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../services/driver_info_services.dart';

class DriverViewModel with ChangeNotifier {
  final DriverUpdateService _driverService = DriverUpdateService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> updateDriverInfo(Driver driver) async {
    _isLoading = true;
    notifyListeners();
    final success = await _driverService.updateDriverInfo(driver);
    if (success) {
      print("Updated");
    } else {
      print("Updated failed in VM");
    }
    _isLoading = false;
    notifyListeners();
  }
}
