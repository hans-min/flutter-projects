import 'package:flutter/material.dart';
import 'package:myoty/components/date_time_rich_text.dart';
import 'package:myoty/components/future_builder_with_progress.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/sites_details.dart';
import 'package:myoty/services/http.dart';

class EquipmentTableView extends StatelessWidget {
  const EquipmentTableView({
    required this.zone,
    super.key,
  });
  final Zone zone;

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme.primary;
    return FutureBuilderWithLoadingBar(
      future: API.fetchEquipmentInZone(zone.id),
      builderWithData: (_, data) => buildTable(data, appColor),
    );
  }

  Table buildTable(List<Equipment> equipments, Color color) {
    final header = TableRow(
      children: [
        Text(
          "Name",
          style: TextStyle(color: color),
        ),
        Text("Last Updated", style: TextStyle(color: color)),
        Text("Inside Zone", style: TextStyle(color: color)),
      ],
    );
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder(horizontalInside: BorderSide(color: color)),
      children: [
        header,
        ...List.generate(
          zone.nbObjet,
          (index) => buildRow(equipments[index], color),
        ),
      ],
    );
  }

  TableRow buildRow(Equipment equipment, Color color) {
    final icon = checkInsideZone(equipment) ? Icons.check_box : Icons.close;
    return TableRow(
      children: [
        Text(equipment.libelle),
        DateTimeRichText(
          dateTimeStr: equipment.lastUpdated ?? "Never updated",
          hasIcon: false,
        ),
        Icon(icon, color: color),
      ],
    );
  }

  bool checkInsideZone(Equipment equipment) {
    final tagCurrentZone = equipment.tag.currentZone;
    if (tagCurrentZone == null) return false;
    return zone.id == tagCurrentZone.id;
  }
}
