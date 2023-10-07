class EquipmentData {
  EquipmentData({
    required this.maj,
    required this.id,
    required this.objetId,
    required this.value,
    required this.value2,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.planId,
    required this.zoneId,
  });
  factory EquipmentData.fromJson(Map<String, dynamic> json) => EquipmentData(
        maj: DateTime.parse(json["maj"]),
        id: json["id"],
        objetId: json["objet_id"],
        value: json["value"],
        value2: json["value2"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        speed: json["speed"],
        planId: json["plan_id"],
        zoneId: json["zone_id"],
      );

  final DateTime maj;
  final String id;
  final String objetId;
  final String? value;
  final String? value2;
  final String? latitude;
  final String? longitude;
  final String? speed;
  final String? planId;
  final String? zoneId;
}
