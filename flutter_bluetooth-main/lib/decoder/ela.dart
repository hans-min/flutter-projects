import 'package:bluetooth/decoder/sensor_decoder.dart';
import 'package:bluetooth/extensions.dart';
import 'package:bluetooth/models.dart';

class ElaTSensorDecoder extends BaseSensorDecoder<ServiceData> {
  ElaTSensorDecoder(super.advData);

  @override
  SensorData decode() {
    // 6C0A -> Oa6C -> decimal
    final data = advData.hexData().reverseHexInPairs().hexaToInt();
    final temperature = data / 100.0;
    return SensorData(temperature: temperature);
  }

  @override
  bool isApplicable() {
    return advData.serviceUUID == "6E2A";
  }
}
