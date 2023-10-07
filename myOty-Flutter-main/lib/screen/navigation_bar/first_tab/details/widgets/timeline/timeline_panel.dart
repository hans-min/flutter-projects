import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:myoty/components/date_time_rich_text.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/utils/extension.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    required this.timeLatLngMap,
    required this.scrollController,
    required this.selectedIndex,
    required this.addressMap,
    required this.equipmentData,
    required this.tagCateg,
    required this.listTileHeight,
    required this.listTopPadding,
    super.key,
  });
  final List<EquipmentData> equipmentData;
  final TagCategEnum tagCateg;

  final Map<DateTime, LatLng> timeLatLngMap;
  final ScrollController scrollController;
  final int selectedIndex;
  final Map<LatLng, String> addressMap;
  final int listTileHeight;
  final int listTopPadding;

  @override
  Widget build(BuildContext context) {
    final clientPrimaryColor = Theme.of(context).colorScheme.primary;
    final duration = calculateDuration();
    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 60, left: 30, bottom: 60),
          itemCount: timeLatLngMap.length,
          itemExtent: listTileHeight.toDouble(),
          itemBuilder: (context, index) {
            final doorDuration = duration.isNotEmpty && index <= duration.length
                ? duration[index]
                : null;
            return buildListTile(index, doorDuration);
          },
        ),
        Positioned(
          top: 85,
          child: Icon(
            Icons.my_location_sharp,
            color: HexColor.getComplementaryColor(clientPrimaryColor),
          ),
        ),
      ],
    );
  }

  Widget buildListTile(int i, Duration? doorDuration) {
    final data = timeLatLngMap.entries.elementAt(i);
    final latLng = data.value.round(decimals: 4);
    final address = addressMap[latLng];
    final expression = selectedIndex == i
        ? const TextStyle(fontWeight: FontWeight.w800)
        : null;

    final equipmentDatum = equipmentData[i];

    return ColoredBox(
      color: selectedIndex == i ? Colors.grey[200]! : Colors.transparent,
      child: ListTile(
        selected: selectedIndex == i,
        dense: true,
        isThreeLine: true,
        horizontalTitleGap: 0,
        title: DateTimeRichText(dateTime: data.key, style: expression),
        subtitle: address != null
            ? Text(address, style: expression)
            : Text("Lat: ${latLng.latitude} - Long: ${latLng.longitude}"),
        trailing: value(equipmentDatum, doorDuration: doorDuration),
        titleAlignment: ListTileTitleAlignment.top,
      ),
    );
  }

  Text value(EquipmentData equipmentDatum, {Duration? doorDuration}) {
    return tagCateg.iconWithValue(
      equipmentDatum.value,
      equipmentDatum.value2,
      style: const TextStyle(fontSize: 12),
      durationForMag: doorDuration?.toHumanReadableString(),
    );
  }

  List<Duration> calculateDuration() {
    final duration = <Duration>[];
    if (equipmentData.isEmpty) return duration;
    if (tagCateg == TagCategEnum.door ||
        tagCateg == TagCategEnum.ineosenseSwitchTOF) {
      final latestMaj = equipmentData[0].maj;
      final timeDifference = DateTime.now().difference(latestMaj);
      duration.add(timeDifference);
      for (var i = 1; i < equipmentData.length; i++) {
        final currentMaj = equipmentData[i - 1].maj;
        final nextMaj = equipmentData[i].maj;
        final timeDifference = currentMaj.difference(nextMaj);
        duration.add(timeDifference);
      }
    }
    return duration;
  }
}
