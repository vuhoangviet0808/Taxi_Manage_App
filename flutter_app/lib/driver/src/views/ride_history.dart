// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/driver.dart';
import '../services/driver_info_services.dart';

class RideHistoryPage extends StatefulWidget {
  final int driverId;

  RideHistoryPage({required this.driverId});

  @override
  RideHistoryPageState createState() => RideHistoryPageState();
}

class RideHistoryPageState extends State<RideHistoryPage> {
  List<CabRide> _cabRides = [];
  List<CabRide> _filteredRides = [];
  String? _errorMessage;
  bool _isLoading = true;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    fetchCabRides();
  }

  String formatCurrency(double price) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(price);
  }

  Future<void> fetchCabRides() async {
    CabRideInfoService cabRideService = CabRideInfoService();
    try {
      List<CabRide> rides = await cabRideService.getCabRide(widget.driverId);
      for (var ride in rides) {
        print('Fetched ride price: ${ride.price}');
      }
      setState(() {
        _cabRides = rides;
        _filteredRides = rides;
        _errorMessage = rides.isEmpty ? "Chưa có chuyến đi nào" : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi khi lấy dữ liệu: $e";
        _isLoading = false;
      });
    }
  }

  void _filterRidesByDateRange(DateTimeRange dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
      _filteredRides = _cabRides.where((ride) {
        DateTime startTime = DateTime.parse(ride.ride_start_time);
        return startTime.isAfter(dateRange.start) &&
            startTime.isBefore(dateRange.end);
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null && picked != _selectedDateRange) {
      _filterRidesByDateRange(picked);
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
      _filteredRides = _cabRides;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử chuyến đi'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedDateRange != null
                          ? 'Từ ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} đến ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}'
                          : 'Chọn mốc thời gian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.date_range, color: Colors.blue),
                  onPressed: () => _selectDateRange(context),
                ),
                if (_selectedDateRange != null)
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearDateRange,
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredRides.length,
                        itemBuilder: (context, index) {
                          CabRide ride = _filteredRides[index];
                          DateTime startTime =
                              DateTime.parse(ride.ride_start_time);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy HH:mm:ss')
                                  .format(startTime);
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            elevation: 2,
                            child: ExpansionTile(
                              title: Text('Ngày và giờ: $formattedDate'),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildInfoRow('Thời gian bắt đầu:',
                                          '${ride.ride_start_time}'),
                                      buildInfoRow('Thời gian kết thúc:',
                                          '${ride.ride_end_time}'),
                                      buildInfoRow('Điểm bắt đầu:',
                                          '${ride.address_starting_point}',
                                          multiline: true),
                                      buildInfoRow('Điểm đến:',
                                          '${ride.address_destination}',
                                          multiline: true),
                                      buildInfoRow('Giá:',
                                          '${formatCurrency(ride.price)}'),
                                      buildInfoRow(
                                          'Đánh giá:', '${ride.evaluate}',
                                          multiline: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, String content, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: multiline ? null : 1,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
