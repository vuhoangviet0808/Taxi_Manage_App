import 'package:flutter/material.dart';
import 'package:flutter_app/admin/services/Driver_services.dart';
import 'package:flutter_app/admin/models/models.dart';
import 'package:flutter_app/admin/services/booking_request_services.dart';
import 'package:flutter_app/admin/services/driver_booking_services.dart';
import 'package:flutter_app/admin/views/driver_report_view.dart';

class AdminDashboardViewModel {
  final AdminDashboardService service = AdminDashboardService();
  final BookingRequestService bookingService = BookingRequestService();
  final DriverBookingService driverBookingService = DriverBookingService();
  int totalBookingRequests = 0;
  int totalEarliestAssignedBooking = 0;

  Future<List<Driver>> fetchDrivers() async {
    return await service.fetchDrivers();
  }

  void fetchEachDriver(BuildContext context, String driverID) {
    service.fetchEachDriver(driverID).then((driver) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDetailScreen(driver: driver),
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content:
                Text('Không thể tải thông tin tài xế. Vui lòng thử lại sau.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<int> fetchTotalBookingRequests() async {
    try {
      totalBookingRequests = await bookingService.fetchTotalBookingRequests();
      return totalBookingRequests;
    } catch (error) {
      // Xử lý lỗi nếu cần thiết
      print('Error fetching total booking requests: $error');
      return 0;
    }
  }

  Future<int> fetchTotalEarliestAssignedBookings() async {
    try {
      totalEarliestAssignedBooking =
          await driverBookingService.fetchTotalAssignedBookings();
      return totalEarliestAssignedBooking;
    } catch (error) {
      // Xử lý lỗi nếu cần thiết
      print('Error fetching total assigned booking: $error');
      return 0;
    }
  }

  void logout() {}
}
