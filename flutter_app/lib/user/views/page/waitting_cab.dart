import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WaitingCab extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final String pickupAddress; // Địa chỉ đón
  final String destinationAddress; // Địa chỉ đến

  WaitingCab({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  @override
  State<WaitingCab> createState() => _WaitingCabState();
}

class _WaitingCabState extends State<WaitingCab> {
  late LatLng _initialLocation;
  MapController _mapController = MapController();
  List<LatLng> _routePoints = [];

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
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _initialLocation = widget.pickupLocation;
    _fetchRoute(widget.pickupLocation, widget.destinationLocation);
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
          SlidingUpPanel(
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Tìm tài xế",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mã chuyến đi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "01J84WPTKVVD549ON4D9EAHKH5", // Replace with actual trip ID
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildAddressBox(
                        icon: Icons.circle,
                        address: widget.pickupAddress,
                      ),
                      SizedBox(height: 8),
                      _buildAddressBox(
                        icon: Icons.circle_outlined,
                        address: widget.destinationAddress,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 200,
            maxHeight: 400,
            body: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBox({required IconData icon, required String address}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal[50], // Box color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal, width: 1), // Border color
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
