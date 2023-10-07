import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:myoty/components/map/marker_cluster_wrapper.dart';
import 'package:myoty/components/map/osm_view.dart';
import 'package:myoty/utils/extension.dart';

class TimelineMapView extends StatefulWidget {
  const TimelineMapView({
    required this.timeLatLngMap,
    required this.mapController,
    required this.selectedIndex,
    required this.onMarkerTap,
    required this.addressMap,
    required this.popupController,
    super.key,
  });
  final PopupController popupController;
  final Map<DateTime, LatLng> timeLatLngMap;
  final Map<LatLng, String> addressMap;
  final MapController mapController;
  final void Function(Marker) onMarkerTap;
  final int selectedIndex;

  @override
  State<TimelineMapView> createState() => _TimelineMapViewState();
}

class _TimelineMapViewState extends State<TimelineMapView> {
  @override
  Widget build(BuildContext context) {
    final markersWithTime = createMarkerWithTime(widget.timeLatLngMap);
    final markers = markersWithTime.values.toList(growable: false);
    final clientPrimaryColor = Theme.of(context).colorScheme.primary;
    return OSMView(
      controller: widget.mapController,
      boundsPadding: const EdgeInsets.fromLTRB(50, 50, 50, 400),
      markers: markers,
      markerClusterLayer: buildMarkerCluster(markersWithTime),
      polylineLayer: PolylineLayer(
        polylines: [
          Polyline(
            points: widget.timeLatLngMap.values.toList(),
            color: clientPrimaryColor,
            strokeWidth: 3,
          )
        ],
        //polylineCulling: true,
      ),
    );
  }

  MarkerClusterWrapper buildMarkerCluster(
    Map<DateTime, Marker> markersWithTime,
  ) {
    final markers = markersWithTime.values.toList(growable: false);
    return MarkerClusterWrapper(
      selectedIndex: widget.selectedIndex,
      markers: markers,
      popupController: widget.popupController,
      onMarkerTap: widget.onMarkerTap,
      centerMarkerOnClick: false,
      maxClusterRadius: 30,
      markerPopup: (context, marker) {
        final keyValue = marker.key! as ValueKey<int>;
        final time = markersWithTime.keys.elementAt(keyValue.value);
        final roundedLatLng = marker.point.round(decimals: 4);
        final splitted = widget.addressMap[roundedLatLng]?.splitFirst();
        final startOrEnd = keyValue.value == 0
            ? "End: "
            : keyValue.value == markers.length - 1
                ? "Start: "
                : "";
        return Chip(
          label: Text(
            '''
 $startOrEnd${time.formatToString()}  
 ${splitted?.$1} 
 ${splitted?.$2} ''',
            maxLines: 4,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Map<DateTime, Marker> createMarkerWithTime(Map<DateTime, LatLng> latLngList) {
    final markers = <DateTime, Marker>{};
    for (var i = 0; i < latLngList.length; i++) {
      //i = 0 => last position
      final latlongEnd = i >= 1 ? latLngList.entries.elementAt(i - 1) : null;
      final latlongStart = latLngList.entries.elementAt(i);
      final angle = latlongEnd != null
          ? DoubleExtension.calculateBearing(
              latlongStart.value,
              latlongEnd.value,
            )
          : 0.0;
      final marker = Marker(
        key: ValueKey<int>(i),
        point: latlongStart.value,
        builder: (context) {
          if (i == 0) {
            return markerIcon(i, Icons.location_pin);
          }
          return Transform.rotate(
            angle: angle + pi / 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.all(4),
                  ),
                ),
                markerIcon(i, Icons.arrow_circle_left),
              ],
            ),
          );
        },
      );
      markers[latlongStart.key] = marker;
    }
    return markers;
  }

  Icon markerIcon(int i, IconData iconData) {
    final clientPrimaryColor = Theme.of(context).colorScheme.primary;
    return Icon(
      iconData,
      weight: 3,
      color: widget.selectedIndex == i
          ? HexColor.getComplementaryColor(clientPrimaryColor)
          : clientPrimaryColor,
      size: widget.selectedIndex == i ? 35 : 30,
    );
  }
}
