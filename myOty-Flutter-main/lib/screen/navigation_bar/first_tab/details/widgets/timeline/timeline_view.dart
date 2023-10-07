import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/model/equipment/tag_categ_enum.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/timeline/timeline_map_view.dart';
import 'package:myoty/screen/navigation_bar/first_tab/details/widgets/timeline/timeline_panel.dart';
import 'package:myoty/utils/extension.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({
    required this.equipmentData,
    required this.tagCateg,
    super.key,
  });
  final TagCategEnum tagCateg;
  final List<EquipmentData> equipmentData;

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  ScrollController _scrollController = ScrollController();
  final PopupController _popupController = PopupController();
  int selectedIndex = 0;
  Map<DateTime, LatLng> timeLatLngMap = {};
  //Make placemarks global
  Map<LatLng, String> addressMap = {};
  final int listTileHeight = 75;
  final listTopPadding = 60;
  @override
  void initState() {
    super.initState();
    timeLatLngMap = createLatLngList();
    //TODO: save in SharedPrefs
    getPlacemark(timeLatLngMap.values);
  }

  ///round the LatLng to 4 decimal point (10m of precision), if [addressMap]
  ///(`SharedPrefs` variable) doesn't include the rounded latLng, add it to [addressMap]
  Future<void> getPlacemark(Iterable<LatLng> latLngList) async {
    final roundedLatLngs =
        latLngList.map((latLng) => latLng.round(decimals: 4));
    for (final latLng in roundedLatLngs) {
      if (addressMap[latLng] == null) {
        final placemark =
            await placemarkFromCoordinates(latLng.latitude, latLng.longitude)
                .then((placemarksList) {
          return placemarksList.elementAt(0);
        });
        final showPostalCode = placemark.name != placemark.postalCode;
        final address =
            "${placemark.name}${showPostalCode ? ", ${placemark.postalCode}" : ""} ${placemark.locality}, ${placemark.isoCountryCode} ";
        addressMap[latLng] = address;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4 * 3,
      child: SlidingUpPanel(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        minHeight: 75,
        maxHeight: 200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        panelBuilder: (sc) => buildTimelinePanel(sc),
        collapsed: Center(
          child: Text(
            "Timeline",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        //header: Text("Timeline"),
        body: TimelineMapView(
          selectedIndex: selectedIndex,
          timeLatLngMap: timeLatLngMap,
          mapController: _mapController,
          popupController: _popupController,
          onMarkerTap: onMarkerTap,
          addressMap: addressMap,
        ),
      ),
    );
  }

  Widget buildTimelinePanel(ScrollController sc) {
    _scrollController = sc;
    _scrollController.addListener(onScroll);

    return TimelinePanel(
      timeLatLngMap: timeLatLngMap,
      scrollController: _scrollController,
      addressMap: addressMap,
      selectedIndex: selectedIndex,
      equipmentData: widget.equipmentData,
      tagCateg: widget.tagCateg,
      listTileHeight: listTileHeight,
      listTopPadding: listTopPadding,
    );
  }

  void onScroll() {
    final index = (_scrollController.offset / listTileHeight).round();
    if (selectedIndex != index && index >= 0 && index < timeLatLngMap.length) {
      setSelectedMarker(index);
      _popupController.hideAllPopups();
    }
  }

  void onMarkerTap(Marker marker) {
    //center marker on top
    // move the scroll
    final keyValue = marker.key! as ValueKey<int>;
    _scrollController
        .jumpTo(listTopPadding + listTileHeight * (keyValue.value - 1));
    _popupController.showPopupsOnlyFor([marker]);
  }

  void setSelectedMarker(int index) {
    setState(() {
      selectedIndex = index;
      final latLng = timeLatLngMap.values.elementAt(selectedIndex);
      final point = _mapController.latLngToScreenPoint(latLng);
      final destPoint = CustomPoint(point!.x, point.y + 200);
      final dest = _mapController.pointToLatLng(destPoint);
      _mapController.animatedMapMove(dest!, this);
    });
  }

  Map<DateTime, LatLng> createLatLngList() {
    final eqWithLatLng = widget.equipmentData
        .where(
          (equipmentDatum) =>
              equipmentDatum.latitude != null &&
              equipmentDatum.longitude != null,
        )
        .toList();
    final latLngList = eqWithLatLng.map(
      (equipmentDatum) => MapEntry(
        equipmentDatum.maj,
        LatLng(
          double.parse(equipmentDatum.latitude!),
          double.parse(equipmentDatum.longitude!),
        ),
      ),
    );
    return Map.fromEntries(latLngList);
  }
}
