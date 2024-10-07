import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_info_services.dart';

class RideHistoryPage extends StatefulWidget {
  final int userID;
  RideHistoryPage({required this.userID});

  @override
  RideHistoryPageState createState() => RideHistoryPageState();
}

class RideHistoryPageState extends State<RideHistoryPage> {
  List<CabRide> _cabRides = [];
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCabRides();
  }

  Future<void> fetchCabRides() async {
    CabRideInfoService cabRideService = CabRideInfoService();
    try {
      List<CabRide> rides = await cabRideService.getCabRide(widget.userID);
      setState(() {
        _cabRides = rides;
        _errorMessage = rides.isEmpty ? "No ride history available" : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error retrieving data: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ride History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black, // Đổi màu tiêu đề thành đen
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        backgroundColor: Colors.transparent, // Không có màu nền
        elevation: 0, // Loại bỏ hiệu ứng đổ bóng
        iconTheme: IconThemeData(color: Colors.black), // Đổi màu icon về đen
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                        fontFamily: "Roboto", fontSize: 20, color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: _cabRides.length,
                  itemBuilder: (context, index) {
                    CabRide ride = _cabRides[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 4, // Thêm hiệu ứng shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.local_taxi,
                          color: Colors.teal,
                          size: 30,
                        ), // Biểu tượng taxi
                        title: Text(
                          'Ride ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.teal,
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn trái
                              children: [
                                buildInfoRow('Start time:', '${ride.ride_start_time}'),
                                buildInfoRow('End time:', '${ride.ride_end_time}'),
                                buildInfoRow('Starting point:', '${ride.address_starting_point}', multiline: true),
                                buildInfoRow('Destination:', '${ride.address_destination}', multiline: true),
                                buildInfoRow('Price:', '\$${ride.price}'),
                                buildInfoRow('Rating:', '${ride.evaluate}', multiline: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget buildInfoRow(String title, String content, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn trái
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.teal, // Đổi màu chữ thành teal
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: multiline ? null : 1,
            ),
          ),
        ],
      ),
    );
  }
}
