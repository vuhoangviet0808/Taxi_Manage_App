// import 'dart:convert';

// SearchInfo searchInfoFromJson(String str) => SearchInfo.fromJson(json.decode(str));

// String searchInfoToJson(SearchInfo data) => json.encode(data.toJson());

// class SearchInfo {
//     List<Feature>? features;
//     String? type;

//     SearchInfo({
//         this.features,
//         this.type,
//     });

//     factory SearchInfo.fromJson(Map<String, dynamic> json) => SearchInfo(
//         features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
//         type: json["type"],
//     );

//     Map<String, dynamic> toJson() => {
//         "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
//         "type": type,
//     };
// }

// class Feature {
//     Geometry? geometry;
//     String? type;
//     Properties? properties;

//     Feature({
//         this.geometry,
//         this.type,
//         this.properties,
//     });

//     factory Feature.fromJson(Map<String, dynamic> json) => Feature(
//         geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
//         type: json["type"],
//         properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "geometry": geometry?.toJson(),
//         "type": type,
//         "properties": properties?.toJson(),
//     };
// }

// class Geometry {
//     List<double>? coordinates;
//     String? type;

//     Geometry({
//         this.coordinates,
//         this.type,
//     });

//     factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
//         coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
//         type: json["type"],
//     );

//     Map<String, dynamic> toJson() => {
//         "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
//         "type": type,
//     };
// }

// class Properties {
//     String? osmType;
//     int? osmId;
//     List<double>? extent;
//     String? country;
//     String? osmKey;
//     String? countrycode;
//     String? osmValue;
//     String? name;
//     String? state;
//     String? type;
//     String? city;

//     Properties({
//         this.osmType,
//         this.osmId,
//         this.extent,
//         this.country,
//         this.osmKey,
//         this.countrycode,
//         this.osmValue,
//         this.name,
//         this.state,
//         this.type,
//         this.city,
//     });

//     factory Properties.fromJson(Map<String, dynamic> json) => Properties(
//         osmType: json["osm_type"],
//         osmId: json["osm_id"],
//         extent: json["extent"] == null ? [] : List<double>.from(json["extent"]!.map((x) => x?.toDouble())),
//         country: json["country"],
//         osmKey: json["osm_key"],
//         countrycode: json["countrycode"],
//         osmValue: json["osm_value"],
//         name: json["name"],
//         state: json["state"],
//         type: json["type"],
//         city: json["city"],
//     );

//     Map<String, dynamic> toJson() => {
//         "osm_type": osmType,
//         "osm_id": osmId,
//         "extent": extent == null ? [] : List<dynamic>.from(extent!.map((x) => x)),
//         "country": country,
//         "osm_key": osmKey,
//         "countrycode": countrycode,
//         "osm_value": osmValue,
//         "name": name,
//         "state": state,
//         "type": type,
//         "city": city,
//     };
// }
