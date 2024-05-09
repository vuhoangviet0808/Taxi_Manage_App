// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_app/driver/src/views/homepage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/driver.dart';
import '../../viewmodels/create_marker.dart';

class RiderPicker extends StatefulWidget {
  final Driver driver;
  RiderPicker({required this.driver});
  @override
  State<RiderPicker> createState() => _RiderPickerState();
}

class _RiderPickerState extends State<RiderPicker> {
  late LatLng _initialLocation = LatLng(0, 0);
  GoogleMapController? _mapController;
  Set<Marker> _marker = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final customIcon =
        await MarkerGenerator.createCustomMarkerBitmap(50, Colors.blue);
    setState(() {
      _initialLocation = LatLng(position.latitude, position.longitude);
      _marker.clear();
      _marker.add(Marker(
          markerId: MarkerId("currentLocation"),
          position: _initialLocation,
          icon: customIcon));
    });
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_initialLocation));
    }
    print(_initialLocation);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: [
            GoogleMap(
                onMapCreated: _onMapCreated,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                markers: _marker,
                initialCameraPosition:
                    CameraPosition(target: _initialLocation, zoom: 15)),
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
                            builder: (context) =>
                                HomePage(driver: widget.driver)));
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
                    actions: const [
                      Icon(
                        Icons.notifications,
                        color: Colors.black,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
