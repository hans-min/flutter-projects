import 'package:myoty/model/equipment/tag_categ_enum.dart';

class Tag {
  const Tag({
    required this.tagCateg,
    required this.id,
    required this.name,
    required this.currentZone,
    required this.dateEnterCurrentZone,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tagCateg: TagCategEnum.fromCateg(
          TagCateg.fromJson(json["tag_categ"]),
        ),
        id: json["id"],
        name: json["name"],
        currentZone: json["current_zone"] != null
            ? CurrentZone.fromJson(json["current_zone"])
            : null,
        dateEnterCurrentZone: json["date_current_zone"],
      );
  final TagCategEnum tagCateg;
  final String id;
  final String? name; //can be null confirmed
  final CurrentZone? currentZone;
  final String? dateEnterCurrentZone;
}

class TagCateg {
  const TagCateg({
    required this.id,
    required this.libelle,
  });

  factory TagCateg.fromJson(Map<String, dynamic> json) => TagCateg(
        id: json["id"],
        libelle: json["libelle"],
      );
  final int id;
  final String libelle;
}

class CurrentZone {
  CurrentZone({
    required this.id,
    required this.libelle,
    required this.r,
    required this.a,
    required this.b,
    required this.g,
  });

  factory CurrentZone.fromJson(Map<String, dynamic> json) => CurrentZone(
        id: json["id"],
        libelle: json["libelle"],
        r: json["r"],
        a: json["a"],
        b: json["b"],
        g: json["g"],
      );
  final String id;
  final String libelle;
  final int r;
  final int a;
  final int b;
  final int g;
}
