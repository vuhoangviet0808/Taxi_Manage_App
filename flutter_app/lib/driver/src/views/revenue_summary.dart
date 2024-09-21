// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/driver.dart';
import '../services/driver_info_services.dart';

class DailyRevenueSummary extends StatefulWidget {
  final int driverId;

  DailyRevenueSummary({required this.driverId});

  @override
  DailyRevenueSummaryState createState() => DailyRevenueSummaryState();
}

class DailyRevenueSummaryState extends State<DailyRevenueSummary> {
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
        _errorMessage = rides.isEmpty ? "Chưa có doanh thu nào!" : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi khi lấy dữ liệu: $e";
        _isLoading = false;
      });
    }

    if (_errorMessage != null) {
      _showErrorDialog();
    }
  }

  DateTime _parseDateTime(String dateTimeStr) {
    try {
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      throw FormatException("Invalid date format", dateTimeStr);
    }
  }

  void _filterRidesByDateRange(DateTimeRange dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
      _filteredRides = _cabRides.where((ride) {
        DateTime startTime = _parseDateTime(ride.ride_start_time);
        return startTime.isAfter(dateRange.start) &&
            startTime.isBefore(dateRange.end);
      }).toList();
      if (_filteredRides.isEmpty) {
        _errorMessage = "Chưa có doanh thu nào!";
        _showErrorDialog();
      } else {
        _errorMessage = null;
      }
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CabRide> filteredRides = _selectedDateRange == null
        ? _cabRides
        : _cabRides.where((ride) {
            DateTime rideStartTime = _parseDateTime(ride.ride_start_time);
            return rideStartTime.isAfter(
                    _selectedDateRange!.start.subtract(Duration(days: 1))) &&
                rideStartTime
                    .isBefore(_selectedDateRange!.end.add(Duration(days: 1)));
          }).toList();

    double totalRevenue = filteredRides.fold(
      0,
      (sum, ride) => sum + ride.price,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Tổng hợp doanh thu'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tổng doanh thu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatCurrency(totalRevenue),
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredRides.length,
                      itemBuilder: (context, index) {
                        final ride = filteredRides[index];
                        DateTime rideStartTime =
                            _parseDateTime(ride.ride_start_time);
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading:
                                Icon(Icons.attach_money, color: Colors.green),
                            title: Text(
                              'Ngày: ${DateFormat('dd-MM-yyyy').format(rideStartTime)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Doanh thu: ${formatCurrency(totalRevenue)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
