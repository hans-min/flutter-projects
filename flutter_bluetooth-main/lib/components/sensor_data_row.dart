import 'package:bluetooth/components/sensor_card.dart';
import 'package:bluetooth/components/sensor_data_expanded.dart';
import 'package:bluetooth/models.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SensorDetailsRow extends StatelessWidget {
  final SensorData sensorData;
  final bool isExpanded;

  const SensorDetailsRow({
    super.key,
    required this.sensorData,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: isExpanded ? 30 : 5,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: _buildSensorDataDetails(sensorData),
    );
  }

  // Helper function to build sensor icons based on available data
  List<Widget> _buildSensorDataDetails(SensorData sensorData) {
    final List<SensorDataDetails> details = [];
    if (sensorData.temperature != null) {
      details.add(SensorDataDetails(
          icon: Icons.thermostat,
          label: "Temperature",
          value: "${sensorData.temperature}°C"));
    }
    if (sensorData.humidity != null) {
      details.add(SensorDataDetails(
          icon: Icons.water_drop,
          label: "Humidity",
          value: "${sensorData.humidity}%"));
    }
    if (sensorData.magnetPresent != null) {
      details.add(SensorDataDetails(
          icon: PhosphorIconsBold.magnetStraight,
          label: "Magnetic Field",
          value: sensorData.magnetPresent! ? "Detected" : "Not detected"));
    }
    if (sensorData.isMoving != null) {
      details.add(SensorDataDetails(
          icon: Icons.directions_walk,
          label: "Movement",
          value: sensorData.isMoving! ? "Moving" : "Still"));
    }
    if (sensorData.lowBattery != null) {
      details.add(SensorDataDetails(
          icon:
              sensorData.lowBattery! ? Icons.battery_alert : Icons.battery_full,
          label: "Battery",
          value: sensorData.lowBattery! ? "Low (<15%)" : "High"));
    }

    return details.map((detail) {
      if (isExpanded) {
        return SensorDetailsExpanded(details: detail);
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 10, top: 5),
          child: IconCircle(iconData: detail.icon),
        );
      }
    }).toList();
  }
}
