import 'package:flutter/material.dart';
import '../models/driver.dart';
import 'homemenu.dart';
import 'riderpicker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  final Driver driver;
  HomePage({Key? key, required this.driver}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool online = false;
  late LatLng _initialLocation = LatLng(0, 0);
  MapController _mapController = MapController();
  List<Marker> _markers = [];
  Marker? _currentLocationMarker;
  double _heading = 0.0;

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

  void zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: HomeMenu(driver: widget.driver),
        ),
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
              ],
            ),
            Positioned(
              top: 50,
              left: 15,
              child: FloatingActionButton(
                heroTag: 'menuButton',
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                mini: true,
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 25,
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
            Positioned(
              bottom: 120,
              left: MediaQuery.of(context).size.width * 0.3,
              child: FloatingActionButton.extended(
                heroTag: 'rideButton',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RiderPicker(driver: widget.driver)));
                },
                backgroundColor: Colors.black.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bo tròn góc nút
                ),
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                label: Text(
                  'Mở nhận chuyến',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: MediaQuery.of(context).size.width * 0.21,
              child: Container(
                width: 250,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12), // Bo góc
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 10,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Đang ngoại tuyến',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void toggleSwitch(bool value) {
    setState(() {
      online = value;
    });
    if (online) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RiderPicker(driver: widget.driver),
      ));
    }
  }
}
