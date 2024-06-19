import 'package:flutter/material.dart';
import 'package:hcsp/bar_chart.dart';
import 'package:hcsp/line_chart.dart';

enum MonitorEnum {
  cO2,
  voltage,
  exhaustFan,
  current,
  compareCo2Exhaust;

  String getUnit() {
    switch (this) {
      case cO2:
        return 'PPM';
      case voltage:
        return 'V';
      case current:
        return 'A';
      case exhaustFan:
        return 'RPM';
      case compareCo2Exhaust:
        return '';
      default:
        return '';
    }
  }

  Widget getChartWidget() {
    switch (this) {
      case cO2:
        return LineChartSample5(
          monitorEnum: this,
        );
      case voltage:
        return LineChartSample5(
          monitorEnum: this,
        );
      case current:
        return LineChartSample5(
          monitorEnum: this,
        );
      case exhaustFan:
        return LineChartSample5(
          monitorEnum: this,
        );
      case compareCo2Exhaust:
        return BarChartSample2();
      default:
        return Container();
    }
  }

  String iconString() {
    switch (this) {
      case cO2:
        return 'assets/images/co2_icon.png';
      case voltage:
        return 'assets/images/voltage_icon.png';
      case current:
        return 'assets/images/ampe_icon.png';
      case exhaustFan:
        return 'assets/images/rpm_icon.png';
      case compareCo2Exhaust:
        return 'assets/images/compare_icon.png';
      default:
        return 'assets/images/ppm_icon.png';
    }
  }

  String titleString() {
    switch (this) {
      case cO2:
        return 'CO2';
      case voltage:
        return 'Voltage';
      case current:
        return 'Current';
      case exhaustFan:
        return 'Exhaust Fan';
      case compareCo2Exhaust:
        return 'Compare CO2/Exhaust Fan';
      default:
        return '';
    }
  }

  String fetchString() {
    switch (this) {
      case cO2:
        return 'CO2';
      case voltage:
        return 'Output-Voltage';
      case current:
        return 'output-current';
      case exhaustFan:
        return 'RPM-ExhaustFan';
      case compareCo2Exhaust:
        return '';
      default:
        return '';
    }
  }

  int get divideNumber {
    switch (this) {
      case cO2:
        return 600;
      case voltage:
        return 100;
      case current:
        return 2;
      case exhaustFan:
        return 260;
      case compareCo2Exhaust:
        return 0;
      default:
        return 1;
    }
  }
}
