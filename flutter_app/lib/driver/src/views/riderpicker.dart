// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import '../models/driver.dart';
import '../services/driver_info_services.dart';
import 'homepage.dart';
import 'trip_infor_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiderPicker extends StatefulWidget {
  final Driver driver;
  RiderPicker({required this.driver});

  @override
  State<RiderPicker> createState() => _RiderPickerState();
}

class _RiderPickerState extends State<RiderPicker> {
  late LatLng _initialLocation = LatLng(0, 0);
  MapController _mapController = MapController();
  TextEditingController _pickupLocationController = TextEditingController();
  TextEditingController _destinationLocationController =
      TextEditingController();
  List<Marker> _markers = [];
  List<LatLng> _routePoints = [];
  double _heading = 0.0;
  double _totalDistance = 0.0; // Thêm biến này để lưu trữ khoảng cách
  Marker? _currentLocationMarker;
  Marker? _pickupMarker;
  Marker? _destinationMarker;
  bool _isExpanded = false;
  List<BookingDriver> _pendingBookings = [];
  BookingDriver? _selectedBooking;
  Timer? _timer; // dừng khi widget đóng

  final LocationServices _clearLocationService = LocationServices();
  final BookingDriverService _bookingDriverService = BookingDriverService();

  void getLocation() async {
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
        _currentLocationMarker = _createMarker();
        _updateMarkers();
      });
      _mapController.move(_initialLocation, 15.0);
    } catch (e) {
      print("Lỗi khi lấy vị trí: $e");
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      if (_currentLocationMarker != null) _markers.add(_currentLocationMarker!);
      if (_pickupMarker != null) _markers.add(_pickupMarker!);
      if (_destinationMarker != null) _markers.add(_destinationMarker!);
    });
  }

  Marker _createMarker() {
    return Marker(
      point: _initialLocation,
      builder: (ctx) => Transform.rotate(
        angle: _heading * (3.1415927 / 180), // Convert degrees to radians
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: 25,
          height: 25,
          child: Image.asset(
            'assets/driver/icons8-taxi-48.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void _updateHeading(Position position) {
    setState(() {
      _heading = position.heading;
      _currentLocationMarker = _createMarker();
      _updateMarkers();
    });
  }

  void focusOnCurrentLocation() {
    if (_currentLocationMarker != null) {
      _mapController.move(
          _initialLocation, 15.0); // Di chuyển đến vị trí hiện tại
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
            1000.0; // Đơn vị: km
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  Future<void> fetchPendingBookings() async {
    try {
      List<BookingDriver> bookings = await _bookingDriverService
          .getPendingBookingReq(widget.driver.Driver_ID);
      print("Bookings fetched: ${bookings.length}");
      setState(() {
        _pendingBookings = bookings;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  void _onLocationsChanged(LatLng pickupLatLng, LatLng destinationLatLng) {
    _fetchRoute(pickupLatLng, destinationLatLng);
    setState(() {
      _pickupMarker = Marker(
        point: pickupLatLng,
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.green,
          size: 40,
        ),
      );
      _destinationMarker = Marker(
        point: destinationLatLng,
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
      );
      _updateMarkers();
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    fetchPendingBookings();
    _timer = Timer.periodic(Duration(seconds: 120), (timer) {
      fetchPendingBookings();
    });
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _updateHeading(position);
    }, onError: (error) {
      print("Lỗi khi lắng nghe vị trí: $error");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateLocation() async {
    await _clearLocationService.clearPostion(widget.driver.Driver_ID);
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(driver: widget.driver)));
    }
  }

  void clearRouteMarkers() {
    setState(() {
      _routePoints.clear(); // Xóa các điểm chỉ đường
      _pickupMarker = null; // Xóa điểm đón
      _destinationMarker = null; // Xóa điểm trả
      _updateMarkers(); // Cập nhật lại markers trên bản đồ
    });
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Trip Selected"),
          content: Text("Are you sure you want to cancel this trip?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pickupLocationController.clear();
                  _destinationLocationController.clear();
                  clearRouteMarkers();
                  _selectedBooking = null; // Hủy chọn chuyến đi
                });
                Navigator.pop(context); // Đóng dialog
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void showBookingsList() async {
    await fetchPendingBookings();
    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: _pendingBookings.isEmpty
                    ? Center(
                        child: Text(
                          'No Trips Available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _pendingBookings.length,
                        itemBuilder: (context, index) {
                          final booking = _pendingBookings[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.blueGrey.shade50, // Alternate colors
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.blueAccent, // Border color
                                width: 2, // Border thickness
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'From:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          booking.pickupLocation,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          booking.dropoffLocation,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey[300]),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text(
                                        'Phone: ${booking.userPhone}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text(
                                        'Price: ${booking.price} VNĐ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _selectedBooking == null
                                            ? () async {
                                                setState(() {
                                                  _pickupLocationController
                                                          .text =
                                                      booking.pickupLocation;
                                                  _destinationLocationController
                                                          .text =
                                                      booking.dropoffLocation;
                                                  LatLng pickupGPS =
                                                      booking.gpsPickup;
                                                  LatLng destinationGPS =
                                                      booking.gpsDropoff;
                                                  _onLocationsChanged(pickupGPS,
                                                      destinationGPS);
                                                  _selectedBooking = booking;
                                                });
                                                if (mounted) {
                                                  try {
                                                    await _bookingDriverService
                                                        .acceptBooking(
                                                      booking.bookingId,
                                                      widget.driver.Driver_ID,
                                                    );
                                                    print(
                                                        'Chuyến đi đã được nhận thành công');
                                                  } catch (e) {
                                                    print(
                                                        'Lỗi khi nhận chuyến đi: $e');
                                                  }
                                                  if (mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Select Trip',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          );
        },
      );
    }
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
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _markers,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  )
                ],
              )
            ],
          ),
          Positioned(
            top: 35,
            left: 10,
            child: FloatingActionButton.extended(
              heroTag: 'stopRideButton',
              icon: Image.asset('assets/driver/icon_power_off.png'),
              label: Text(
                'Tắt nhận chuyến',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white.withOpacity(0.75),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: _updateLocation,
            ),
          ),
          Positioned(
            top: 40,
            right: 15,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền cho thông tin
                borderRadius: BorderRadius.circular(24), // Bo tròn góc
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Màu đổ bóng
                    blurRadius: 4,
                    offset: Offset(2, 2), // Vị trí đổ bóng
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // Thay đổi trạng thái mở rộng
                  });
                },
              ),
            ),
          ),
          if (_isExpanded && _selectedBooking != null)
            Positioned(
              top: 100,
              right: 15,
              child: Container(
                width: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _selectedBooking != null
                      ? [
                          Text(
                            "Distance: ${_totalDistance.toStringAsFixed(2)} km",
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Price: ${_selectedBooking!.price} VNĐ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Phone: ${_selectedBooking!.userPhone}",
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          // Nút hủy chuyến đi
                          ElevatedButton(
                            onPressed: _cancelBooking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel Trip',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]
                      : [
                          Text(
                            "No Trip Selected",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                ),
              ),
            ),
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'showRidesList', // Thêm heroTag để tránh xung đột
                  onPressed:
                      showBookingsList, // Gọi hàm hiển thị danh sách chuyến đi
                  mini: true,
                  backgroundColor: Colors.blueAccent, // Màu sắc tùy chỉnh
                  child: Icon(Icons.directions_car), // Biểu tượng danh sách
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: focusOnCurrentLocation,
                  heroTag: 'focusOnCurrentLocation',
                  mini: true,
                  child: Icon(Icons.my_location),
                ),
                SizedBox(
                  height: 8,
                ),
                FloatingActionButton(
                  heroTag: 'zoomIn', // Thêm heroTag để tránh xung đột
                  onPressed: zoomIn,
                  mini: true,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut', // Thêm heroTag để tránh xung đột
                  onPressed: zoomOut,
                  mini: true,
                  child: Icon(Icons.zoom_out),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'clearRoute', // Thêm heroTag mới để tránh xung đột
                  onPressed:
                      clearRouteMarkers, // Gọi hàm xóa các marker chỉ đường
                  mini: true,
                  backgroundColor:
                      Colors.red, // Thay đổi màu sắc để dễ nhận biết
                  child: Icon(Icons.clear), // Biểu tượng xóa
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            panel: TripInfoPanel(
              onLocationsChanged: _onLocationsChanged,
              pickupLocationController: _pickupLocationController,
              destinationLocationController: _destinationLocationController,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 80,
            maxHeight: 350,
            body: Container(),
          ),
        ],
      ),
    );
  }
}
