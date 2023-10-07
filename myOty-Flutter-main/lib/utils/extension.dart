import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

extension StringExtension on String {
  (String, String) splitFirst({String separator = ", "}) {
    final separatorPosition = indexOf(separator);
    if (separatorPosition == -1) {
      return (this, "");
    }
    return (
      substring(0, separatorPosition),
      substring(separatorPosition + separator.length)
    );
  }
}

extension DateString on String {
  /// Format a iso8601 String to a time string in local time zone.
  ///
  /// if `isPreciseSeconds` is `true`, `withTime` will be ignored, and
  /// the format will be seconds-precised,
  /// else, the format will be minutes-precised if `withTime` is `true`,
  /// and the format will contains date only if `withTime` is `false`.
  String iso8601ToString({
    bool withTime = true,
    bool isPreciseSeconds = false,
  }) {
    final date = DateTime.tryParse(this);
    if (date == null) {
      log("Invalid dateTime format: $this");
      return "";
    }
    return date.formatToString(
      withTime: withTime,
      isPreciseSeconds: isPreciseSeconds,
    );
  }
}

extension DateFormatter on DateTime {
  /// Format a `DateTime` to a string in local time zone.
  ///
  /// if `isPreciseSeconds` is `true`, `withTime` will be ignored, and
  /// the format will be seconds-precised,
  /// else, the format will be minutes-precised if `withTime` is `true`,
  /// and the format will contains date only if `withTime` is `false`.
  String formatToString({
    bool withTime = true,
    bool isPreciseSeconds = false,
  }) {
    String formatString;
    formatString = isPreciseSeconds
        ? "yyyy-MM-dd HH:mm:ss"
        : withTime
            ? "yyyy-MM-dd HH:mm"
            : "yyyy-MM-dd";
    final format = DateFormat(formatString);
    return format.format(toLocal());
  }
}

extension DurationFormatter on Duration {
  String toHumanReadableString() {
    var seconds = inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final tokens = <String>[];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    if (tokens.isEmpty || seconds != 0) {
      tokens.add('${seconds}s');
    }

    return tokens.join(' ');
  }
}

extension HexColor on Color {
  /// String with format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color getComplementaryColor(Color color) {
    final red = 255 - color.red;
    final green = 255 - color.green;
    final blue = 255 - color.blue;
    return Color.fromARGB(255, red, green, blue);
  }

  /// Prefixes a hash sign according to [leadingHashSign] (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
}

extension AnimatedMoveMapController on MapController {
  void animatedMapMove(LatLng destLocation, TickerProvider owner) {
    // Create some tweens. These serve to split up the transition from one
    // location to another. In our case, we want to split the transition
    // be<tween> our current map center and the destination.
    final latTween =
        Tween<double>(begin: center.latitude, end: destLocation.latitude);
    final lngTween =
        Tween<double>(begin: center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: zoom, end: zoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: owner,
    );
    // The animation determines what path the animation will take. You can try
    //different Curves values, although I found fastOutSlowIn to be my favorite.
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}

extension DoubleExtension on double {
  /// Calculates the initial bearing between two points
  ///
  /// The initial bearing will most of the time be different than the end
  /// bearing, see https://www.movable-type.co.uk/scripts/latlong.html#bearing.
  static double calculateBearing(
    LatLng start,
    LatLng end,
  ) {
    final startLongitudeRadians = degToRadian(start.longitude);
    final startLatitudeRadians = degToRadian(start.latitude);
    final endLongitudeRadians = degToRadian(end.longitude);
    final endLatitudeRadians = degToRadian(end.latitude);
    final deltaLong = endLongitudeRadians - startLongitudeRadians;

    final x = math.sin(deltaLong) * math.cos(endLatitudeRadians);

    final y = math.cos(startLatitudeRadians) * math.sin(endLatitudeRadians) -
        math.sin(startLatitudeRadians) *
            math.cos(endLatitudeRadians) *
            math.cos(deltaLong);
    return math.atan2(x, y);
  }
}
