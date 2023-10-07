import 'package:flutter/material.dart';
import 'package:myoty/components/date_time_rich_text.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/equipment_details.dart';
import 'package:myoty/services/http.dart';

class EquipmentCardInkwell extends StatefulWidget {
  const EquipmentCardInkwell({
    required this.equipment,
    super.key,
  });
  final Equipment equipment;

  @override
  State<EquipmentCardInkwell> createState() => _EquipmentCardInkwellState();
}

class _EquipmentCardInkwellState extends State<EquipmentCardInkwell> {
  Image? image;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  void didUpdateWidget(covariant EquipmentCardInkwell oldWidget) {
    if (oldWidget.equipment != widget.equipment) {
      getImage();
    }
    super.didUpdateWidget(oldWidget);
  }

  void getImage() {
    final equipmentMedia = widget.equipment.images;
    setState(() {
      image = null;
    });
    if (equipmentMedia != null && equipmentMedia.isNotEmpty) {
      _getImageFromBase64(equipmentMedia.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final equipment = widget.equipment;
    final categEnum = equipment.tag.tagCateg;
    final hasImage = image != null;
    return InkWell(
      onTap: () => _onCardTap(equipment, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasImage)
            decorationImage(equipment)
          else
            const SizedBox(
              width: 5,
            ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: dataColumn(equipment, categEnum),
            ),
          ),
        ],
      ),
    );
  }

  Column dataColumn(Equipment equipment, TagCategEnum categEnum) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          equipment.libelle,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 5,
        ),
        DateTimeRichText(
          dateTimeStr: equipment.lastUpdated,
          style: Theme.of(context).textTheme.bodySmall,
          hasIcon: false,
        ),
        const SizedBox(
          height: 3,
        ),
        categEnum.iconWithValue(
          equipment.lastValue,
          equipment.lastValue2,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Expanded decorationImage(Equipment equipment) => Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10),
            ),
            image: DecorationImage(image: image!.image, fit: BoxFit.cover),
          ),
        ),
      );

  Future<void> _getImageFromBase64(int id) async {
    try {
      image = await ImageAPI.fetchImageFromMediaID(id: id);
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void _onCardTap(Equipment selectedEq, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<EquipmentDetails>(
        builder: (context) => EquipmentDetails(
          equipment: selectedEq,
          //image: selectedEq.image,
        ),
      ),
    );
  }
}
