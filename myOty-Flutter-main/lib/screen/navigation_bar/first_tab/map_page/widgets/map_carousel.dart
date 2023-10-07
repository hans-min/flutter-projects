import 'package:flutter/material.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/screen/navigation_bar/first_tab/map_page/widgets/equipment_inkwell.dart';

class MapCardCarousel extends StatelessWidget {
  const MapCardCarousel({
    required this.equipments,
    required this.pageController,
    super.key,
  });
  final List<Equipment> equipments;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: SizedBox(
        height: 105,
        width: MediaQuery.of(context).size.width,
        child: buildPageSwipeView(),
      ),
    );
  }

  Widget buildPageSwipeView() {
    return PageView.builder(
      allowImplicitScrolling: true,
      controller: pageController,
      itemCount: equipments.length,
      itemBuilder: (context, index) {
        final equipmentWithData = equipments[index];
        return Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: EquipmentCardInkwell(
            equipment: equipmentWithData,
          ),
        );
      },
    );
  }
}
