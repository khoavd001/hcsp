import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hcsp/enum/mornitor_enum.dart';
import 'package:intl/intl.dart';

class Result {
  String time;
  double value;
  Result({
    required this.time,
    required this.value,
  });
}

class LineChartSample5 extends StatefulWidget {
  LineChartSample5({
    super.key,
    required this.monitorEnum,
  });
  final MonitorEnum monitorEnum;
  @override
  State<LineChartSample5> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartSample5>
    with TickerProviderStateMixin {
  List<int> showingTooltipOnSpots = [];
  String data = '0';
  List<Color> gradientColors = [
    Colors.green.withOpacity(0.5),
    Colors.greenAccent.withOpacity(0.5),
    Colors.greenAccent.withOpacity(0.3),
  ];
  List<double> _dataPoints = []; // Initial data points
  List<String> _axisX = [];
  List<Result> result = [];

  int count = -1;

  @override
  void initState() {
    super.initState();

    DatabaseReference databaseRef = FirebaseDatabase.instance
        .ref()
        .child('Monitor')
        .child(widget.monitorEnum.fetchString())
        .child('data');
    databaseRef.onValue.listen((event) {
      setState(() {
        if (_dataPoints.length > 9) {
          _dataPoints.removeAt(0);
          _axisX.removeAt(0);
          result.removeAt(0);
          addData(event);
        } else {
          addData(event);
        }
      });
    });
  }

  void addData(DatabaseEvent event) {
    // Get the current date and time

    final number = double.parse(event.snapshot.value.toString()) /
        widget.monitorEnum.divideNumber;

    log(number.toString());
    _dataPoints.add(number);
    if (_dataPoints.length < 10) {
      showingTooltipOnSpots.add(count + 1);
      count = count + 1;
    }
    _axisX.add(DateFormat('HH:mm:ss').format(DateTime.now()));
    result.add(Result(
        time: DateFormat('HH:mm:ss').format(DateTime.now()),
        value: double.parse(event.snapshot.value.toString())));
  }

  List<FlSpot> get allSpots => List.generate(_dataPoints.length, (index) {
        double yValue = _dataPoints[index];
        return FlSpot(index.toDouble(), yValue);
      });

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
        fontWeight: FontWeight.bold, fontFamily: 'Digital', fontSize: 18);
    String text;
    if (value.toInt() < _axisX.length) {
      text = _axisX[value.toInt()];
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '${1 * widget.monitorEnum.divideNumber}';
        break;
      case 2:
        text = '${2 * widget.monitorEnum.divideNumber}';
        break;
      case 3:
        text = '${3 * widget.monitorEnum.divideNumber}';
        break;
      case 4:
        text = '${4 * widget.monitorEnum.divideNumber}';
        break;
      case 5:
        text = '${5 * widget.monitorEnum.divideNumber}';
        break;
      case 6:
        text = '${6 * widget.monitorEnum.divideNumber}';
        break;
      case 7:
        text = '${7 * widget.monitorEnum.divideNumber}';
        break;
      case 8:
        text = '${8 * widget.monitorEnum.divideNumber}';
        break;
      case 9:
        text = '${9 * widget.monitorEnum.divideNumber}';
        break;
      case 10:
        text = '${10 * widget.monitorEnum.divideNumber}';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        // showingIndicators: showingTooltipOnSpots,
        spots: _dataPoints.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value);
        }).toList(),
        isCurved: true,
        barWidth: 4,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: gradientColors,
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Padding(
      padding: const EdgeInsets.all(50),
      child: Row(
        children: [
          DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.green[300]!),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.green[100]!),
            columns: [
              DataColumn(
                label: Text(
                  widget.monitorEnum.titleString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  'Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: result
                .map(
                  (e) => DataRow(cells: [
                    DataCell(Text(
                      '${e.value.toString()} ${widget.monitorEnum.getUnit()}',
                      style: TextStyle(
                        color: Colors.green[900],
                      ),
                    )),
                    DataCell(Text(
                      e.time,
                      style: TextStyle(
                        color: Colors.green[900],
                      ),
                    )),
                  ]),
                )
                .toList(),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 2.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return LineChart(
                    LineChartData(
                      // showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                      //   log('lineBarsData.indexOf(tooltipsOnBar): ${_dataPoints[0]}');
                      //   return ShowingTooltipIndicators(
                      //     [
                      //       LineBarSpot(
                      //         tooltipsOnBar,
                      //         lineBarsData.indexOf(tooltipsOnBar),
                      //         FlSpot(index.toDouble(), _dataPoints[index]),
                      //       ),
                      //     ],
                      //   );
                      // }).toList(),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: false,
                        touchCallback:
                            (FlTouchEvent event, LineTouchResponse? response) {
                          if (response == null ||
                              response.lineBarSpots == null) {
                            return;
                          }
                          if (event is FlTapUpEvent) {
                            final spotIndex =
                                response.lineBarSpots!.first.spotIndex;
                            setState(() {
                              if (showingTooltipOnSpots.contains(spotIndex)) {
                                showingTooltipOnSpots.remove(spotIndex);
                              } else {
                                showingTooltipOnSpots.add(spotIndex);
                              }
                            });
                          }
                        },
                        mouseCursorResolver:
                            (FlTouchEvent event, LineTouchResponse? response) {
                          if (response == null ||
                              response.lineBarSpots == null) {
                            return SystemMouseCursors.basic;
                          }
                          return SystemMouseCursors.click;
                        },
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((index) {
                            return TouchedSpotIndicatorData(
                              const FlLine(
                                color: Colors.green,
                              ),
                              FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                  radius: 8,
                                  color: lerpGradient(
                                    barData.gradient!.colors,
                                    barData.gradient!.stops!,
                                    percent / 100,
                                  ),
                                  strokeWidth: 2,
                                  strokeColor: Colors.blue,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Colors.green,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((lineBarSpot) {
                              return LineTooltipItem(
                                lineBarSpot.y.toString(),
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: lineBarsData,
                      minX: 0,
                      maxX: 11,
                      minY: 0,
                      maxY: 10,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: leftTitleWidgets,
                            reservedSize: 42,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return bottomTitleWidgets(
                                value,
                                meta,
                                constraints.maxWidth * 0.7,
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 0,
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1) * index;
      stops.add(percent);
    });
  }

  for (var i = 0; i < stops.length - 1; i++) {
    if (t >= stops[i] && t <= stops[i + 1]) {
      final sectionT = (t - stops[i]) / (stops[i + 1] - stops[i]);
      return Color.lerp(colors[i], colors[i + 1], sectionT)!;
    }
  }

  return colors.last;
}
