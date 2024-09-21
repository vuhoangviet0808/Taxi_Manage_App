import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import '../models/driver.dart';
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

  void _onLocationsChanged(LatLng pickupLatLng, LatLng destinationLatLng) {
    _fetchRoute(pickupLatLng, destinationLatLng);
    setState(() {
      _pickupMarker = Marker(
        point: pickupLatLng,
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.white,
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(driver: widget.driver)));
              },
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
          if (_isExpanded)
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
                  children: [
                    Text(
                      "Quãng đường: ${_totalDistance.toStringAsFixed(2)} km",
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Giá tiền: 100,000 VNĐ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Số điện thoại: 0335413585",
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
