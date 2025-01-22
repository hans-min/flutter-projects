import 'package:bluetooth/utilities.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class AdvData {
  final List<int> rawData;

  AdvData({required this.rawData});

  String hexData() {
    return _advDataToHex(rawData);
  }

  String _advDataToHex(List<int> advDataValue) {
    StringBuffer rawDataBuffer = StringBuffer();
    for (int decimal in advDataValue) {
      rawDataBuffer.write(decimal.decimalToHex());
    }
    return rawDataBuffer.toString().toUpperCase();
  }
}

class ManufacturerData extends AdvData {
  final ({int code, String name}) company;

  ManufacturerData(Map<int, List<int>> manufacturerData)
      : company = Utilities.getCompanyName(manufacturerData.keys.first),
        super(rawData: manufacturerData.values.first);
}

class ServiceData extends AdvData {
  // final ({Guid uuid, String name}) service;
  final String serviceUUID;

  ServiceData(Map<Guid, List<int>> serviceData)
      : serviceUUID = serviceData.keys.first.str.toUpperCase(),
        super(rawData: serviceData.values.first);
}

class ScanResultWrapper {
  BluetoothDevice device;
  String name;
  int rssi;
  DeviceIdentifier macAddress;
  ManufacturerData? manufacturerData;
  ServiceData? serviceData;

  ScanResultWrapper(ScanResult result)
      : device = result.device,
        name = result.device.platformName,
        rssi = result.rssi,
        manufacturerData = result.advertisementData.manufacturerData.isEmpty
            ? null
            : ManufacturerData(result.advertisementData.manufacturerData),
        macAddress = result.device.remoteId,
        serviceData = result.advertisementData.serviceData.isEmpty
            ? null
            : ServiceData(result.advertisementData.serviceData);
}

class SensorData {
  final double? temperature;
  final int? humidity;
  final bool? magnetPresent;
  final bool? isMoving;
  final bool? lowBattery;

  SensorData(
      {this.temperature,
      this.humidity,
      this.magnetPresent,
      this.isMoving,
      this.lowBattery});

  @override
  String toString() {
    return 'SensorData{temperature: $temperature, humidity: $humidity, magnetPresent: $magnetPresent, isMoving: $isMoving, lowBattery: $lowBattery}';
  }
}
