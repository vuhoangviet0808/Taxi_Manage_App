import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/booking_request_model.dart';
import 'package:flutter_app/admin/services/booking_request_services.dart';
import 'package:flutter_app/admin/services/driver_search_services.dart';
import 'package:flutter_app/admin/services/notification_services.dart';

import 'package:flutter_app/admin/models/driver_booking_model.dart';
import 'package:flutter_app/admin/services/driver_booking_services.dart';

class NewBookingNotificationScreen extends StatefulWidget {
  @override
  _NewBookingNotificationScreenState createState() =>
      _NewBookingNotificationScreenState();
}

class _NewBookingNotificationScreenState
    extends State<NewBookingNotificationScreen> {
  List<BookingRequest>? bookingRequests;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
    _startPolling(); // Bắt đầu polling
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      fetchBookingRequests(); // Gọi hàm lấy dữ liệu mới mỗi 10 giây
    });
  }

  Future<void> fetchBookingRequests() async {
    try {
      BookingRequestService service = BookingRequestService();
      List<BookingRequest> requests = await service.fetchBookingRequests();
      setState(() {
        bookingRequests = requests;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching booking requests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo đặt xe mới'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingRequests == null || bookingRequests!.isEmpty
              ? Center(child: Text('Không có yêu cầu đặt xe nào.'))
              : ListView.builder(
                  itemCount: bookingRequests!.length,
                  itemBuilder: (context, index) {
                    final booking = bookingRequests![index];
                    return Card(
                      child: ListTile(
                        title: Text('Yêu cầu đặt xe: ${booking.booking_id}'),
                        subtitle:
                            Text('Vị trí đón: ${booking.pickup_location}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullBookingRequestDetailScreen(
                                        bookingId: booking.booking_id),
                              ),
                            );
                          },
                          child: Text('Chi tiết'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class FullBookingRequestDetailScreen extends StatefulWidget {
  final String bookingId;

  FullBookingRequestDetailScreen({required this.bookingId});

  @override
  _FullBookingRequestDetailScreenState createState() =>
      _FullBookingRequestDetailScreenState();
}

class _FullBookingRequestDetailScreenState
    extends State<FullBookingRequestDetailScreen> {
  FullBookingRequest? fullBookingRequest;
  bool isLoading = true;
  bool isDriverLoading = false;
  List<Map<String, dynamic>> drivers = [];

  @override
  void initState() {
    super.initState();
    fetchFullBookingRequest();
  }

  Future<void> fetchFullBookingRequest() async {
    try {
      BookingRequestService service = BookingRequestService();
      FullBookingRequest request =
          await service.fetchEachBookingRequest(widget.bookingId);
      setState(() {
        fullBookingRequest = request;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching full booking request: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> findDrivers() async {
    setState(() {
      isDriverLoading = true;
    });
    try {
      DriverSearchService driverService = DriverSearchService();
      List<Map<String, dynamic>> driverList =
          await driverService.fetchDriversForBookingRequest(widget.bookingId);
      setState(() {
        drivers = driverList;
        isDriverLoading = false;
      });
    } catch (e) {
      print('Error finding drivers: $e');
      setState(() {
        isDriverLoading = false;
      });
    }
  }

  Future<void> sendNotification() async {
    try {
      NotificationService notificationService = NotificationService();
      await notificationService.sendDriverNotification(widget.bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent successfully!')),
      );
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết yêu cầu đặt xe'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : fullBookingRequest == null
              ? Center(child: Text('Không tìm thấy chi tiết yêu cầu.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text('ID: ${fullBookingRequest!.booking_id}'),
                      SizedBox(height: 8),
                      Text('Người dùng: ${fullBookingRequest!.user_id}'),
                      SizedBox(height: 8),
                      Text(
                          'Loại xe yêu cầu: ${fullBookingRequest!.requested_car_type}'),
                      SizedBox(height: 8),
                      Text(
                          'Vị trí đón: ${fullBookingRequest!.pickup_location}'),
                      SizedBox(height: 8),
                      Text(
                          'Tọa độ đón: ${fullBookingRequest!.pickup_longitude}, ${fullBookingRequest!.pickup_latitude}'),
                      SizedBox(height: 8),
                      Text(
                          'Vị trí đến: ${fullBookingRequest!.dropoff_location}'),
                      SizedBox(height: 8),
                      Text(
                          'Tọa độ đến: ${fullBookingRequest!.destination_longitude}, ${fullBookingRequest!.destination_latitude}'),
                      SizedBox(height: 8),
                      Text('Giá: ${fullBookingRequest!.price}'),
                      SizedBox(height: 8),
                      Text(
                          'Thời gian yêu cầu: ${fullBookingRequest!.request_time}'),
                      SizedBox(height: 8),
                      Text('Trạng thái: ${fullBookingRequest!.status}'),
                      SizedBox(height: 8),
                      Text('ID tài xế: ${fullBookingRequest!.driver_id}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          findDrivers();
                        },
                        child: Text('Find driver'),
                      ),
                      if (isDriverLoading)
                        Center(child: CircularProgressIndicator())
                      else if (drivers.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Found ${drivers.length} drivers in the area'),
                            ElevatedButton(
                              onPressed: sendNotification,
                              child: Text('Send notification'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }
}

// class TripStatusUpdateScreen extends StatefulWidget {
//   @override
//   _TripStatusUpdateScreenState createState() => _TripStatusUpdateScreenState();
// }

// class _TripStatusUpdateScreenState extends State<TripStatusUpdateScreen> {
//   List<Map<String, dynamic>>? assignedBookings;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAssignedBookings();
//   }

//   Future<void> fetchAssignedBookings() async {
//     try {
//       DriverBookingService service = DriverBookingService();
//       List<Map<String, dynamic>> bookings =
//           await service.fetchEarliestAssignedBookings();
//       setState(() {
//         assignedBookings = bookings;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching assigned bookings: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> applyDriverToBooking(int bookingId, int driverId) async {
//     try {
//       DriverBookingService service = DriverBookingService();
//       await service.updateDriverId(bookingId, driverId);
//       // Cập nhật lại danh sách bookings sau khi apply thành công
//       fetchAssignedBookings();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Driver applied successfully!')),
//       );
//     } catch (e) {
//       print('Error applying driver: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to apply driver.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cập nhật trạng thái chuyến đi'),
//         backgroundColor: Colors.teal,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : assignedBookings == null || assignedBookings!.isEmpty
//               ? Center(child: Text('Không có booking nào được phân công.'))
//               : ListView.builder(
//                   itemCount: assignedBookings!.length,
//                   itemBuilder: (context, index) {
//                     final booking = assignedBookings![index];
//                     return Card(
//                       child: ListTile(
//                         title: Text('Booking ID: ${booking['booking_id']}'),
//                         subtitle: Text('Driver ID: ${booking['driver_id']}'),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             // Gọi hàm để apply driver_id vào booking request
//                             applyDriverToBooking(
//                                 booking['booking_id'], booking['driver_id']);
//                           },
//                           child: Text('Apply'),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
class TripStatusUpdateScreen extends StatefulWidget {
  @override
  _TripStatusUpdateScreenState createState() => _TripStatusUpdateScreenState();
}

class _TripStatusUpdateScreenState extends State<TripStatusUpdateScreen> {
  List<Map<String, dynamic>>? assignedBookings;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAssignedBookings();
  }

  Future<void> fetchAssignedBookings() async {
    try {
      DriverBookingService service = DriverBookingService();
      List<Map<String, dynamic>> bookings =
          await service.fetchEarliestAssignedBookings();
      setState(() {
        assignedBookings = bookings;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching assigned bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> applyDriverToBooking(int bookingId, int driverId) async {
    try {
      DriverBookingService service = DriverBookingService();

      // Cập nhật driver_id vào booking_request
      await service.updateDriverId(bookingId, driverId);

      // Sau khi cập nhật thành công, gọi API để xóa bản ghi
      await service.deleteBookingById(bookingId);

      // Xóa bản ghi đã được apply thành công khỏi danh sách

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Driver applied and booking deleted successfully!')),
      );
    } catch (e) {
      print('Error applying driver: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply driver or delete booking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật trạng thái chuyến đi'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : assignedBookings == null || assignedBookings!.isEmpty
              ? Center(child: Text('Không có booking nào được phân công.'))
              : ListView.builder(
                  itemCount: assignedBookings!.length,
                  itemBuilder: (context, index) {
                    final booking = assignedBookings![index];
                    return Card(
                      child: ListTile(
                        title: Text('Booking ID: ${booking['booking_id']}'),
                        subtitle: Text('Driver ID: ${booking['driver_id']}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Gọi hàm để apply driver_id vào booking request và xóa bản ghi
                            applyDriverToBooking(
                                booking['booking_id'], booking['driver_id']);
                          },
                          child: Text('Apply'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
