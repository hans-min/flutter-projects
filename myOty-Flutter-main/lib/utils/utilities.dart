import 'dart:developer';

//BLUETOOTH Extension
class Utilities {
  static String manufacturerDataToHex(Map<int, List<int>> manufacturerData) {
    final rawDataBuffer = StringBuffer();
    for (final datum in manufacturerData.entries) {
      //datum.key == 5129 (=1409 in hex, the reverse is 0914 = Company code INEO-SENSE)
      for (final decimal in datum.value) {
        final a = decimal.decimalToHex();
        rawDataBuffer.write(a);
      }
    }
    return rawDataBuffer.toString();
  }
}

extension on int {
  //add a decimal to hex function, padding with 0 if needed
  String decimalToHex() {
    final a = toRadixString(16);
    return a.length == 1 ? "0$a" : a;
  }
}

extension Hexa on String {
  //check if hexa
  bool isHexadecimal() {
    return RegExp(r'^([0-9A-Fa-f])+$').hasMatch(this);
  }

  List<int> hexaStringToIntList() {
    if (!isHexadecimal() || length.isOdd) {
      log('Warning: Input string is not hexa, or length is odd');
      return List.empty();
    } else {
      final hexList = <int>[];
      for (var i = 0; i < length - 1; i += 2) {
        final hex = substring(i, i + 2);
        final number = int.parse(hex, radix: 16);
        hexList.add(number);
      }
      return hexList;
    }
  }
}

extension HexaList on List<int> {
  String toHexString() {
    final buffer = StringBuffer();
    for (final number in this) {
      if (number > 255 || number < 0) {
        return "Invalid data";
      }
      buffer.write(number.decimalToHex());
    }
    return buffer.toString();
  }
}
