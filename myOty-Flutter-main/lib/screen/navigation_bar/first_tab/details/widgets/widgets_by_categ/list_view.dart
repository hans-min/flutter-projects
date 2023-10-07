import 'package:flutter/material.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/utils/extension.dart';

class EquipmentDataListView extends StatelessWidget {
  const EquipmentDataListView({
    required this.equipmentData,
    required this.tagCateg,
    super.key,
  });
  final TagCategEnum tagCateg;

  final List<EquipmentData> equipmentData;

  @override
  Widget build(BuildContext context) {
    final duration = calculateDuration();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: equipmentData.length,
      itemBuilder: (context, index) {
        final equipmentDatum = equipmentData[index];
        final doorDuration = duration.isNotEmpty && index <= duration.length
            ? duration[index]
            : null;
        return ListTile(
          title: Text(
            equipmentDatum.maj.formatToString(isPreciseSeconds: true),
          ),
          trailing: value(equipmentDatum, doorDuration: doorDuration),
        );
      },
    );
  }

  Text value(EquipmentData equipmentDatum, {Duration? doorDuration}) {
    return tagCateg.iconWithValue(
      equipmentDatum.value,
      equipmentDatum.value2,
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
