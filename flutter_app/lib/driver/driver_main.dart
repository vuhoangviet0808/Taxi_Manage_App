import 'package:flutter/material.dart';
import 'services/driver_info_services.dart';
import 'src/views/homePage.dart';
import 'models/driver.dart';


class DriverPage extends StatelessWidget {
  final String sdt;
  DriverPage({Key? key,required this.sdt}) : super(key: key);
  final DriverInfoService _driverInfoService = DriverInfoService();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Driver?>(
        future: _driverInfoService.getDriverInfo(sdt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return HomePage(driver: snapshot.data!);
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
