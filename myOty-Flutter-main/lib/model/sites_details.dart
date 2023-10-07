// ignore_for_file: inference_failure_on_untyped_parameter

class SiteDetails {
  SiteDetails({
    required this.alerteZone,
    required this.alerteTemperature,
    required this.alerteMag,
    required this.batterieFaible,
    required this.sites,
  });

  factory SiteDetails.fromJson(Map<String, dynamic> json) => SiteDetails(
        alerteZone: json["alerte_zone"],
        alerteTemperature: json["alerte_temperature"],
        alerteMag: json["alerte_mag"],
        batterieFaible: json["batterie_faible"],
        sites: List<Site>.from(
          json["sites"].map((x) => Site.fromJson(x)),
        ),
      );

  final int alerteZone;
  final int alerteTemperature;
  final int alerteMag;
  final int batterieFaible;
  final List<Site> sites;
}

class Site {
  Site({
    required this.libelle,
    required this.plan,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        libelle: json["libelle"] as String,
        plan: List<Plan>.from(
          json["plan"].map((x) => Plan.fromJson(x)),
        ),
      );

  final String libelle;
  final List<Plan> plan;
}

class Plan {
  Plan({
    required this.libelle,
    required this.nbObjet,
    required this.zone,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        libelle: json["libelle"],
        nbObjet: json["nb_objet"],
        zone: List<Zone>.from(
          json["zone"].map((x) => Zone.fromJson(x)),
        ),
      );

  final String libelle;
  final int nbObjet;
  final List<Zone> zone;
}

class Zone {
  const Zone({
    required this.id,
    required this.libelle,
    required this.nbObjet,
    required this.r,
    required this.a,
    required this.b,
    required this.g,
  });
  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        libelle: json["libelle"] as String,
        id: json["id"] as String,
        nbObjet: json["nb_objet"] as int,
        r: json["r"],
        a: json["a"],
        b: json["b"],
        g: json["g"],
      );
  final int r;
  final int a;
  final int b;
  final int g;

  final String libelle;
  final String id;
  final int nbObjet;
}
