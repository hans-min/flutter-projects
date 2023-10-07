import 'package:flutter/material.dart';
import 'package:myoty/components/future_builder_with_progress.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/sites_details.dart';
import 'package:myoty/screen/navigation_bar/second_tab/widgets/grid_view.dart';
import 'package:myoty/screen/navigation_bar/second_tab/widgets/tag_categ_view.dart';
import 'package:myoty/services/http.dart';
import 'package:myoty/services/shared_pref_manager.dart';
import 'package:myoty/utils/extension.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with AutomaticKeepAliveClientMixin<StatisticsPage> {
  final List<bool> _selectedViews = <bool>[true, false];
  Future<SiteDetails> siteDetailsFuture = API.fetchSiteDetails();
  Future<List<Equipment>> eqListFuture = API.fetchEquipmentList();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilderWithLoadingBar(
      future: siteDetailsFuture,
      builderWithData: (context, data) {
        final siteDetails = data;
        for (final site in siteDetails.sites) {
          final plans = site.plan;
          final siteName = site.libelle;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _selectedViews.first
                    ? siteDetailsFuture = API.fetchSiteDetails()
                    : eqListFuture = API.fetchEquipmentList();
              });
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAlertRow(siteDetails),
                  const SizedBox(height: 5),
                  buildToggleButtons(),
                  if (_selectedViews.first)
                    SiteGridList(plans: plans, siteName: siteName)
                  else
                    TagCategView(eqListFuture: eqListFuture),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("No data"));
      },
    );
  }

  Column buildAlertRow(SiteDetails siteDetails) => Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Alert".toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildAlertCard(
                  "Out of Zone",
                  Icons.logout,
                  siteDetails.alerteZone,
                ),
              ),
              Expanded(
                child: _buildAlertCard(
                  "Door Opened",
                  Icons.meeting_room,
                  siteDetails.alerteMag,
                ),
              ),
              Expanded(
                child: _buildAlertCard(
                  "Temperature Alert",
                  Icons.thermostat_rounded,
                  siteDetails.alerteTemperature,
                ),
              ),
              Expanded(
                child: _buildAlertCard(
                  "Low Battery",
                  Icons.battery_1_bar,
                  siteDetails.batterieFaible,
                ),
              ),
            ],
          ),
        ],
      );

  Row buildToggleButtons() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          isSelected: _selectedViews,
          onPressed: (int index) {
            setState(() {
              for (var i = 0; i < _selectedViews.length; i++) {
                _selectedViews[i] = i == index;
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          //selectedBorderColor: Colors.green[700],
          selectedColor: Colors.white,
          fillColor: primaryColor,
          //color: Colors.green[400],
          constraints: const BoxConstraints(
            minHeight: 40,
            minWidth: 150,
          ),
          children: const [Text("By Zone"), Text("By Tag Category")],
        ),
      ],
    );
  }

  Card _buildAlertCard(String title, IconData iconData, int number) {
    final color = SharedPrefs.networkColor != null
        ? HexColor.fromHex(SharedPrefs.networkColor!)
        : Colors.lightBlue;
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.blueGrey),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Badge(
              alignment: const AlignmentDirectional(16, -4),
              label: Text(number.toString()),
              textStyle: const TextStyle(fontSize: 12),
              backgroundColor: Colors.red,
              child: Icon(
                iconData,
                color: color,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
