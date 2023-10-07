import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:myoty/utils/utilities.dart';

class DeviceCommandPage extends StatefulWidget {
  const DeviceCommandPage({
    required this.device,
    required this.characteristic,
    super.key,
  });
  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;

  @override
  State<DeviceCommandPage> createState() => _DeviceCommandPageState();
}

class _DeviceCommandPageState extends State<DeviceCommandPage> {
  late TextEditingController controller = TextEditingController();
  List<int> deviceResponse = List.empty();
  StreamSubscription? cValuesListener;
  StreamSubscription? stateListener;

  @override
  void initState() {
    super.initState();
    setCharacteristicNotify();
  }

  @override
  void dispose() {
    controller.dispose();
    cValuesListener?.cancel();
    stateListener?.cancel();
    widget.device.disconnect();
    super.dispose();
  }

  Future<void> setCharacteristicNotify() async {
    final c = widget.characteristic;
    await c.setNotifyValue(true);
    cValuesListener = c.value.listen((event) {
      setState(() {
        deviceResponse = event;
      });
      log(deviceResponse.toHexString());
    });

    stateListener = widget.device.state.listen((event) {
      if (event == BluetoothDeviceState.disconnected) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await widget.characteristic.write(
              "35FF1234EEEEEEEE40FFFFFFFF000A".hexaStringToIntList(),
              withoutResponse: true,
            );
            //TODO: send data to MyOty platform
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.green,
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_open,
                size: 100,
              ),
              SizedBox(height: 10),
              Text("Unlock (for 10s)"),
            ],
          ),
        ),
      ],
    );
  }
}
