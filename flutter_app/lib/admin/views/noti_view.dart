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
  int newBookingCount = 0;

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      fetchBookingRequests();
    });
  }

  Future<void> fetchBookingRequests() async {
    try {
      BookingRequestService service = BookingRequestService();
      List<BookingRequest> requests = await service.fetchBookingRequests();
      setState(() {
        bookingRequests = requests;
        isLoading = false;
        newBookingCount = requests.length;
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('New booking requests', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingRequests == null || bookingRequests!.isEmpty
              ? Center(child: Text('No booking request.'))
              : ListView.builder(
                  itemCount: bookingRequests!.length,
                  itemBuilder: (context, index) {
                    final booking = bookingRequests![index];
                    return Card(
                      child: ListTile(
                        title: Text('Booking ID: ${booking.booking_id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Requested time: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold), // In đậm đề mục
                            ),
                            Text(
                                '${booking.request_time}'), // Thông tin yêu cầu

                            Row(
                              children: [
                                Text(
                                  'Status: ',
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold), // In đậm đề mục
                                ),
                                Text(
                                  '${booking.status}',
                                  style: TextStyle(
                                      color:
                                          Colors.red), // Thay đổi màu thành đỏ
                                ), // Thông tin trạng thái
                              ],
                            ), // Thông tin trạng thái
                          ],
                        ),
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
                          child: Text('Detail',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
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
        title: Text('Detailed Booking Request',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : fullBookingRequest == null
              ? Center(child: Text('Booking Request not found.'))
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    color:
                        Color.fromARGB(255, 203, 235, 231), // Màu nền bên ngoài
                    padding: EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10), // Bo góc
                            border: Border.all(color: Colors.black), // Viền
                          ),
                          padding: EdgeInsets.all(
                              16), // Padding cho container bên trong
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Booking ID:',
                                  '${fullBookingRequest!.booking_id}'),
                              SizedBox(height: 8),
                              _buildDetailRow(
                                  'User ID:', '${fullBookingRequest!.user_id}'),
                              SizedBox(height: 8),
                              _buildDetailRow('Car type:',
                                  '${fullBookingRequest!.requested_car_type}'),
                              SizedBox(height: 8),
                              _buildDetailRow('Pick-up Location:',
                                  '${fullBookingRequest!.pickup_location}'),
                              SizedBox(height: 8),
                              _buildDetailRow('Drop-off Location:',
                                  '${fullBookingRequest!.dropoff_location}'),
                              SizedBox(height: 8),
                              _buildDetailRow(
                                  'Price:', '${fullBookingRequest!.price}'),
                              SizedBox(height: 8),
                              _buildDetailRow('Requested Time:',
                                  '${fullBookingRequest!.request_time}'),
                              SizedBox(height: 8),
                              _buildDetailRow(
                                  'Status:', '${fullBookingRequest!.status}'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              findDrivers();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Find driver',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (isDriverLoading)
                          Center(child: CircularProgressIndicator())
                        else if (drivers.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Màu nền trắng
                              borderRadius:
                                  BorderRadius.circular(10), // Bo góc container
                              border:
                                  Border.all(color: Colors.black), // Viền đen
                            ),
                            padding: EdgeInsets.all(
                                16), // Padding cho container bên trong
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Found ${drivers.length} drivers in the area!',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                          height: 8), // Khoảng cách giữa 2 dòng
                                      Text(
                                        'Ready to send notifications.',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment:
                                      Alignment.centerRight, // Căn lề phải
                                  child: SizedBox(
                                    width: 80, // Đặt kích thước cụ thể cho nút
                                    child: ElevatedButton(
                                      onPressed: sendNotification,
                                      child: Text(
                                        'Send', // Đổi từ 'Send to available drivers' thành 'Send'
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors
                                                .white), // Font size giống Find driver
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 9,
                                            102, 232), // Màu nền của button
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal:
                                                16), // Kích thước giống Find driver
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Center(
                            child: Text(
                              'Found 0 driver in the area.',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 8), // Khoảng cách giữa nhãn và giá trị
        Expanded(child: Text(value)),
      ],
    );
  }
}

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
        SnackBar(content: Text('Driver applied successfully!')),
      );
    } catch (e) {
      print('Error applying driver: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply driver.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status Update',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : assignedBookings == null || assignedBookings!.isEmpty
              ? Center(child: Text('No drivers available for the ride'))
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
                          child: Text('Apply',
                              style: TextStyle(color: Colors.white)),
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
