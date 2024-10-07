import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_info_services.dart';
import 'package:latlong2/latlong.dart';


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

class BookingViewModel with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendBookingRequest({
    required int userId,
    required String requestedCarType,
    required String pickupAddress,
    required String dropoffAddress,
    required LatLng pickupLocation,
    required LatLng dropoffLocation,
    required double price, // Thêm biến price vào đây
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await _bookingService.sendBookingRequest(
      user_id: userId,
      requestedCarType: requestedCarType,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      price: price, // Truyền giá trị price vào đây
      
    );

    if (success) {
      print('Booking request sent successfully');
    } else {
      print('Failed to send booking request');
    }

    _isLoading = false;
    notifyListeners();
  }
}

class BookingInfoViewModel with ChangeNotifier {
  final BookingInfoService _bookingInfoService = BookingInfoService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _latestBookingID;
  int? get latestBookingID => _latestBookingID;

  Future<void> fetchLatestBookingID(int userID) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bookingID = await _bookingInfoService.getLatestBookingID(userID);
      _latestBookingID = bookingID;
      if (bookingID != null) {
        print('Latest booking ID for user $userID: $bookingID');
      } else {
        print('No booking found for the given user_id $userID');
      }
    } catch (e) {
      print('Error fetching latest booking ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


