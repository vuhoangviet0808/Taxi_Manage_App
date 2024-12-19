import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/driver.dart';

const String baseUrl = 'http://10.0.2.2:5000';

class DriverInfoService {
  Future<Driver?> getDriverInfo(String sdt) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getinfo?phone=$sdt'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Driver driver = Driver.fromJson(jsonDecode(response.body));
        return driver;
      } else {
        throw Exception(
            'Failed to get information. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

class DriverUpdateService {
  Future<bool> updateDriverInfo(Driver driver) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/driver/update_driver_infor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(driver.toJson()));
      print('Received response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        print("Update Success");
        return true;
      } else {
        print("Failed");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class CabRideInfoService {
  Future<List<CabRide>> getCabRide(int driverID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/getCabRide?driver_id=$driverID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => CabRide.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Failed to get information. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

class LocationServices {
  Future<void> postLocation(int driverID, LatLng position) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/driver/postLocation'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'driver_id': driverID,
          'longitude': position.longitude,
          'latitude': position.latitude,
        }),
      );
      print('Received response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        print('Location posted successfully!');
      } else {
        print("Location posted failed: Error code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> clearPostion(int driverId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/driver/clearLocation?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to clear location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error clearing location: $e');
    }
  }
}

class BookingDriverService {
  Future<List<BookingDriver>> getPendingBookingReq(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/driver/listRequest?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingDriver.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load pending booking request. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pending bookings: $e');
    }
  }

  Future<void> acceptBooking(int bookingId, int driverId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/driver/accept_booking'), // Đây là route bạn cần khớp với backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'booking_id': bookingId,
          'driver_id': driverId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to accept booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error accepting booking: $e');
    }
  }
}
