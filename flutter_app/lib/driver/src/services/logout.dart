import 'package:flutter/material.dart';
import 'package:flutter_app/common/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutService {
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    if (context.mounted) {
      // kiểm tra xem widget có còn được gắn vào cây widget hay không
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
