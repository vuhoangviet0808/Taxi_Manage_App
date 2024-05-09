import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';


class AuthenticationService {
  final String baseUrl = 'http://10.0.2.2:5000';

  Future<Map<String, dynamic>> login(String sdt, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'SDT': sdt,
          'password': password,
        }),
      );

      if(response.statusCode == 200) {
        final Account account = Account.fromJson(jsonDecode(response.body));
        return {'success': true, 'account': account};
      } else {
        return {'success': false, 'account': 'Login Failed: Invalid SDT or password'};
      }
    } catch (e) {
      return {'success': false, 'account': 'Login Failed: Exception occurred during login'};
    }
  }

  Future<Map<String, dynamic>> register(String sdt, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String> {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'SDT': sdt,
          'password': password,
        }),
      );
      if(response.statusCode == 200) {
        return {'success': true, 'message': sdt};
      } else {
        return {'success': false, 'message': 'Register failed: The phone number is incorrect or already in use'};
      }
    } catch (e) {
      return {'sccess': false, 'message':'Exception occurred during registration' };
    }
  }
  
}