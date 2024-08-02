// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/admin/models/user_model.dart';

class UserService {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/users'));
    if (response.statusCode == 200) {
      List<dynamic> usersData = json.decode(response.body);
      List<User> user_info = [];
      for (var userData in usersData) {
        if (userData['Firstname'] != null &&
            userData["Lastname"] != null &&
            userData['User_ID'] != null) {
          String userID = userData['User_ID'].toString();
          user_info
              .add(User(userData['Firstname'], userData['Lastname'], userID));
        } else {
          print('Null data received for an user.');
        }
      }
      return user_info;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<FullUser> fetchEachUser(String userID) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/admin/users/$userID'));

    if (response.statusCode == 200) {
      dynamic responseBody = json.decode(response.body);

      if (responseBody is List) {
        // If the response body is a list, take the first item
        if (responseBody.isNotEmpty) {
          responseBody = responseBody.first;
        } else {
          print('Empty list received for the user with ID: $userID');
          throw Exception('Empty list received for the user');
        }
      }

      if (responseBody is Map<String, dynamic>) {
        // Proceed with decoding the response body
        if (responseBody['User_ID'] != null) {
          String userID = responseBody['User_ID'].toString();
          String userWallet = responseBody['Wallet'].toString();

          return FullUser(
              responseBody['Firstname'],
              responseBody['Lastname'],
              userID,
              responseBody['SDT'],
              userWallet,
              responseBody['DOB'],
              responseBody['Gender'],
              responseBody['Address'],
              responseBody['CCCD'],
              responseBody['created_at']);
        } else {
          print('Null data received for the user with ID: $userID');
          throw Exception('Null data received for the user');
        }
      } else {
        print('Invalid data type received for the user with ID: $userID');
        throw Exception('Invalid data type received for the user');
      }
    } else {
      throw Exception('Failed to load user with ID: $userID');
    }
  }
}
