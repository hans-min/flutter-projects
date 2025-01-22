import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bluetooth/components/sensor_card.dart';
import 'package:bluetooth/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  List<ScanResultWrapper> deviceResults = [];
  StreamSubscription<List<ScanResult>>? scanSubscription;
  StreamSubscription<BluetoothAdapterState>? bleStateSubscription;

  @override
  void initState() {
    super.initState();
    startBluetoothStateMonitoring();
    scanListener();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    scanSubscription?.cancel();
    bleStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BlueSense"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            FlutterBluePlus.isScanningNow ? stopScan() : startScan(),
        backgroundColor: FlutterBluePlus.isScanningNow
            ? Colors.red
            : Theme.of(context).secondaryHeaderColor,
        child: Icon(
            FlutterBluePlus.isScanningNow ? Icons.search_off : Icons.search),
      ),
      body: ListView.builder(
        itemCount: deviceResults.length,
        itemBuilder: (context, index) {
          return SensorCard(deviceInfo: deviceResults[index]);
        },
      ),
    );
  }

  void startBluetoothStateMonitoring() async {
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
      log("Bluetooth not supported by this device");
      return;
    }

    // note: for iOS the initial state is typically BluetoothAdapterState.unknown
    // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
    bleStateSubscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      log("Bluetooth adapter is ${state.toString()}"); // unknown, turningOn, turningOff
      switch (state) {
        case BluetoothAdapterState.on:
          break;
        case BluetoothAdapterState.off:
          if (Platform.isAndroid) {
            await FlutterBluePlus.turnOn();
          } else {
            showAlertAndStopScan("Please turn on Bluetooth");
          }
        case BluetoothAdapterState.unauthorized:
          showAlertAndStopScan(
              "Please change the Bluetooth permission of the app");
        default:
          break; // on, unknown, turningOn, turningOff
      }
    });
  }

  void scanListener() {
    scanSubscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        for (ScanResult r in results) {
          final manufacturerData = r.advertisementData.manufacturerData;
          final serviceData = r.advertisementData.serviceData;
          final deviceName = r.device.platformName;
          if ((manufacturerData.isNotEmpty || serviceData.isNotEmpty) &&
              deviceName.isNotEmpty) {
            setState(() {
              _addDeviceToList(r);
            });
          }
        }
      },
      onError: (e) => log(e),
    );
  }

  void _addDeviceToList(final ScanResult result) {
    final bleDevice = ScanResultWrapper(result);
    final index = deviceResults
        .indexWhere((element) => element.device == bleDevice.device);
    if (index != -1) {
      deviceResults[index] = bleDevice;
    } else {
      deviceResults.add(bleDevice);
      log("device name: ${bleDevice.name}: ${bleDevice.manufacturerData?.hexData() ?? bleDevice.serviceData?.hexData()}");
    }
  }

  void startScan() {
    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      showAlertAndStopScan("Please turn on Bluetooth");
      return;
    }
    deviceResults.clear();
    setState(() {});
    FlutterBluePlus.startScan(continuousUpdates: true, continuousDivisor: 3);
  }

  void stopScan() async {
    await FlutterBluePlus.stopScan();
    setState(() {});
  }

  Future<void> showAlertAndStopScan(String alert) {
    stopScan();
    log("Scanning stopped from alert, button should turn blue now");
    setState(() {});
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(alert),
        );
      },
    );
  }
}
