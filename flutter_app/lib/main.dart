// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/viewmodels/account_login_view_model.dart';
import 'common/views/login_page.dart';
import 'user/user_main.dart';
import 'admin/admin_main.dart';

void main() {
  runApp(AdminPage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountLoginViewModel(),
      child: MaterialApp(
        title: 'MVVM Demo',
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
