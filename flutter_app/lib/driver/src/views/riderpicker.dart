import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import '../models/driver.dart';
import '../viewmodels/create_marker.dart';
import 'homepage.dart';

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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            markers: _marker,
            initialCameraPosition:
                CameraPosition(target: _initialLocation, zoom: 15),
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
          SlidingUpPanel(
            panel: _panelContent(),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
            minHeight: 100,
            maxHeight: 650,
            body: Container(),
          ),
        ],
      ),
    );
  }

  Widget _panelContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.0),
          Center(
            child: Text(
              "Thông tin chuyến đi",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: "Roboto"),
            ),
          ),
        ],
      ),
    );
  }
}
