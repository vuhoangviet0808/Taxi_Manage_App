import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/user.dart';
import 'trip_info_panel.dart';
import '../page/home_page.dart';


class MapPage extends StatefulWidget {
  final User user;
  MapPage({required this.user});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LatLng _initialLocation = LatLng(0, 0);
  MapController _mapController = MapController();
  TextEditingController _pickupLocationController = TextEditingController();
  TextEditingController _destinationLocationController = TextEditingController();
  double _heading = 0.0;

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

  void _updateHeading(Position position) {
    setState(() {
      _heading = position.heading;
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
          RepaintBoundary(
            child: FlutterMap(
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
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: TextButton(
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(user: widget.user),
                      ));
                    },
                  ),
                  centerTitle: true,
                  title: TextButton(
                    onPressed: getLocation,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.my_location),
                      color: Colors.black,
                      onPressed: getLocation,
                    ),
                  ],
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
            panel: TripInfoPanel(
              onLocationsChanged: (LatLng pickupLatLng, LatLng destinationLatLng) {
                // Do nothing for markers
              },
              pickupLocationController: _pickupLocationController,
              destinationLocationController: _destinationLocationController,
              user: widget.user, // Truyền đối tượng user
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
