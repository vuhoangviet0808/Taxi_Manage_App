import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthenticationService {
  final String baseUrl = 'http://10.0.2.2:5000/login';

  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password':password,
        }),
      );

      if(response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception('Failed to login. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<User?> signUp(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: <String, String> {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if(response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception('Failed to sign up. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

}