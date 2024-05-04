import 'package:flutter/material.dart';

class RiderPicker extends StatefulWidget {

  @override
  State<RiderPicker> createState() => _RiderPickerState();
}

class _RiderPickerState extends State<RiderPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: [
            // GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //       target: LatLng(21.01541595775449, 105.83220302855172),
            //       zoom: 15),
            //   zoomControlsEnabled: true,
            //   mapType: MapType.normal,
            //   zoomGesturesEnabled: true,
            // ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: const Text(
                      "Taxi App",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: TextButton(
                      child: const Icon(
                        Icons.menu,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    actions: const [
                      Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 167, 166, 166),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Placeholder(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}