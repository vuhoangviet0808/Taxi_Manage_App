import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserInfoService {
  final String baseUrl = 'http://10.0.2.2:5000';

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