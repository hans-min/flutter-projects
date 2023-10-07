import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:myoty/utils/extension.dart';

class MarkerClusterWrapper extends StatelessWidget {
  const MarkerClusterWrapper({
    required this.markers,
    this.popupController,
    this.markerPopup,
    super.key,
    this.onMarkerTap,
    this.selectedIndex,
    this.centerMarkerOnClick = true,
    this.maxClusterRadius = 40,
  });
  final List<Marker> markers;

  final int? selectedIndex;
  final void Function(Marker)? onMarkerTap;
  final Widget Function(BuildContext, Marker)? markerPopup;
  final bool centerMarkerOnClick;
  final int maxClusterRadius;
  final PopupController? popupController;

  @override
  Widget build(BuildContext context) {
    final clientPrimaryColor = Theme.of(context).colorScheme.primary;
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        markers: markers,
        //TODO: make marker rotate around it bottom center
        rotate: false,
        // rotateOrigin: Offset.zero,
        // rotateAlignment: AlignmentDirectional.bottomCenter,
        onMarkerTap: onMarkerTap,
        centerMarkerOnClick: centerMarkerOnClick,
        maxClusterRadius: maxClusterRadius,
        builder: (context, markerCluster) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedIndex != null &&
                      markerCluster.contains(markers[selectedIndex!])
                  ? HexColor.getComplementaryColor(clientPrimaryColor)
                  : clientPrimaryColor,
            ),
            child: Center(
              child: Text(
                markerCluster.length.toString(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          );
        },
        popupOptions: markerPopup == null
            ? null
            : PopupOptions(
                markerTapBehavior: MarkerTapBehavior.none((_, __, ___) {}),
                popupBuilder: markerPopup!,
                popupState: PopupState(),
                popupController: popupController,
              ),
      ),
    );
  }
}
