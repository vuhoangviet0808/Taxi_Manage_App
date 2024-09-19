import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:latlong2/latlong.dart';

const String baseUrl = 'http://10.0.2.2:5000';

class UserInfoService {
  Future<User?> getUserInfo(String sdt) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getinfo?phone=$sdt'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception('Failed to get information. Error code: ${response.statusCode}');
      }

    } catch (e) {
      throw Exception('$e');
    }
  }
}
class UserUpdateService {
  Future<bool> updateUserInfo(User user) async{
    try {
      print("Sending data: ${user.toJson()}");
      final response = await http.post(
         Uri.parse('$baseUrl/user/update_user_infor'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(user.toJson()));
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
  Future<List<CabRide>> getCabRide(int userID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getCabRide?user_id=$userID'),
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

class BookingService {
  Future<bool> sendBookingRequest({
    required int user_id,
    required String requestedCarType,
    required String pickupAddress,
    required String dropoffAddress,
    required LatLng pickupLocation,
    required LatLng dropoffLocation,
    required double price, // Thêm biến price
  }) async {
    final url = Uri.parse('$baseUrl/user/sendBookingRequest');

    // Chuẩn bị dữ liệu cần gửi
    final requestData = {
      'user_id': user_id,
      'requested_car_type': requestedCarType,
      'pickup_location': pickupAddress,
      'dropoff_location': dropoffAddress,
      'gps_pickup_location': {
        'latitude': pickupLocation.latitude,
        'longitude': pickupLocation.longitude,
      },
      'gps_destination_location': {
        'latitude': dropoffLocation.latitude,
        'longitude': dropoffLocation.longitude,
      },
      'price': price, // Thêm price vào dữ liệu
    };

    // In ra JSON để kiểm tra cấu trúc trước khi gửi
    print('Request Data: ${json.encode(requestData)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData), // Gửi dữ liệu dưới dạng JSON
      );

      if (response.statusCode == 200) {
        print('Booking request sent successfully');
        return true;
      } else {
        print('Failed to send booking request: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending booking request: $e');
      return false;
    }
  }
}
