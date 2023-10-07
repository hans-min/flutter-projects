// To parse this JSON data, do
//
//     final postEquipmentData = postEquipmentDataFromJson(jsonString);

import 'dart:convert';

class PostEquipmentData {
  const PostEquipmentData({
    required this.clientUuid,
    required this.data,
    required this.dateScan,
    required this.latitude,
    required this.longitude,
    required this.networkId,
    required this.reader,
    required this.readerType,
    required this.speed,
  });

  factory PostEquipmentData.fromRawJson(String str) =>
      PostEquipmentData.fromJson(json.decode(str));

  factory PostEquipmentData.fromJson(Map<String, dynamic> json) =>
      PostEquipmentData(
        clientUuid: json["client_uuid"],
        data: List<Datum>.from(
          // ignore: inference_failure_on_untyped_parameter
          json["data"].map((x) => Datum.fromJson(x)),
        ),
        dateScan: json["date_scan"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        networkId: json["network_id"],
        reader: json["reader"],
        readerType: json["reader_type"],
        speed: json["speed"],
      );
  final String clientUuid;
  final List<Datum> data;
  final String dateScan;
  final double latitude;
  final double longitude;
  final String networkId;
  final String reader;
  final int readerType;
  final int speed;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "client_uuid": clientUuid,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "date_scan": dateScan,
        "latitude": latitude,
        "longitude": longitude,
        "network_id": networkId,
        "reader": reader,
        "reader_type": readerType,
        "speed": speed,
      };
}

class Datum {
  const Datum({
    required this.tagCateg,
    required this.tagName,
    required this.value,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tagCateg: json["tag_categ"],
        tagName: json["tag_name"],
        value: json["value"],
      );

  final int tagCateg;
  final String tagName;
  final String value;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "tag_categ": tagCateg,
        "tag_name": tagName,
        "value": value,
      };
}
