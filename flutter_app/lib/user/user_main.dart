import 'package:flutter/material.dart';
import 'views/page/home_page.dart';
import 'models/user.dart';
import 'services/user_info_services.dart';

class UserPage extends StatelessWidget {
  final String sdt;

  UserPage({Key? key, required this.sdt}) : super(key: key);
  final UserInfoService _userInfoService = UserInfoService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<User?>(
        future: _userInfoService.getUserInfo(sdt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return HomePage(user: snapshot.data!);
            } else {
              return Center(child: Text('No user found'));
            }
          } else {
            // Đang tải dữ liệu, hiển thị indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
