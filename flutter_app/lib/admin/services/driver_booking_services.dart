import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverBookingService {
  final String baseUrl = 'http://10.0.2.2:5000/admin/driver_booking';

  // Lấy danh sách các booking đã được phân công
  Future<List<Map<String, dynamic>>> fetchEarliestAssignedBookings() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load assigned bookings');
    }
  }

  // Cập nhật driver_id vào booking_request
  Future<bool> updateDriverId(int bookingId, int driverId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$bookingId/$driverId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true; // Hoặc có thể trả về response.body nếu cần
    } else {
      throw Exception('Failed to update driver id');
    }
  }

  // Xóa bản ghi booking_driver theo booking_id
  Future<bool> deleteBookingById(int bookingId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$bookingId'),
    );

    if (response.statusCode == 200) {
      return true; // Xóa thành công
    } else {
      throw Exception('Failed to delete booking');
    }
  }
}
