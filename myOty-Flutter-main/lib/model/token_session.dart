import 'package:myoty/model/networks.dart';
import 'package:myoty/model/role.dart';

class Token {
  const Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
    );
  }
  final String token;
}

class Session {
  const Session({
    required this.email,
    required this.role,
    required this.uuid,
    required this.client,
    required this.networks,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      uuid: json['uuid'],
      client: Client.fromJson(json["client"]),
      networks: List<Networks>.from(
        // ignore: inference_failure_on_untyped_parameter
        json["networks"].map((x) => Networks.fromJson(x)),
      ),
      role: RoleEnum.fromRole(Role.fromJson(json["role"])),
      email: json['email'],
    );
  }
  final String uuid;
  final Client client;
  final List<Networks> networks;
  final RoleEnum role;
  final String email;
}

class Client {
  const Client({
    required this.uuid,
  });
  factory Client.fromJson(Map<String, dynamic> json) => Client(
        uuid: json["uuid"],
      );

  final String uuid;
}
