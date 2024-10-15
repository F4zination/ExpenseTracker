import 'package:expensetracker/controller/database_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineChartTotal extends ConsumerStatefulWidget {
  const LineChartTotal({super.key});

  @override
  ConsumerState<LineChartTotal> createState() => _LineChartTotalState();
}

class _LineChartTotalState extends ConsumerState<LineChartTotal> {
  DatabaseController databaseController = DatabaseController();

  void _loadData() async {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: false,
            ),
            borderData: FlBorderData(
              show: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 0),
                  FlSpot(1, 1),
                  FlSpot(2, 2),
                  FlSpot(3, 3),
                  FlSpot(4, 4),
                  FlSpot(5, 5),
                  FlSpot(6, 6),
                  FlSpot(7, 7),
                  FlSpot(8, 8),
                  FlSpot(9, 9),
                  FlSpot(10, 10),
                  FlSpot(11, 11),
                ],
                isCurved: true,
                color: Colors.white,
                barWidth: 5,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
