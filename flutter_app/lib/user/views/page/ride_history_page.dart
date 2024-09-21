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
        _errorMessage = rides.isEmpty ? "Không có dữ liệu chuyến đi" : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi khi lấy dữ liệu: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử chuyến đi'),
        backgroundColor: Colors.white,
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
                      elevation: 2, // Thêm hiệu ứng shadow
                      child: ExpansionTile(
                        title: Text('Chuyến đi ${index + 1}'),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Đảm bảo căn trái
                              children: [
                                buildInfoRow('Thời gian bắt đầu:',
                                    '${ride.ride_start_time}'),
                                buildInfoRow('Thời gian kết thúc:',
                                    '${ride.ride_end_time}'),
                                buildInfoRow('Điểm bắt đầu:',
                                    '${ride.address_starting_point}',
                                    multiline: true),
                                buildInfoRow(
                                    'Điểm đến:', '${ride.address_destination}',
                                    multiline: true),
                                buildInfoRow('Giá:', '${ride.price} \$'),
                                buildInfoRow('Đánh giá:', '${ride.evaluate}',
                                    multiline: true),
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
              color: Colors.blue,
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
