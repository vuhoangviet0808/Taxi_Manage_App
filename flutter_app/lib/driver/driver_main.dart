import 'package:flutter/material.dart';
import 'src/models/driver.dart';
import 'src/services/driver_info_services.dart';
import 'src/views/homePage.dart';

class DriverPage extends StatelessWidget {
  final String sdt;
  DriverPage({Key? key, required this.sdt}) : super(key: key);
  final DriverInfoService _driverInfoService = DriverInfoService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Driver?>(
        future: _driverInfoService.getDriverInfo(sdt),
        builder: (context, driverSnapshot) {
          if (driverSnapshot.connectionState == ConnectionState.done) {
            if (driverSnapshot.hasError) {
              return Center(child: Text('Error: ${driverSnapshot.error}'));
            } else if (driverSnapshot.hasData) {
              return HomePage(driver: driverSnapshot.data!);
            } else {
              return Center(child: Text('No driver found'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
