import 'package:bluetooth/decoder/ela.dart';
import 'package:bluetooth/decoder/teltonika.dart';
import 'package:bluetooth/models.dart';
import 'package:collection/collection.dart';

abstract class BaseSensorDecoder<T extends AdvData> {
  final T advData; // This is either ServiceData or ManufacturerData

  BaseSensorDecoder(this.advData);

  bool isApplicable();
  SensorData decode();
}

List<BaseSensorDecoder<ServiceData>> getServiceDataDecoder(
    ServiceData serviceData) {
  return [ElaTSensorDecoder(serviceData)];
}

List<BaseSensorDecoder<ManufacturerData>> getManufacturerDataDecoder(
    ManufacturerData manufacturerData) {
  return [TeltonikaDecoder(manufacturerData)];
}

SensorData? decodeData(ScanResultWrapper device) {
  final manufacturerData = device.manufacturerData;
  final serviceData = device.serviceData;
  List<BaseSensorDecoder> decoders = [];
  if (manufacturerData != null) {
    decoders.addAll(getManufacturerDataDecoder(manufacturerData));
  } else if (serviceData != null) {
    decoders.addAll(getServiceDataDecoder(serviceData));
  } else {
    return null;
  }
  final decoder =
      decoders.firstWhereOrNull((decoder) => decoder.isApplicable());
  return decoder?.decode();
}
