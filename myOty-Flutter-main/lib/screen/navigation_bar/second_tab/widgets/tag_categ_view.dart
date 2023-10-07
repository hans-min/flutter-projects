import 'package:flutter/material.dart';
import 'package:myoty/components/date_time_rich_text.dart';
import 'package:myoty/components/future_builder_with_progress.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/equipment_details.dart';

class TagCategView extends StatelessWidget {
  const TagCategView({required this.eqListFuture, super.key});
  //final List<Equipment> equipmentList = [];
  final Future<List<Equipment>> eqListFuture;
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWithLoadingBar(
      future: eqListFuture,
      builderWithData: (context, data) {
        final eqByCateg = populateEquipmentByCateg(data);
        return Column(
          children: List.generate(
            eqByCateg.length,
            (index) => EquipmentCategGroupCard(
              eqGroup: eqByCateg.entries.elementAt(index),
            ),
          ),
        );
      },
    );
  }

  /// Returns a map of equipments grouped by their category,
  /// then removes all empty categories.
  Map<TagCategEnum, List<Equipment>> populateEquipmentByCateg(
    List<Equipment> equipmentList,
  ) {
    final equipmentByCateg = <TagCategEnum, List<Equipment>>{};
    for (final categ in TagCategEnum.values) {
      equipmentByCateg[categ] = [];
    }
    for (final equipment in equipmentList) {
      final enumCateg = equipment.tag.tagCateg;
      equipmentByCateg[enumCateg]?.add(equipment);
    }
    equipmentByCateg.removeWhere((_, equipmentList) => equipmentList.isEmpty);

    return equipmentByCateg;
  }
}

class EquipmentCategGroupCard extends StatelessWidget {
  const EquipmentCategGroupCard({
    required this.eqGroup,
    super.key,
  });

  final MapEntry<TagCategEnum, List<Equipment>> eqGroup;

  @override
  Widget build(BuildContext context) {
    final categ = eqGroup.key;
    final eqList = eqGroup.value;

    return Card(
      elevation: 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: RichTextSpan(
              leading: categ.defaultIcon,
              text: " ${categ.categ.libelle}",
              defaultStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Divider(
            color: dividerColor(categ),
            thickness: 2.33,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eqList.length,
            itemBuilder: (context, index) {
              final equipment = eqList[index];
              return ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EquipmentDetails(
                      equipment: equipment,
                    ),
                  ),
                ),
                title: Text(equipment.libelle),
                subtitle: DateTimeRichText(dateTimeStr: equipment.lastUpdated),
                trailing: categ.iconWithValue(
                  equipment.lastValue,
                  equipment.lastValue2,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color dividerColor(TagCategEnum categ) {
    switch (categ) {
      case TagCategEnum.temperature:
        return Colors.red;

      case TagCategEnum.mov:
        return Colors.yellow.shade700;

      case TagCategEnum.door:
        return Colors.blue;

      case TagCategEnum.rht:
        return Colors.purple;

      default:
        return Colors.green;
    }
  }
}
