// ignore_for_file: unnecessary_new

class PlaceItemRes {
  String name;
  String address;
  double lat;
  double lng;
  PlaceItemRes(this.name, this.address, this.lat, this.lng);

  static List<PlaceItemRes> fromJson(Map<String, dynamic> json) {
    print("parse data");
    var results = json['results'] as List;
    List<PlaceItemRes> rs = [];

    for (var item in results) {
      var p = new PlaceItemRes(
          item['name'],
          item['formatted_address'],
          item['geometry']['location']['lat'].toDouble(),
          item['geometry']['location']['lng'].toDouble());

      rs.add(p);
    }

    return rs;
  }
}
