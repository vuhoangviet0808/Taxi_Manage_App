import 'package:flutter/material.dart';
import '../../services/user_info_services.dart';
import '../page/home_page.dart';  // Import CabRideInfoService
import '../../models/user.dart';

class RatingScreen extends StatefulWidget {
  final double totalDistance;
  final int cabRideId;
  final User user;

  RatingScreen({required this.totalDistance, required this.cabRideId, required this.user});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0.0;
  final CabRideInfoService _cabRideInfoService = CabRideInfoService();  // Tạo instance của service

  // Hàm tính cước phí dựa trên công thức bạn cung cấp
  int calculateTotalFare(double distance) {
    // Nhân quãng đường với 8000 để tính giá tiền ban đầu
    double totalPrice = distance * 8000;

    // Làm tròn giá tiền lên hàng nghìn
    int roundedPrice = ((totalPrice + 999) ~/ 1000) * 1000;

    return roundedPrice;
  }

  // Hàm gọi service updateCabRideEvaluate
  Future<void> _submitRating(double rating) async {
    try {
      bool success = await _cabRideInfoService.updateCabRideEvaluate(
        cabRideId: widget.cabRideId,
        evaluate: rating,
      );
      if (success) {
        print('Rating updated successfully');
      } else {
        print('Failed to update rating');
      }
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng hàm calculateTotalFare đã sửa đổi
    int totalFare = calculateTotalFare(widget.totalDistance);

    return Scaffold(
      appBar: AppBar(
        title: Center( // Căn giữa tiêu đề
          child: Text(
            'Rate Your Ride',
            style: TextStyle(fontWeight: FontWeight.bold), // In đậm tiêu đề
          ),
        ),
        automaticallyImplyLeading: false, // Tắt nút back
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Biểu tượng taxi thay thế khuôn mặt
            Icon(
              Icons.local_taxi,
              size: 80,
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            Text(
              'How was your ride?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Help us improve our service by providing your feedback.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Thanh đánh giá sao
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                // Hiển thị nửa sao nếu rating không tròn
                IconData icon;
                if (_rating >= index + 1) {
                  icon = Icons.star;
                } else if (_rating >= index + 0.5) {
                  icon = Icons.star_half;
                } else {
                  icon = Icons.star_border;
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                    _submitRating(_rating); // Gửi đánh giá lên server khi chọn sao
                  },
                  onDoubleTap: () {
                    setState(() {
                      _rating = index + 0.5; // Chọn nửa sao khi double tap
                    });
                    _submitRating(_rating); // Gửi đánh giá lên server
                  },
                  child: Icon(
                    icon,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            SizedBox(height: 24),

            // Hiển thị tổng quãng đường
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Distance',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '${widget.totalDistance.toStringAsFixed(2)} km',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Hiển thị tổng cước phí
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Fare',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'VND $totalFare', // Hiển thị tổng cước phí đã làm tròn
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Nút "Complete Ride"
            ElevatedButton(
              onPressed: () {
                // Điều hướng về trang HomePage mà không cần truyền user
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: widget.user),  // Không cần truyền user
                  ),
                  (Route<dynamic> route) => false,  // Xóa tất cả các trang trước đó
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Màu nền teal
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Center(
                child: Text(
                  "Complete Ride",
                  style: TextStyle(color: Colors.white), // Màu chữ trắng
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
