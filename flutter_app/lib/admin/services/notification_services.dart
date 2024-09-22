import 'package:http/http.dart' as http;

class NotificationService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<void> sendDriverNotification(String bookingId) async {
    final url = Uri.parse(
        '$baseUrl/admin/drivers_in_bounding_box/$bookingId/insert_drivers');
    final response = await http.post(url);

    if (response.statusCode == 201) {
      print('Notification sent successfully.');
    } else {
      throw Exception('Failed to send notification');
    }
  }
}
