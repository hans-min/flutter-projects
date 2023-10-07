import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myoty/model/equipment/tag.dart';

// get TagCateg from API listTagCateg
// can't do with enum, because enum is compile time constant,
// so it can't be dynamic
// we can achieve with class, but it's too much work since we
// can't use switch case with class
enum TagCategEnum {
  wirepasMobile(categ: TagCateg(id: 1, libelle: "WIREPAS MOBILE")),
  temperature(categ: TagCateg(id: 2, libelle: "ELA TEMPERATURE")),
  bluetoothID(categ: TagCateg(id: 4, libelle: "BLUETOOTH ID")),
  mov(categ: TagCateg(id: 5, libelle: "ELA MOV")),
  door(categ: TagCateg(id: 6, libelle: "DOOR")),
  rht(categ: TagCateg(id: 7, libelle: "ELA RHT")),

  wirepasAnchor(categ: TagCateg(id: 8, libelle: "WIREPAS ANCHOR")),
  wirepasSink(categ: TagCateg(id: 9, libelle: "WIREPAS SINK")),
  elaLoraNTrack(categ: TagCateg(id: 10, libelle: "ELA LORA NTRACK")),
  elaPIR(categ: TagCateg(id: 13, libelle: "ELA PIR")),
  elaAI(categ: TagCateg(id: 14, libelle: "ELA AI")),
  elaDI(categ: TagCateg(id: 15, libelle: "ELA DI")),
  elaDO(categ: TagCateg(id: 16, libelle: "ELA DO")),

  teltonikaEyeSensor(categ: TagCateg(id: 17, libelle: "TELTONIKA EYE SENSOR")),
  teltonikaEyeBeacon(categ: TagCateg(id: 18, libelle: "TELTONIKA EYE BEACON")),
  minewTemperature(categ: TagCateg(id: 19, libelle: "MINEW TEMPERATURE")),
  minewMag(categ: TagCateg(id: 20, libelle: "MINEW MAG")),
  elaBuzz(categ: TagCateg(id: 21, libelle: "ELA BUZZ")),

  ineosenseTracer(categ: TagCateg(id: 11, libelle: "TRACER")),
  ineosenseACS(categ: TagCateg(id: 12, libelle: "INEOSENSE LORA ACS")),
  ineosenseTracerGPS(categ: TagCateg(id: 22, libelle: "TRACER-GPS")),
  ineosenseZoner(categ: TagCateg(id: 23, libelle: "TRK-ZONER")),
  ineosenseSwitchTOF(categ: TagCateg(id: 24, libelle: "ACS-SWITCH-TOF")),
  padlock(categ: TagCateg(id: 25, libelle: "PADLOCK")),

  unknown(categ: TagCateg(id: 0, libelle: "OTHERS"));

  const TagCategEnum({required this.categ});

  factory TagCategEnum.fromCateg(TagCateg categ) {
    return values.firstWhere(
      (e) => e.categ.id == categ.id,
      orElse: () => TagCategEnum.unknown,
    );
  }

  final TagCateg categ;

  Icon get defaultIcon {
    var icon = Icon(
      Icons.hub,
      color: Colors.blue[800],
    );
    switch (this) {
      case TagCategEnum.wirepasMobile:
      case TagCategEnum.ineosenseTracer:
      case TagCategEnum.ineosenseTracerGPS:
        icon = const Icon(
          Icons.blur_circular,
          color: Colors.lightGreen,
          size: 20,
        );
      case TagCategEnum.temperature:
        icon = const Icon(
          Icons.thermostat,
          color: Colors.red,
          size: 20,
        );
      case TagCategEnum.bluetoothID:
        icon = const Icon(
          Icons.bluetooth,
          color: Colors.blue,
          size: 20,
        );
      case TagCategEnum.mov:
        icon = Icon(
          Icons.local_shipping,
          size: 20,
          color: Colors.yellow[700],
        );
      case TagCategEnum.door:
        icon = const Icon(
          Icons.sensor_door,
          size: 20,
          color: Colors.blue,
        );
      case TagCategEnum.rht:
        icon = const Icon(
          Icons.dew_point,
          size: 20,
          color: Colors.purple,
        );
      case TagCategEnum.elaPIR:
        icon = const Icon(
          Icons.sensors,
          size: 20,
          color: Colors.green,
        );
      case TagCategEnum.ineosenseSwitchTOF:
        icon = Icon(
          Icons.height,
          size: 20,
          color: Colors.green[900],
        );
      case TagCategEnum.ineosenseZoner:
        icon = const Icon(
          Icons.warehouse,
          size: 20,
          color: Colors.brown,
        );
      case TagCategEnum.padlock:
        icon = const Icon(
          Icons.lock,
          size: 20,
        );
      case TagCategEnum.unknown:
        icon = const Icon(
          Icons.question_mark,
          size: 20,
        );
      default:
        break;
    }
    return icon;
  }

  Text iconWithValue(
    String? value,
    String? value2, {
    double size = 20,
    TextStyle? style,
    String? durationForMag,
  }) {
    final hasV1 = value != null;
    var str = hasV1 ? value : "";
    var icon = defaultIcon;

    switch (this) {
      case TagCategEnum.rht:
        if (hasV1) str += "°C";
        icon = Icon(
          Icons.thermostat,
          color: Colors.red,
          size: size,
        );
        final hasV2 = value2 != null;
        final str2 = "$value2%";
        final icon2 = Icon(
          Icons.water_drop,
          color: Colors.blue,
          size: size,
        );

        return Text.rich(
          TextSpan(
            style: style,
            children: [
              WidgetSpan(child: icon),
              TextSpan(text: "$str${hasV2 ? " / " : ""}"),
              if (hasV2) WidgetSpan(child: icon2),
              if (hasV2) TextSpan(text: str2),
            ],
          ),
        );
      case TagCategEnum.temperature:
        if (hasV1) str += "°C";
      case TagCategEnum.door:
        if (hasV1) {
          if (str == "0") {
            str = "Ouvert";
            icon = Icon(
              Icons.meeting_room,
              color: Colors.red,
              size: size,
            );
          } else if (str == "1") {
            str = "Fermé";
            icon = Icon(
              Icons.door_front_door,
              color: Colors.green,
              size: size,
            );
          } else {
            log("Unexpected DOOR value: $str");
          }

          if (durationForMag != null) {
            str = durationForMag;
          }
        }
      case TagCategEnum.mov:
        if (hasV1) {
          if (str == "0") {
            str = "At rest";
            icon = Icon(
              Icons.stop,
              size: size,
            );
          } else if (value == "1") {
            str = "Moving";
            icon = Icon(
              Icons.open_with,
              color: Colors.orange,
              size: size,
            );
          } else {
            log("Unexpected MOV value: $str");
          }
        }
      case TagCategEnum.ineosenseSwitchTOF:
        if (hasV1) {
          if (str == "1") {
            str = "Absent";
            icon = Icon(
              Icons.no_transfer,
              size: size,
              color: Colors.red,
            );
          } else if (value == "0") {
            str = "Présent";
            icon = Icon(
              Icons.no_crash,
              size: size,
              color: Colors.green,
            );
          } else {
            log("Unexpected TOF value: $str");
          }
        }
        if (durationForMag != null) {
          str = durationForMag;
        }
      default:
      //log("Tag Categ: ${categ.libelle}");
    }

    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(child: icon),
          TextSpan(
            text: str,
            style: style,
          ),
        ],
      ),
    );
  }
}
