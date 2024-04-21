import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user/viewmodels/user_view_model.dart';
import 'user/views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
        title: 'MVVM Demo',
        home: LoginPage(),
      ),
    );
  }
}
