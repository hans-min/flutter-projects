import 'dart:developer';
import 'package:bluetooth/extensions.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class Utilities {
  static Map<int, String> _companyMap = {};

  static ({int code, String name}) getCompanyName(
      int keyFromManufacturerData) {
    final companyCode = keyFromManufacturerData
        .decimalToHex()
        .reverseHexInPairs().hexaToInt();
    final companyName = _companyMap[companyCode] ?? 'Unknown Company';
    return (code: companyCode, name: companyName);
  }

  static loadCompanyIdentifiers() async {
    //datum.key == 5129 (=1409 in hex, the reverse is 0914,
    //0x0914 to int = 2324 => Company code INEO-SENSE)
    String yamlString =
        await rootBundle.loadString('assets/company_identifiers.yaml');
    var yaml = loadYaml(yamlString);
    _companyMap = {
      for (var company in yaml['company_identifiers'])
        company['value'] as int: company['name'] as String
    };
    log('Company identifiers loaded, length: ${_companyMap.length}');
  }
}
extension Hexa on int {
  //add a decimal to hex function, padding with 0 if needed
  String decimalToHex() {
    final a = toRadixString(16);
    return a.length == 1 ? "0$a" : a;
  }
}
