import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myoty/model/equipment/equipment_details.dart';
import 'package:myoty/utils/extension.dart';

class TempHumChart extends StatefulWidget {
  const TempHumChart({
    required this.equipmentHistory,
    super.key,
  });
  final List<EquipmentData> equipmentHistory;

  @override
  State<TempHumChart> createState() => _TempHumChartState();
}

class _TempHumChartState extends State<TempHumChart> {
  List<Color> gradientColors = [
    AppColors.contentColorGreen,
    AppColors.contentColorBlue,
  ];
  List<FlSpot> spots = [];
  List<DateTime> time = [];
  bool hasValue2 = false;
  bool showValue2 = false;

  @override
  Widget build(BuildContext context) {
    createDataForChart(showValue2: showValue2);
    return chartView();
  }

  Column chartView() => Column(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                showValue2 = !showValue2;
              });
            },
            label: Text(showValue2 ? "Humidity" : "Temperature"),
            icon: showValue2
                ? const Icon(Icons.water_drop, color: Colors.blue)
                : const Icon(Icons.thermostat, color: Colors.red),
          ),
          AspectRatio(
            aspectRatio: 1.20,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: spots.isEmpty
                  ? const Center(child: Text("No data"))
                  : LineChart(mainData()),
            ),
          ),
        ],
      );

  void createDataForChart({bool showValue2 = false}) {
    final data = widget.equipmentHistory.reversed;
    spots = [];
    time = [];
    if (data.isNotEmpty && data.first.value2 != null) {
      hasValue2 = true;
    } else {
      hasValue2 = false;
    }
    for (var i = 0; i < data.length; i++) {
      final datum = data.elementAt(i);
      double? value;
      switch (showValue2) {
        case true:
          if (datum.value2 != null) {
            value = double.tryParse(datum.value2!);
          }
        case false:
          if (datum.value != null) {
            value = double.tryParse(datum.value!);
          }
      }
      if (value == null) {
        continue;
      }
      final spot = FlSpot(i.toDouble(), value);
      spots.add(spot);
      time.add(datum.maj);
    }
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: onTouch(),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: axisLabel(),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color.fromARGB(255, 123, 127, 131)),
      ),
      lineBarsData: barData,
    );
  }

  List<LineChartBarData> get barData {
    return [
      LineChartBarData(
        spots: spots,
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ];
  }

  FlTitlesData axisLabel() {
    return FlTitlesData(
      rightTitles: AxisTitles(
        sideTitles: SideTitles(),
      ),
      // leftTitles: AxisTitles(
      //   sideTitles: SideTitles(
      //     showTitles: true,
      //     reservedSize: 40,
      //     getTitlesWidget: (value, meta) {
      //       return Text(
      //         meta.formattedValue,
      //       );
      //     },
      //   ),
      // ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 70,
          getTitlesWidget: (value, meta) {
            if (value == meta.min) {
              return Container();
            }
            return Container(
              margin: const EdgeInsets.only(top: 50, right: 90),
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.rotationZ(-0.9),
                child: Text(
                  time[value.toInt()].formatToString(),
                ),
              ),
            );
          },
          interval: time.length.toDouble() / 5,
        ),
      ),
    );
  }

  LineTouchData onTouch() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        maxContentWidth: 100,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((touchedSpot) {
            final textStyle = TextStyle(
              color:
                  touchedSpot.bar.gradient?.colors[0] ?? touchedSpot.bar.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            final unit = showValue2 ? "%" : "°C";
            return LineTooltipItem(
              "${time[touchedSpot.spotIndex].formatToString()}:  ${touchedSpot.y}$unit",
              textStyle,
            );
          }).toList();
        },
      ),
    );
  }
}

class AppColors {
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorGreen = Color(0xFF3BFF49);
}
