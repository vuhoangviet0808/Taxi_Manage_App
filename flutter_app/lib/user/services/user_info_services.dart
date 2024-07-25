import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

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