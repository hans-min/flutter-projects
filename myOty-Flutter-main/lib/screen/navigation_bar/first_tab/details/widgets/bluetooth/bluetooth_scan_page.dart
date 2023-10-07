import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:myoty/model/constants.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/bluetooth/device_details_page.dart';
import 'package:myoty/utils/utilities.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({
    required this.tagName,
    super.key,
    this.autoScanConnect = false,
  });
  final String tagName;
  final bool autoScanConnect;

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  final FlutterBluePlus? bluetoothManager = FlutterBluePlus.instance;
  StreamSubscription<BluetoothState>? blueStateListener;
  StreamSubscription<List<ScanResult>>? scanResultsListener;
  BuildContext? dialogContext;
  BluetoothCharacteristic? _characteristic;
  BluetoothDevice? device;
  int rssi = 0;
  bool connected = false;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startBluetoothStateMonitoring();
    _addBlueListener();
  }

  @override
  void dispose() {
    if (bluetoothManager != null && bluetoothManager!.isScanningNow) {
      bluetoothManager!.stopScan();
    }
    blueStateListener?.cancel();
    scanResultsListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return buildScanningFeedback();
    } else {
      return DeviceCommandPage(
        device: device!,
        characteristic: _characteristic!,
      );
    }
  }

  Widget buildScanningFeedback() {
    final width = MediaQuery.of(context).size.width - 40;
    if (!isScanning) {
      return ElevatedButton.icon(
        onPressed: startScan,
        icon: const Icon(Icons.search),
        label: const Text("Start Search"),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(5),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          fixedSize: MaterialStateProperty.all(Size(width, 50)),
        ),
      );
    } else {
      if (device == null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(" Scanning for ${widget.tagName}...")
          ],
        );
      } else {
        return LimitedBox(
          maxHeight: 150,
          maxWidth: width,
          child: RadialGauge(
            yCenterCoordinate: 0.85,
            radiusFactor: 1.8,
            needlePointer: [
              NeedlePointer(
                value: rssi.toDouble(),
                needleStyle: NeedleStyle.flatNeedle,
                needleHeight: 80,
              )
            ],
            shapePointer: [
              RadialShapePointer(
                value: rssi.toDouble(),
                height: 7,
                width: 7,
              )
            ],
            track: const RadialTrack(
              start: -100,
              end: -30,
              endAngle: 180,
              startAngle: 0,
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow, Colors.green],
              ),
              trackStyle: TrackStyle(
                showPrimaryRulers: false,
                showSecondaryRulers: false,
                showLabel: false,
              ),
            ),
          ),
        );
      }
    }
  }

  // * Listener
  void _addBlueListener() {
    scanResultsListener = bluetoothManager?.scanResults.listen(
      (results) {
        //scanSub?.cancel();
        //ELA: device name == adv.localName
        //Ineo: device name = 00000000, localName = Mac address
        for (final r in results) {
          final name = r.advertisementData.localName;
          //log("device name: ${r.device.name} vs localName: $name");
          //log("device name: ${r.device.name}/$name: ${r.rssi}");
          if (!name.contains(widget.tagName)) {
            continue;
          }
          assignAndAct(r);
        }
      },
      onDone: () => {log("done")},
      onError: (Object err) => {log("Error: $err")},
      //cancelOnError: true,
    );
  }

  ///
  void assignAndAct(ScanResult result) {
    setState(() {
      device ??= result.device;
      if (result.rssi > -30) {
        rssi = -30;
      } else {
        rssi = result.rssi < -100 ? -100 : result.rssi;
      }
      log("$rssi");
    });

    if (widget.autoScanConnect) {
      //we want to connect and send command
      final manufacturerData = result.advertisementData.manufacturerData;
      if (manufacturerData.isNotEmpty) {
        final rawData = Utilities.manufacturerDataToHex(manufacturerData);
        log('${result.advertisementData.localName} found! data: $rawData');
        bluetoothManager?.stopScan();
        _connectToDevice();
      }
    }
  }

  void startBluetoothStateMonitoring() {
    blueStateListener = bluetoothManager?.state.listen((state) {
      switch (state) {
        case BluetoothState.on:
          log("case on ");
          if (widget.autoScanConnect) startScan();
        case BluetoothState.turningOn:
          log("case turningOn");
        case BluetoothState.off:
          log("case off");
          showAlertAndStopScan("Please turn on Bluetooth");
        case BluetoothState.turningOff:
          log("case turningOff");
        case BluetoothState.unauthorized:
          showAlertAndStopScan(
            "Please change the Bluetooth permission of the app",
          );
        case BluetoothState.unavailable:
          showAlertAndStopScan("This device doesn't supports Bluetooth");
        case BluetoothState.unknown:
          log("Bluetooth state unknown ?");
      }
    });
  }

  //* start stop scan
  Future<void> startScan() async {
    final state = await bluetoothManager?.isOn;
    if (state!) {
      if (!bluetoothManager!.isScanningNow) {
        log("start scan");
        unawaited(bluetoothManager?.startScan(allowDuplicates: true));
      }
      setState(() {
        isScanning = true;
      });
    } else {
      showAlertAndStopScan("Bluetooth is not on");
    }
  }

  void stopScan() {
    log("stop scan");
    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
    if (bluetoothManager != null && bluetoothManager!.isScanningNow) {
      bluetoothManager!.stopScan();
    }
  }

  // *
  void showAlertAndStopScan(String alert) {
    stopScan();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(alert),
        );
      },
    );
  }

  Future<void> _connectToDevice() async {
    buildIsConnectingDialog();
    if (device == null) {
      log("device is null, can't connect");
      return;
    }
    await device!.connect();
    _characteristic =
        await device!.discoverServices().then(getPadlockCharacteristic);
    if (_characteristic == null) {
      log("Characteristic not found");
      return;
    }
    if (mounted) {
      setState(() {
        connected = true;
      });
    }
    dismissDialog();
  }

  BluetoothCharacteristic? getPadlockCharacteristic(
    List<BluetoothService> services,
  ) {
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() != padlockServiceUUID) {
        continue;
      }
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase() !=
            padlockCharacteristicUUID) {
          continue;
        }
        return characteristic;
      }
    }
    return null;
  }

  void buildIsConnectingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Text(
            "Connecting to ${widget.tagName}",
          ),
          content: const Center(
            heightFactor: 1.5,
            widthFactor: 1,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void dismissDialog() {
    if (dialogContext != null) {
      Navigator.pop(dialogContext!);
    }
  }
}
