class Network {
  const Network({
    required this.id,
    required this.libelle,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json['id'],
        libelle: json['libelle'],
        primaryColor: json['couleur_primary'],
        secondaryColor: json['couleur_secondary'],
      );
  final String id;
  final String libelle;
  final String? primaryColor;
  final String? secondaryColor;
}

class Networks {
  const Networks({
    required this.network,
  });

  factory Networks.fromJson(Map<String, dynamic> json) => Networks(
        network: Network.fromJson(json['network']),
      );

  final Network network;
}
