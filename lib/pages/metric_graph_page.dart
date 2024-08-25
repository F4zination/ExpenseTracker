import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MetricGraphScreen extends StatefulWidget {
  const MetricGraphScreen({super.key});

  @override
  State<MetricGraphScreen> createState() => _MetricGraphScreenState();
}

class _MetricGraphScreenState extends State<MetricGraphScreen> {
  List<double> totalExpensesByType = [];
  bool loading = true;
  List<BarChartGroupData> barGroupData = [];

  void loadExpenses(DatabaseController databaseController) async {
    for (ExpenseType type in ExpenseType.values) {
      await databaseController
          .loadExpensesByTypeAndMonth(
              type, DateTime.now().month.toString().padLeft(2, '0'))
          .then((value) {
        double total = value.fold(
            0, (previousValue, element) => previousValue + element.amount);
        totalExpensesByType.add(total);
      });
    }

    setState(() {
      barGroupData = totalExpensesByType
          .asMap()
          .entries
          .map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                      toY: e.value,
                      color: categoryColors[ExpenseType.values[e.key]],
                      width: 20,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)))
                ],
              ))
          .toList();

      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseController databaseController = DatabaseController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpenses(databaseController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metric Category'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loading ? 'Loading...' : 'Total Expenses by Category',
                style: const TextStyle(fontSize: 20, color: Colors.black38)),
            const SizedBox(height: 50),
            loading
                ? const Column(
                    children: [
                      SpinKitDoubleBounce(
                        color: Color(0xFF5D9FAE),
                        size: 50.0,
                      ),
                      SizedBox(height: 20),
                      Text('Oh boy, this is taking a while...',
                          style: TextStyle(
                              color: Color(0xFF5D9FAE), fontSize: 20)),
                    ],
                  )
                : AspectRatio(
                    aspectRatio: 0.8,
                    child: BarChart(
                      BarChartData(
                        barGroups: barGroupData,
                        alignment: BarChartAlignment.spaceEvenly,
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 100,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                    space: 20,
                                    axisSide: meta.axisSide,
                                    child: Column(
                                      children: [
                                        Icon(categoryIcons[
                                            ExpenseType.values[value.toInt()]]),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Transform.rotate(
                                            angle: 3.14 / 2,
                                            child: Text(ExpenseType
                                                .values[value.toInt()].name)),
                                      ],
                                    ));
                              },
                            ),
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(getTooltipItem:
                              (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                '${rod.toY}€',
                                const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold));
                          }),
                        ),
                        gridData: const FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                        ),
                        maxY: (totalExpensesByType.reduce((value, element) =>
                                    value > element ? value : element) *
                                1.2)
                            .floor()
                            .toDouble(),
                      ),
                      swapAnimationCurve: Curves.easeInOut,
                      swapAnimationDuration: const Duration(milliseconds: 150),
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}
