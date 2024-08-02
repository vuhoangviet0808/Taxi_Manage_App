// ignore_for_file: duplicate_import, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_item_res.dart';
import '../models/configs.dart';
import '../models/place_item_res.dart';
import '../models/step_res.dart';
import '../models/trip_info_res.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            Configs.ggKEY1 +
            "&language=vi&region=VN&query=" +
            Uri.encodeQueryComponent(keyword);

    print("search >>: " + url);
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      print('Error: ${res.statusCode} - ${res.body}');
      return List<PlaceItemRes>.empty();
    }
  }

  static Future<TripInfoRes?> getStep(
      double lat, double lng, double tolat, double tolng) async {
    String str_origin = "origin=" + lat.toString() + "," + lng.toString();
    // Destination of route
    String str_dest =
        "destination=" + tolat.toString() + "," + tolng.toString();
    // Sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    // Building the parameters to the web service
    String parameters = str_origin + "&" + str_dest + "&" + sensor + "&" + mode;
    // Output format
    String output = "json";
    // Building the url to the web service
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?" +
        parameters +
        "&key=" +
        Configs.ggKEY1;

    print(url);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      try {
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps = (json["routes"][0]["legs"][0]["steps"] as List)
            .map((step) => StepsRes.fromJson(step))
            .toList();
        return TripInfoRes(distance, steps);
      } catch (e) {
        throw Exception('Failed to parse steps data: $e');
      }
    } else {
      throw Exception('Failed to fetch directions: ${response.body}');
    }
  }
}
