// ignore_for_file: unnecessary_new

import 'package:google_maps_flutter/google_maps_flutter.dart';

class StepsRes {
  LatLng startLocation;
  LatLng endLocation;
  StepsRes({required this.startLocation, required this.endLocation});
//  Steps();
  factory StepsRes.fromJson(Map<String, dynamic> json) {
    assert(json["start_location"] != null && json["end_location"] != null,
        'Location data cannot be null');
    return new StepsRes(
      startLocation: new LatLng(
          json["start_location"]["lat"], json["start_location"]["lng"]),
      endLocation:
          new LatLng(json["end_location"]["lat"], json["end_location"]["lng"]),
    );
  }
}
