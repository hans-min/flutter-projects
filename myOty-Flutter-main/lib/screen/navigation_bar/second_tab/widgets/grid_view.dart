// ignore_for_file:

import 'package:flutter/material.dart';
import 'package:myoty/model/sites_details.dart';
import 'package:myoty/screen/navigation_bar/second_tab/widgets/equipment_table_view.dart';

class SiteGridList extends StatelessWidget {
  const SiteGridList({
    required this.plans,
    required this.siteName,
    super.key,
  });

  final List<Plan> plans;
  final String siteName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        plans.length,
        (index) => SiteGridView(
          title: "$siteName - ${plans[index].libelle}",
          zones: plans[index].zone,
        ),
      ),
    );
  }
}

class SiteGridView extends StatelessWidget {
  const SiteGridView({
    required this.title,
    required this.zones,
    super.key,
  });
  final String title;
  final List<Zone> zones;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        buildGridView(zones, context),
      ],
    );
  }

  Widget buildGridView(List<Zone> zones, BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List<Widget>.generate(
        zones.length,
        (index) => _buildGridCard(zones[index], context),
      ),
    );
  }

  Widget _buildGridCard(Zone zone, BuildContext context) {
    // final Color color = SharedPrefs.networkColor != null
    //     ? HexColor.fromHex(SharedPrefs.networkColor!)
    //     : Colors.white;
    // log(zone.libelle);
    // log("${zone.a}, ${zone.r}, ${zone.g}, ${zone.b}");
    // final c = Color.fromARGB(zone.a, zone.r, zone.g, zone.b);
    // final h = c.toHex();
    // log(h);
    return Card(
      color: Color.fromARGB(zone.a + 128, zone.r, zone.g, zone.b),
      child: InkWell(
        onTap: () => {
          if (zone.nbObjet > 0)
            {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  title: Text(
                    zone.libelle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  content: EquipmentTableView(zone: zone),
                ),
              ),
            }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              zone.libelle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              zone.nbObjet.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
