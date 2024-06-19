import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hcsp/enum/mornitor_enum.dart';
import 'package:intl/intl.dart'; // Import DateFormat

class BarResult {
  String time;
  double cO2;
  double rpm;
  BarResult({
    required this.time,
    required this.cO2,
    required this.rpm,
  });
}

class BarChartSample2 extends StatefulWidget {
  BarChartSample2({super.key});
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.red;
  final Color avgColor = Colors.greenAccent;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 10;
  Timer? _timer;
  double cO2Num = 0;
  double rPMNum = 0;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  List<BarResult> result = [];
  int touchedGroupIndex = -1;
  DateTime initialTime = DateTime.now();
  int i = 0;
  List<String> timerLine = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('Monitor');
    databaseRef
        .child(MonitorEnum.cO2.fetchString())
        .child('data')
        .onValue
        .listen((event) {
      cO2Num = double.parse(event.snapshot.value.toString());
    });
    databaseRef
        .child(MonitorEnum.exhaustFan.fetchString())
        .child('data')
        .onValue
        .listen((event) {
      rPMNum = double.parse(event.snapshot.value.toString());
    });
    _startTimer();

    rawBarGroups = [];
    showingBarGroups = List.of(rawBarGroups);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _executePeriodicTask();
    });
  }

  void _executePeriodicTask() {
    setState(() {
      if (rawBarGroups.length >= 10) {
        rawBarGroups.removeAt(0);
        timerLine.removeAt(0);
        result.removeAt(0);
      }

      rawBarGroups.add(makeGroupData(
        rawBarGroups.length,
        cO2Num,
        rPMNum,
      ));
      timerLine.add(DateFormat('HH:mm:ss').format(initialTime));
      initialTime = initialTime.add(Duration(seconds: 2)); // Update time
      showingBarGroups = List.of(rawBarGroups);
      result.add(BarResult(
          time: DateFormat('HH:mm:ss').format(initialTime),
          cO2: cO2Num,
          rpm: rPMNum));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.green[300]!),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.green[100]!),
            columns: [
              const DataColumn(
                label: Text(
                  'Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  MonitorEnum.cO2.titleString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  MonitorEnum.exhaustFan.titleString(),
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
                      e.time,
                      style: TextStyle(
                        color: Colors.green[900],
                      ),
                    )),
                    DataCell(Text(
                      '${e.cO2.toString()} ${MonitorEnum.cO2.getUnit()}',
                      style: TextStyle(
                        color: Colors.green[900],
                      ),
                    )),
                    DataCell(Text(
                      '${e.rpm.toString()} ${MonitorEnum.exhaustFan.getUnit()}',
                      style: TextStyle(
                        color: Colors.green[900],
                      ),
                    )),
                  ]),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      makeTransactionsIcon(),
                      const SizedBox(
                        width: 38,
                      ),
                      const Text(
                        'Transactions',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        '',
                        style:
                            TextStyle(color: Color(0xff77839a), fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: 2000,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: ((group) {
                              return Colors.grey;
                            }),
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                          touchCallback: (FlTouchEvent event, response) {
                            if (response == null || response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;

                            setState(() {
                              if (!event.isInterestedForInteractions) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                                return;
                              }
                              showingBarGroups = List.of(rawBarGroups);
                              if (touchedGroupIndex != -1) {
                                var sum = 0.0;
                                for (final rod
                                    in showingBarGroups[touchedGroupIndex]
                                        .barRods) {
                                  sum += rod.toY;
                                }
                                final avg = sum /
                                    showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .length;

                                showingBarGroups[touchedGroupIndex] =
                                    showingBarGroups[touchedGroupIndex]
                                        .copyWith(
                                  barRods: showingBarGroups[touchedGroupIndex]
                                      .barRods
                                      .map((rod) {
                                    return rod.copyWith(
                                        toY: avg, color: widget.avgColor);
                                  }).toList(),
                                );
                              }
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingBarGroups,
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 1000) {
      text = '1000';
    } else if (value == 2000) {
      text = '2000';
    } else if (value == 3000) {
      text = '3000';
    } else if (value == 4000) {
      text = '4000';
    } else if (value == 5000) {
      text = '5000';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    return Container();
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 7.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
