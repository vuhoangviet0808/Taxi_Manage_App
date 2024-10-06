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
      if (response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception(
            'Failed to get information. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}

class UserUpdateService {
  Future<bool> updateUserInfo(User user) async {
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

  // Hàm lấy thông tin chuyến đi dựa trên driver_id
  Future<CabRide?> getCabRideByDriverId(int driverID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getCabRideByDriverId?driver_id=$driverID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CabRide.fromJson(data); // Chuyển đổi từ JSON sang CabRide
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Failed to get cab ride by driver ID. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cab ride by driver ID: $e');
    }
  }

  // Hàm cập nhật evaluate dựa trên cab_ride_id
  Future<bool> updateCabRideEvaluate({
    required int cabRideId,
    required double evaluate,
  }) async {
    final url = Uri.parse('$baseUrl/user/updateCabRideEvaluate');

    // Chuẩn bị dữ liệu cần gửi
    final Map<String, dynamic> requestData = {
      'cab_ride_id': cabRideId,
      'evaluate': evaluate,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData), // Gửi dữ liệu dưới dạng JSON
      );

      if (response.statusCode == 200) {
        print('Evaluate updated successfully');
        return true;
      } else {
        print('Failed to update evaluate: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating evaluate: $e');
      return false;
    }
  }

  // Hàm lấy thông tin xe (cab) dựa trên driver_id
  Future<Cab?> getCabByDriverId(int driverID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getCabByDriverId?driver_id=$driverID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Cab.fromJson(data); // Chuyển đổi từ JSON sang Cab
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get cab by driver ID. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cab by driver ID: $e');
    }
  }

  // Hàm lấy thông tin tài xế dựa trên driver_id
  Future<Driver?> getDriverById(int driverID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getDriverById?driver_id=$driverID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Driver.fromJson(data); // Chuyển đổi từ JSON sang Driver
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get driver by ID. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching driver by ID: $e');
    }
  }

  // Hàm lấy thông tin đánh giá dựa trên driver_id
Future<double?> getEvaluateByDriverId(int driverID) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/user/getEvaluateByDriverId?driver_id=$driverID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return double.parse(data['evaluate']); // Sử dụng double.parse() để chuyển đổi từ chuỗi sang double
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get evaluate by driver ID. Error code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching evaluate by driver ID: $e');
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
  // Hàm hủy chuyến đi dựa trên user_id
  Future<bool> cancelLatestBooking(int userID) async {
    final url = Uri.parse('$baseUrl/user/cancelLatestBooking');

    // Chuẩn bị dữ liệu cần gửi
    final requestData = {
      'user_id': userID,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData), // Gửi dữ liệu dưới dạng JSON
      );

      if (response.statusCode == 200) {
        print('Latest booking cancelled successfully');
        return true;
      } else {
        print('Failed to cancel latest booking: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error cancelling latest booking: $e');
      return false;
    }
  }
}

class BookingInfoService {
  // Hàm gọi API để lấy booking_id mới nhất
  Future<int?> getLatestBookingID(int userID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getLatestBookingId?user_id=$userID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['latest_booking_id'];
      } else if (response.statusCode == 404) {
        print('No booking found for the given user_id');
        return null;
      } else {
        throw Exception('Failed to get latest booking ID. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching latest booking ID: $e');
      return null;
    }
  }

  // Hàm gọi API để lấy driver_id dựa trên booking_id mới nhất
  Future<int?> getDriverIdByLatestBooking(int bookingID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getDriverIdByLatestBooking?booking_id=$bookingID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['driver_id'];
      } else if (response.statusCode == 404) {
        print('No driver found for the given booking_id');
        return null;
      } else {
        throw Exception('Failed to get driver ID. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching driver ID by latest booking: $e');
      return null;
    }
  }
}
