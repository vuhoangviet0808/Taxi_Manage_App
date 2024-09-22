import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/admin/models/booking_request_model.dart';
import 'package:flutter_app/admin/services/booking_request_services.dart';
import 'package:flutter_app/admin/services/driver_search_services.dart';
import 'package:flutter_app/admin/services/notification_services.dart';

/*
class NewBookingNotificationScreen extends StatefulWidget {
  @override
  _NewBookingNotificationScreenState createState() =>
      _NewBookingNotificationScreenState();
}

class _NewBookingNotificationScreenState
    extends State<NewBookingNotificationScreen> {
  List<BookingRequest>? bookingRequests;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
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
                            // Chuyển đến màn hình chi tiết yêu cầu đặt xe
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

*/
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

class TripStatusUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật trạng thái chuyến đi'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child:
            Text('Chi tiết cập nhật trạng thái chuyến đi sẽ hiển thị ở đây.'),
      ),
    );
  }
}
