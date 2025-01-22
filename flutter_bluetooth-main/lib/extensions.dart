extension Hexa on String {
  //check if hexa
  bool isHexadecimal() {
    return RegExp(r'^([0-9A-Fa-f])+$').hasMatch(this);
  }

  String hexStringToBits() {
    String bits = '';
    for (int i = 0; i < length; i++) {
      int value = int.parse(this[i], radix: 16);
      bits += value.toRadixString(2).padLeft(4, '0');
    }
    return bits;
  }

  String reverseHexInPairs() {
    if (length % 2 == 1) {
      return '0$this';
    }
    List<String> pairs = [];
    for (int i = 0; i < length; i += 2) {
      pairs.add(substring(i, i + 2));
    }
    return pairs.reversed.join('');
  }

  int hexaToInt() {
    return int.parse(this, radix: 16);
  }
}
