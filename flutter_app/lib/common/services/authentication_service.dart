import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';


class AuthenticationService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<Account?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if(response.statusCode == 200) {
        final Account account = Account.fromJson(jsonDecode(response.body));
        return account;
      } else {
        throw Exception('Failed to login. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}