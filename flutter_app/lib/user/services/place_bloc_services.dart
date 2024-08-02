// ignore_for_file: prefer_interpolation_to_compose_strings, argument_type_not_assignable_to_error_handler

import 'dart:async';
import '../services/place_services.dart';

class PlaceBloc {
  var _placeController = StreamController();
  Stream get placeStream => _placeController.stream;

  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    _placeController.sink.add("start");
    PlaceService.searchPlace(keyword).then((rs) {
      _placeController.sink.add(rs);
    }).catchError(() {
//      _placeController.sink.add("stop");
    });
  }

  void dispose() {
    _placeController.close();
  }
}
