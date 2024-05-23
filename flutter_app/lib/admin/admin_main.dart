import 'package:flutter/material.dart';
import 'package:flutter_app/admin/views/views.dart';
import 'package:flutter_app/admin/viewmodels/viewmodels.dart';
import 'package:flutter_app/admin/services/cab_ride_services.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cabRideService = CabRideService();
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AdminDashboardView(
              viewModel: AdminDashboardViewModel(cabRideService),
            ),
      },
    );
  }
}
