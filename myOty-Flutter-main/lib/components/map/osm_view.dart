import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class OSMView extends StatelessWidget {
  const OSMView({
    required this.markers,
    required this.markerClusterLayer,
    super.key,
    this.controller,
    this.polylineLayer,
    this.boundsPadding,
  });
  final List<Marker> markers;
  final MapController? controller;
  final Widget markerClusterLayer;
  final Widget? polylineLayer;
  final EdgeInsets? boundsPadding;

  @override
  Widget build(BuildContext context) {
    LatLngBounds? bounds;
    if (markers.isNotEmpty) {
      final latLngList = markers.map((marker) => marker.point).toList();
      bounds = LatLngBounds.fromPoints(latLngList);
    }
    return buildFlutterMap(bounds);
  }

  Widget buildFlutterMap(LatLngBounds? bounds) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        keepAlive: true,
        center: LatLng(45.74, 4.85),
        bounds: bounds,
        boundsOptions: FitBoundsOptions(
          padding: boundsPadding != null
              ? boundsPadding!
              : const EdgeInsets.fromLTRB(20, 100, 20, 200),
        ),
      ),
      children: [
        TileLayer(
          updateInterval: const Duration(milliseconds: 800),
          maxNativeZoom: 18,
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'net.akensys.myotyv2Flutter',
          errorImage:
              const NetworkImage('https://tile.openstreetmap.org/18/0/0.png'),
        ),
        if (polylineLayer != null) polylineLayer!,
        markerClusterLayer,
      ],
    );
  }
}
