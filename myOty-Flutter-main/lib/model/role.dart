enum RoleEnum {
  superAdmin(role: Role(id: 99, libelle: "SUPERADMIN")),
  //adminPlus(role: Role(id: XX, libelle: "ADMIN +")),
  //admin(role: Role(id: XX, libelle: "ADMIN")),
  //userPlus(role: Role(id: XX, libelle: "USER +")),
  //user(role: Role(id: XX, libelle: "USER")),
  unknown(role: Role(id: 0, libelle: "UNKNOWN"));

  const RoleEnum({required this.role});

  factory RoleEnum.fromRole(Role role) {
    return values.firstWhere(
      (e) => e.role.id == role.id,
      orElse: () => RoleEnum.unknown,
    );
  }

  final Role role;
}

class Role {
  const Role({
    required this.id,
    required this.libelle,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] as int,
        libelle: json["libelle"] as String,
      );
  final int id;
  final String libelle;
}
