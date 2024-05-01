import 'package:flutter/material.dart';
import 'package:flutter_app/admin/views/views.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/services/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AdminDashboardView(
              viewModel: AdminDashboardViewModel(),
            ),
        '/report': (context) => ReportScreenView(),
      },
    );
  }
}
