import 'package:bluetooth/components/sensor_data_row.dart';
import 'package:bluetooth/models.dart';
import 'package:bluetooth/decoder/sensor_decoder.dart';
import 'package:flutter/material.dart';

class SensorCard extends StatefulWidget {
  final ScanResultWrapper deviceInfo;

  const SensorCard({
    super.key,
    required this.deviceInfo,
  });

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sensorData = decodeData(widget.deviceInfo);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.deviceInfo.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.deviceInfo.macAddress.str,
                        style: theme.textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.signal_cellular_alt,
                            color: Colors.green,
                          ),
                          Text(
                            '${widget.deviceInfo.rssi} dBm',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.deviceInfo.manufacturerData != null)
                  Expanded(
                      child: _buildRichText(
                        'Company',
                        widget.deviceInfo.manufacturerData!.company.name,
                      ),
                    ),
                  if (widget.deviceInfo.serviceData != null)
                    _buildRichText(
                      "Service UUID",
                      "0x${widget.deviceInfo.serviceData!.serviceUUID}",
                    ),
                  const SizedBox(width: 10),
                  IconCircle(
                    iconData: isExpanded  
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    backgroundColor:
                        theme.colorScheme.secondary.withOpacity(0.2),
                  ),
                ],
              ),
              if (isExpanded && widget.deviceInfo.serviceData != null)
                _buildRichText(
                  "Service Data",
                  "0x${widget.deviceInfo.serviceData?.hexData()}",
                ),
              if (isExpanded && widget.deviceInfo.manufacturerData != null)
                _buildRichText(
                  "Manufacturer Data",
                  "0x${widget.deviceInfo.manufacturerData?.hexData()}",
                ),
              const SizedBox(height: 10),
              if (sensorData != null)
                SensorDetailsRow(
                  sensorData: sensorData,
                  isExpanded: isExpanded,
                ),
              // Sensor Icons
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildRichText(String label, String value) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      overflow: TextOverflow.visible,
    );
  }
}

class IconCircle extends StatelessWidget {
  const IconCircle({
    super.key,
    this.color,
    this.backgroundColor,
    required this.iconData,
  });

  final Color? color;
  final Color? backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 17,
      backgroundColor: backgroundColor,
      child: Icon(
        iconData,
        size: 17,
        color: color,
      ),
    );
  }
}
