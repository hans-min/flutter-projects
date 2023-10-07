import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:myoty/components/future_builder_with_progress.dart';
import 'package:myoty/components/map/marker_cluster_wrapper.dart';
import 'package:myoty/components/map/osm_view.dart';
import 'package:myoty/model/equipment/equipment.dart';
import 'package:myoty/screen/navigation_bar/first_tab/map_page/widgets/map_carousel.dart';
import 'package:myoty/screen/navigation_bar/first_tab/map_page/widgets/search_bar.dart';
import 'package:myoty/services/http.dart';
import 'package:myoty/utils/extension.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  Color clientPrimaryColor = Colors.blue;
  late Future<List<Equipment>> _equipmentListFuture;
  List<Equipment> _equipments = [];
  List<Marker> _markers = [];

  int selectedEqIndex = 0;
  Marker? get selectedMarker =>
      _markers.isEmpty ? null : _markers[selectedEqIndex];

  final MapController _mapController = MapController();
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    reloadMapData("");
    _pageController.addListener(_onSwipe);
  }

  @override
  void dispose() {
    log("disposing map page");
    _pageController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    clientPrimaryColor = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        buildFlutterMap(),
        MapSearchBar(
          onSubmitted: reloadMapData,
        ),
        MapCardCarousel(
          equipments: _equipments,
          pageController: _pageController,
        ),
      ],
    );
  }

  Widget buildFlutterMap() {
    return FutureBuilderWithLoadingBar(
      future: _equipmentListFuture,
      builderWithData: (context, data) {
        return OSMView(
          markers: _markers,
          controller: _mapController,
          markerClusterLayer: MarkerClusterWrapper(
            markers: _markers,
            onMarkerTap: _onMarkerTap,
            selectedIndex: selectedEqIndex,
          ),
        );
      },
    );
  }

  Future<void> reloadMapData(String searchText) async {
    log("fetch Equipment");
    _equipmentListFuture = _getMapData(searchText);
    _equipments = await _equipmentListFuture;
    _markers = createMarkers(_equipments);
    _setSelectedEqIndexAndUpdateUI();
  }

  Future<List<Equipment>> _getMapData(String searchText) async {
    {
      var equipmentListWithLatLng = <Equipment>[];
      await API
          .fetchEquipmentList(
            recherche: searchText,
          )
          .then(
            (eqs) => equipmentListWithLatLng = eqs
                .where(
                  (equipment) =>
                      equipment.lastLatitude != null &&
                      equipment.lastLongitude != null,
                )
                .toList(),
          );
      return equipmentListWithLatLng;
    }
  }

  List<Marker> createMarkers(List<Equipment> equipments) {
    final markers = <Marker>[];
    for (var i = 0; i < equipments.length; i++) {
      final equipment = equipments.elementAt(i);
      markers.add(_createMarker(equipment, i));
    }
    return markers;
  }

  Marker _createMarker(Equipment equipment, int i) {
    final coord = LatLng(equipment.lastLatitude!, equipment.lastLongitude!);
    return Marker(
      point: coord,
      builder: (context) => Icon(
        Icons.location_on,
        color: selectedEqIndex == i
            ? HexColor.getComplementaryColor(clientPrimaryColor)
            : clientPrimaryColor,
        size: selectedEqIndex == i ? 45 : null,
      ),
    );
  }

  //reference from pageController listener -> called whenever we swipe to new page
  // func: center Camera
  void _onSwipe() {
    if (_pageController.page!.round() != selectedEqIndex) {
      _setSelectedEqIndexAndUpdateUI();
      if (selectedMarker != null) {
        _mapController.animatedMapMove(selectedMarker!.point, this);
      }
    }
  }

  void _onMarkerTap(Marker marker) {
    if (marker == selectedMarker) {
      return;
    }
    _pageController.jumpToPage(_markers.indexOf(marker));
    _setSelectedEqIndexAndUpdateUI();
  }

  void _setSelectedEqIndexAndUpdateUI() {
    if (mounted) {
      setState(() {
        selectedEqIndex = _pageController.page!.round();
        if (selectedEqIndex >= _equipments.length) {
          selectedEqIndex = _equipments.length - 1;
        }
      });
    }
  }
}
