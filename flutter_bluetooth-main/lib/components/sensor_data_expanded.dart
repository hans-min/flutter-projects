import 'package:bluetooth/components/sensor_card.dart';
import 'package:flutter/material.dart';

class SensorDataDetails {
  final IconData icon;
  final String label;
  final String value;

  SensorDataDetails(
      {required this.icon, required this.label, required this.value});
}

class SensorDetailsExpanded extends StatefulWidget {
  const SensorDetailsExpanded({
    super.key,
    required this.details,
  });

  final SensorDataDetails details;

  @override
  State<SensorDetailsExpanded> createState() => _SensorDetailsExpandedState();
}

class _SensorDetailsExpandedState extends State<SensorDetailsExpanded> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconCircle(
          iconData: widget.details.icon,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.details.label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              widget.details.value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
