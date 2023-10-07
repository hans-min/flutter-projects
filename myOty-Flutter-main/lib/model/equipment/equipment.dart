import 'package:myoty/model/equipment/tag.dart';

class Equipment {
  const Equipment({
    required this.id,
    required this.uuid,
    required this.libelle,
    required this.tag,
    this.lastUpdated,
    this.lastValue,
    this.lastValue2,
    this.lastLatitude,
    this.lastLongitude,
    this.images,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json["id"],
        uuid: json["uuid"],
        libelle: json["libelle"],
        lastValue: json["last_value"],
        lastValue2: json["last_value2"],
        lastLatitude: json["last_latitude"]?.toDouble(),
        lastLongitude: json["last_longitude"]?.toDouble(),
        lastUpdated: json["last_maj"],
        tag: Tag.fromJson(json["tag"]),
        images: List<Media>.from(
          // ignore: inference_failure_on_untyped_parameter
          json["media"].map((x) => Media.fromJson(x)),
        ),
      );

  final int id;
  final String uuid;
  final String libelle;
  final String? lastValue;
  final String? lastValue2;
  final double? lastLatitude;
  final double? lastLongitude;
  final String? lastUpdated;
  final Tag tag; //TODO: is Tag nullable ?
  final List<Media>? images;
}

class Media {
  const Media({
    required this.id,
    required this.file,
  });
  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        file: json["file"],
      );

  final int id;
  final String file;
}
