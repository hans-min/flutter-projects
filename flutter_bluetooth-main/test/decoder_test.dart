import 'package:bluetooth/decoder/teltonika.dart';
import 'package:bluetooth/models.dart';

void main() {
  final m = ManufacturerData({
    2202: [1, 183, 11, 80, 45, 0, 104, 254, 0, 0, 81]
  });
  final s = TeltonikaDecoder(m).decode();
  print(s.toString());
}
