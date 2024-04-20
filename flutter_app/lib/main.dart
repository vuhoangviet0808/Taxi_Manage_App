import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_view_model.dart';
import 'views/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Tạo ViewModel cho người dùng
      create: (context) => UserViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage()
        },
      ),
    );
  }
}
