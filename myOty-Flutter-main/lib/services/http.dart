import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/model/sites_details.dart';
import 'package:myoty/model/token_session.dart';
import 'package:myoty/services/shared_pref_manager.dart';
import 'package:myoty/utils/extension.dart';

class _Endpoint {
  const _Endpoint({required this.path, this.queryParameters});

  final String path;
  final Map<String, dynamic>? queryParameters;

  Uri get uri {
    return Uri.https(
      'api.myoty.com',
      path,
      queryParameters,
    );
  }
}

enum HTTPMethod { get, post }

class API {
  static Map<String, String> get header => {
        HttpHeaders.authorizationHeader: 'Bearer ${SharedPrefs.token}',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      };

//TODO:  generic static Future<T> _httpRequest<T>
  static Future _httpRequest(
    _Endpoint endpoint, {
    HTTPMethod method = HTTPMethod.get,
    String? body,
  }) async {
    http.Response response;
    switch (method) {
      case HTTPMethod.get:
        response = await http.get(
          endpoint.uri,
          headers: header,
        );
      case HTTPMethod.post:
        response = await http.post(
          endpoint.uri,
          body: body,
          headers: header,
        );
    }

    switch (response.statusCode) {
      case 200:
        final data = json.decode(response.body);
        return data;
      default:
        throw Exception(
          "${response.statusCode}: ${response.reasonPhrase ?? "Error"}",
        );
    }
  }

  static Future<Token> _fetchToken(String username, String password) async {
    log(username);
    log(password);
    const endpoint = _Endpoint(path: '/api/login_connect');
    final data = await _httpRequest(
      endpoint,
      method: HTTPMethod.post,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    ) as Map<String, dynamic>;
    return Token.fromJson(data);
  }

  static Future<Session> fetchSession(String username, String password) async {
    try {
      await _fetchToken(username, password).then((token) async {
        await SharedPrefs.setToken(token.token);
      });

      const endpoint = _Endpoint(path: '/api/session');
      final data = await _httpRequest(endpoint).catchError((Object err) {
        return Future<void>.error('fetchSession error: $err');
      }) as Map<String, dynamic>;
      final session = Session.fromJson(data);
      SharedPrefs.userUUID = session.uuid;
      SharedPrefs.clientUUID = session.client.uuid;
      SharedPrefs.username = session.email;
      return session;
    } catch (err) {
      rethrow;
    }
  }

  // static Future<List<Networks>> fetchNetworkList() async {
  //   final endpoint = _Endpoint(
  //     path: '/api/listeNetworksUser',
  //     queryParameters: {'user_uuid': SharedPrefs.userUUID},
  //   );
  //   final data = await _httpRequest(endpoint).catchError((err) {
  //     return Future.error('fetchNetworkList error: $err');
  //   });
  //   final networks = List<Networks>.empty(growable: true);
  //   for (final datum in data) {
  //     networks.add(Networks.fromJson(datum));
  //   }
  //   return networks;
  // }

  static Future<List<Equipment>> fetchEquipmentList({String? recherche}) async {
    final endpoint = _Endpoint(
      path: '/api/listeAllObjetsForMobile',
      queryParameters: {
        'client_uuid': SharedPrefs.clientUUID,
        'network_id': SharedPrefs.networkID,
        'recherche': recherche,
      },
    );

    final data = await _httpRequest(endpoint).catchError((Object err) {
      return Future<void>.error('fetchEqList error: $err');
    }) as List<dynamic>;

    final equipments = List<Equipment>.empty(growable: true);
    for (final datum in data) {
      equipments.add(Equipment.fromJson(datum));
    }
    return equipments;
  }

  /// if `dateRange` is null, the data will fetch automatically from
  /// Year - 1 to `DateTime.now()`
  static Future<List<EquipmentData>> fetchEquipmentHistory(
    String equipmentUUID, {
    DateTimeRange? dateRange,
    String maxNumberOfData = '50',
  }) async {
    dateRange ??= DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 365)),
      end: DateTime.now(),
    );

    final endpoint = _Endpoint(
      path: '/api/getObjetHistoAvecDates2',
      queryParameters: {
        'objet_uuid': equipmentUUID,
        'network_id': SharedPrefs.networkID,
        'debut': dateRange.start.formatToString(),
        'fin': dateRange.end.formatToString(),
        'max': maxNumberOfData,
      },
    );

    final data = await _httpRequest(endpoint).catchError((Object err) {
      return Future<void>.error('fetchEqData error: $err');
    }) as List<dynamic>;

    final equipments = List<EquipmentData>.empty(growable: true);
    for (final datum in data) {
      equipments.add(EquipmentData.fromJson(datum));
    }
    return equipments;
  }

  static Future<SiteDetails> fetchSiteDetails() async {
    final endpoint = _Endpoint(
      path: '/api/listeSiteDetail',
      queryParameters: {
        'client_uuid': SharedPrefs.clientUUID,
        'network_id': SharedPrefs.networkID,
      },
    );
    log('Fetching site details');
    final data = await _httpRequest(endpoint).catchError((Object err) {
      return Future<void>.error('getSiteDetails error: $err');
    }) as Map<String, dynamic>;
    final siteDetails = SiteDetails.fromJson(data);
    return siteDetails;
  }

  // static Future<List<TagCateg>> fetchTagCategList() async {
  //   final endpoint = _Endpoint(
  //     path: '/api/listeCateg',
  //     queryParameters: {'client_uuid': SharedPrefs.clientUUID},
  //   );
  //   final data = await _httpRequest(endpoint).catchError((err) {
  //     return Future.error('fetchTagCateg error: $err');
  //   }) as List<dynamic>;

  //   final categs = List<TagCateg>.empty(growable: true);
  //   for (final datum in data) {
  //     categs.add(TagCateg.fromJson(datum));
  //   }
  //   return categs;
  // }

  static Future<List<Equipment>> fetchEquipmentInZone(String zoneID) async {
    final endpoint = _Endpoint(
      path: '/api/listeObjetsFromMobile',
      queryParameters: {
        'client_uuid': SharedPrefs.clientUUID,
        'network_id': SharedPrefs.networkID,
        'zone_id': zoneID,
      },
    );
    final data = await _httpRequest(endpoint).catchError((Object err) {
      return Future<void>.error('fetchEqInZone error: $err');
    }) as List<dynamic>;
    final list = List<Equipment>.empty(growable: true);
    for (final datum in data) {
      list.add(Equipment.fromJson(datum));
    }
    return list;
  }

  static Future<List<Equipment>> postEquipmentData() async {
    const endpoint = _Endpoint(path: '/api/saveInventoryFromMobileIos');
    // final body = PostEquipmentData(
    //     clientUuid: SharedPrefs.clientUUID,
    //     data: data,
    //     dateScan: dateScan,
    //     latitude: latitude,
    //     longitude: longitude,
    //     networkId: SharedPrefs.networkID,
    //     reader: reader,
    //     readerType: readerType,
    //     speed: speed);
    final data = await _httpRequest(
      endpoint,
      method: HTTPMethod.post,
      //  body: body.toRawJson(),
    ).catchError((Object err) {
      return Future<void>.error('fetchEqInZone error: $err');
    }) as List<dynamic>;
    final list = List<Equipment>.empty(growable: true);
    for (final datum in data) {
      list.add(Equipment.fromJson(datum));
    }
    return list;
  }
}

extension ImageAPI on API {
  static Future<Image?> fetchImageFromMediaID({required int id}) async {
    final endpoint = _Endpoint(path: '/api/media/$id');
    final data = await API._httpRequest(endpoint).catchError((Object err) {
      return Future<void>.error('getImage error: $err');
    }) as String;

    final base64Data = data.replaceFirst('data:image/jpg;base64,', '');
    final bytes = base64.decode(base64Data);
    return bytes.isNotEmpty ? Image.memory(bytes) : null;
  }

  ///post an image encoded in base64, then return its new id
  static Future<int> postImage(File image, int eqId) async {
    final endpoint = _Endpoint(path: '/api/objets/$eqId/media64');
    final bytes = image.readAsBytesSync();
    final body = jsonEncode(<String, String>{
      'extension': 'jpg',
      'content': base64Encode(bytes),
    });
    final data = await API._httpRequest(
      endpoint,
      method: HTTPMethod.post,
      body: body,
    ) as Map<String, dynamic>;
    return data['id'] as int;
  }

  static Future<void> deleteImage(int imageId) async {
    final endpoint = _Endpoint(path: '/api/deleteMedia/$imageId');
    await API._httpRequest(endpoint, method: HTTPMethod.post);
    //data: String = suppression media 730 /home/myotycomia/elaapi/public/img//20230612_114438_e5e.jpg
    //return data["id"];
  }
}
