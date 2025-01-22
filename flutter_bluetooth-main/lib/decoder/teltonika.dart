import 'package:bluetooth/decoder/sensor_decoder.dart';
import 'package:bluetooth/extensions.dart';
import 'package:bluetooth/models.dart';

const int flagTemperature = 0x01; // Bit 0
const int flagHumidity = 0x02; // Bit 1
const int flagMagneticSensor = 0x04; // Bit 2
const int flagMovementSensor = 0x10; // Bit 4, = 16 in decimal
const int flagLowBattery = 0x40; // Bit 6

class TeltonikaDecoder extends BaseSensorDecoder<ManufacturerData> {
  TeltonikaDecoder(super.advData);

  @override
  SensorData decode() {
    // 01b70b0e370187fdfffc51
    final hexData = advData.hexData();
    assert(hexData.startsWith("01"), "Not Teltonika data");
    // first hex 01 is version, we skip it
    final flags = hexData
        .substring(2, 4)
        .hexStringToBits(); // b7 = 10110111 (check from right to left)
    final flagsInt =
        int.parse(flags, radix: 2); // turn to int to use bitwise AND

    String hex = hexData.substring(4);

    // 0b0e370187fdfffc51
    double? temperature;
    int? humidity;
    bool? magnetPresent;
    bool? isMoving;

    if (flagsInt & flagTemperature != 0) {
      final data = hex.substring(0, 4);
      final value = int.tryParse(data, radix: 16);
      if (value != null) {
        temperature = value / 100.0;
      }
      hex = hex.substring(4);
    }

    if (flagsInt & flagHumidity != 0) {
      final data = hex.substring(0, 2);
      humidity = int.tryParse(data, radix: 16);
      hex = hex.substring(2);
    }

    if (flagsInt & flagMagneticSensor != 0) {
      const int flagMagneticState = 0x08; // Data from bit 3 of the flag
      magnetPresent = (flagsInt & flagMagneticState != 0) ? true : false;
    }

    if (flagsInt & flagMovementSensor != 0) {
      final dataBits = hex.substring(0, 1).hexStringToBits();
      isMoving = dataBits[0] == '1' ? true : false;
      // skip movement count
      hex = hex.substring(4);
    }

    final lowBattery = (flagsInt & flagLowBattery != 0) ? true : false;

    return SensorData(
      temperature: temperature,
      humidity: humidity,
      magnetPresent: magnetPresent,
      isMoving: isMoving,
      lowBattery: lowBattery,
    );
  }

  @override
  bool isApplicable() {
    return advData.company.code == 0x089A;
  }
}
