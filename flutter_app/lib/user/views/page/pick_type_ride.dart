import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/user_info_services.dart'; // Import service mới
import '../../models/user.dart';
import '../../viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';
import 'waitting_cab.dart'; // Import trang WaitingCab

class PickTypeRide extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupAddress; // Địa chỉ đón
  final String destinationAddress; // Địa chỉ đến
  final User user;

  PickTypeRide({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.user,
  });

  @override
  State<PickTypeRide> createState() => _PickTypeRideState();
}

class _PickTypeRideState extends State<PickTypeRide> {
  late LatLng _initialLocation;
  MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  double _heading = 0.0;
  double _totalDistance = 0.0;
  double _totalPrice = 0.0; // Biến để lưu trữ giá tiền
  String? _selectedCarType; // Biến lưu loại xe được chọn
  final BookingService bookingService = BookingService(); // Khởi tạo service

  void getLocation() async {
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_initialLocation, 15.0);
    } catch (e) {
      print("Lỗi khi lấy vị trí: $e");
    }
  }

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248d8a744a453db40818a2f60624aebb033&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        _totalDistance = data['features'][0]['properties']['segments'][0]
                ['distance'] /
            1000.0;
        // Tính giá tiền dựa trên quãng đường, với giá 8000 VND cho mỗi km
        _totalPrice = _totalDistance * 800;
        // Làm tròn lên hàng nghìn
        _totalPrice = ((_totalPrice + 999) ~/ 1000) * 1000;
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  Future<void> _sendBookingRequest() async {
    if (_selectedCarType == null) {
      print("Chưa chọn loại xe");
      return;
    }

    try {
      // Gửi yêu cầu đặt xe
      await bookingService.sendBookingRequest(
        user_id: widget.user.User_ID,
        requestedCarType: _selectedCarType!,
        pickupAddress: widget.pickupAddress,
        dropoffAddress: widget.destinationAddress,
        pickupLocation: widget.pickupLocation,
        dropoffLocation: widget.destinationLocation,
        price: _totalPrice, // Gửi giá tiền
      );

      // Điều hướng sang trang WaitingCab sau khi gửi yêu cầu thành công
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingCab(
            pickupLocation: widget.pickupLocation,
            destinationLocation: widget.destinationLocation,
            pickupAddress: widget.pickupAddress,
            destinationAddress: widget.destinationAddress,
          ),
        ),
      );
    } catch (error) {
      print('Error during booking request: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _initialLocation = widget.pickupLocation;
    _fetchRoute(widget.pickupLocation, widget.destinationLocation);
  }

  void zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _initialLocation,
              zoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Quãng đường: ${_totalDistance.toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Giá tiền: ${_totalPrice.toStringAsFixed(0)} VND',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: zoomIn,
                  mini: true,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: zoomOut,
                  mini: true,
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Chọn loại xe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildOptionItem(
                  context,
                  title: "Taxi 4 chỗ",
                  icon: Icons.directions_car,
                  isSelected: _selectedCarType == '4_seat',
                  onTap: () {
                    setState(() {
                      _selectedCarType = '4_seat';
                    });
                  },
                ),
                _buildOptionItem(
                  context,
                  title: "Taxi 6 chỗ",
                  icon: Icons.local_taxi,
                  isSelected: _selectedCarType == '6_seat',
                  onTap: () {
                    setState(() {
                      _selectedCarType = '6_seat';
                    });
                  },
                ),
                _buildOptionItem(
                  context,
                  title: "Đặt xe",
                  icon: Icons.check_circle,
                  isSelected: false,
                  onTap: () {
                    _sendBookingRequest(); // Gọi hàm gửi yêu cầu đặt xe
                  },
                  isBookingButton: true, // Thêm cờ để xác định nút Đặt xe
                ),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 240,
            maxHeight: 400,
            body: Container(),
          ),
        ],
      ),
    );
  }
}

Widget _buildOptionItem(BuildContext context,
    {required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isBookingButton = false}) { // Thêm cờ isBookingButton để tùy chỉnh nút Đặt xe
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isBookingButton ? Colors.teal : Colors.white, // Nền teal cho nút Đặt xe
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 1), // Viền màu teal
      ),
      child: Row(
        mainAxisAlignment: isBookingButton ? MainAxisAlignment.center : MainAxisAlignment.start, // Căn giữa cho nút Đặt xe
        children: [
          Icon(icon, color: isBookingButton ? Colors.white : Colors.teal, size: 24),
          SizedBox(width: isBookingButton ? 0 : 12), // Xóa khoảng trống cho nút Đặt xe
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isBookingButton ? Colors.white : Colors.black, // Màu chữ trắng cho nút Đặt xe
            ),
          ),
        ],
      ),
    ),
  );
}
