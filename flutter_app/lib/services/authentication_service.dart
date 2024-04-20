import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthenticationService {
  final String baseUrl = 'http://10.0.2.2:5000/login';

  Future<String> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': user.username,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['message'];
      } else {
        return json.decode(response.body)['message'];
      }
    } catch (e) {
      return 'Failed to connect to the server';
    }
  }
}
