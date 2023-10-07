import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myoty/components/future_builder_with_progress.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/bluetooth/bluetooth_scan_page.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/date_range_picker.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/photos/photo_viewer.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/timeline/timeline_view.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/widgets_by_categ/chart_view.dart';
import 'package:myoty/services/http.dart';

class EquipmentDetails extends StatefulWidget {
  const EquipmentDetails({
    required this.equipment,
    super.key,
  });
  final Equipment equipment;

  @override
  State<EquipmentDetails> createState() => _EquipmentDetailsState();
}

class _EquipmentDetailsState extends State<EquipmentDetails> {
  late Future<List<EquipmentData>> historyFuture;
  List<TagCategEnum> bluetoothTags = [
    TagCategEnum.bluetoothID,
    TagCategEnum.temperature,
    TagCategEnum.rht,
    TagCategEnum.door,
    TagCategEnum.mov,
    TagCategEnum.elaPIR,
    TagCategEnum.elaBuzz,
    TagCategEnum.padlock,
  ];

  @override
  void initState() {
    super.initState();
    getEquipmentData();
  }

  Future<void> getEquipmentData({DateTimeRange? dateRange}) async {
    historyFuture =
        API.fetchEquipmentHistory(widget.equipment.uuid, dateRange: dateRange);
    log("get eq data");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagCateg = widget.equipment.tag.tagCateg;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          if (tagCateg == TagCategEnum.temperature ||
              tagCateg == TagCategEnum.rht)
            openChartViewButton()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getEquipmentData,
        child: Scrollbar(
          thickness: 6,
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  PhotoViewer(equipment: widget.equipment),
                  const SizedBox(height: 15),
                  if (bluetoothTags.contains(tagCateg))
                    BluetoothScanPage(
                      tagName: widget.equipment.tag.name!,
                      autoScanConnect: tagCateg == TagCategEnum.padlock,
                    ),
                  const SizedBox(height: 15),
                  DateRangePickerRow(
                    didGetDateRange: (dateRange) {
                      setState(() {
                        getEquipmentData(dateRange: dateRange);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTimelineMapView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton openChartViewButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(),
                body: FutureBuilderWithLoadingBar(
                  future: historyFuture,
                  builderWithData: (context, data) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(top: 80),
                      child: TempHumChart(
                        equipmentHistory: data,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      icon: const Icon(Icons.area_chart),
    );
  }

  FutureBuilderWithLoadingBar<List<EquipmentData>> buildTimelineMapView() {
    return FutureBuilderWithLoadingBar(
      future: historyFuture,
      builderWithData: (context, data) {
        final tagCateg = widget.equipment.tag.tagCateg;
        return TimelineView(
          equipmentData: data,
          tagCateg: tagCateg,
        );
      },
    );
  }
}
