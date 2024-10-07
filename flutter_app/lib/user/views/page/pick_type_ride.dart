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
  final String pickupAddress; // Pick-up address
  final String destinationAddress; // Drop-off address
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
  double _totalPrice = 0.0; // Variable to store total price
  String? _selectedCarType; // Selected car type
  final BookingService bookingService = BookingService(); // Initialize booking service

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
      print("Error getting location: $e");
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
        // Calculate total price based on distance, 8000 VND per km
        _totalPrice = _totalDistance * 8000;
        // Round up to nearest thousand
        _totalPrice = ((_totalPrice + 999) ~/ 1000) * 1000;
      });
    } else {
      print("Failed to fetch route: ${response.body}");
    }
  }

  Future<void> _sendBookingRequest() async {
    if (_selectedCarType == null) {
      print("No car type selected");
      return;
    }

    try {
      // Send booking request
      await bookingService.sendBookingRequest(
        user_id: widget.user.User_ID,
        requestedCarType: _selectedCarType!,
        pickupAddress: widget.pickupAddress,
        dropoffAddress: widget.destinationAddress,
        pickupLocation: widget.pickupLocation,
        dropoffLocation: widget.destinationLocation,
        price: _totalPrice, // Send total price
      );

      // Navigate to WaitingCab screen after successful request
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WaitingCab(
            pickupLocation: widget.pickupLocation,
            destinationLocation: widget.destinationLocation,
            pickupAddress: widget.pickupAddress,
            destinationAddress: widget.destinationAddress,
            user: widget.user,
            totalDistance: _totalDistance,
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25), // Rounded corners with teal
                      border: Border.all(
                        color: Colors.teal, // Teal border
                        width: 2,
                      ),
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
                          'Distance: ${_totalDistance.toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Price: ${_totalPrice.toStringAsFixed(0)} VND',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
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
                      "Choose Car Type",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildOptionItem(
                  context,
                  title: "4-seat Taxi",
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
                  title: "6-seat Taxi",
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
                  title: "Book Ride",
                  icon: Icons.check_circle,
                  isSelected: false,
                  onTap: () {
                    _sendBookingRequest(); // Trigger booking request
                  },
                  isBookingButton: true, // Identify booking button
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
    bool isBookingButton = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isBookingButton ? Colors.teal : Colors.white, // Teal for booking button
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 1), // Teal border
      ),
      child: Row(
        mainAxisAlignment: isBookingButton ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(icon, color: isBookingButton ? Colors.white : Colors.teal, size: 24),
          SizedBox(width: isBookingButton ? 0 : 12), // No space for booking button
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isBookingButton ? Colors.white : Colors.black, // White text for booking button
            ),
          ),
        ],
      ),
    ),
  );
}
