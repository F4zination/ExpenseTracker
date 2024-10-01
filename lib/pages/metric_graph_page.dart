import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tuple/tuple.dart';

class MetricGraphScreen extends ConsumerStatefulWidget {
  const MetricGraphScreen({super.key});

  @override
  ConsumerState<MetricGraphScreen> createState() => _MetricGraphScreenState();
}

class _MetricGraphScreenState extends ConsumerState<MetricGraphScreen> {
  List<Tuple2<ExpenseType, double>> totalExpensesByType = [];
  bool loading = true;
  DatabaseController databaseController = DatabaseController();
  List<BarChartGroupData> barGroupData = [];

  void loadExpenses(DatabaseController databaseController) async {
    for (ExpenseType type in ref.read(expenseTypesProvider).expenseTypes) {
      await databaseController
          .loadExpensesByTypeAndMonth(
              type, DateTime.now().month.toString().padLeft(2, '0'))
          .then((value) {
        debugPrint(value.toString());
        double total = value.fold(
            0.0, (previousValue, element) => previousValue + element.amount);
        totalExpensesByType.add(Tuple2(type, total));
      });
    }

    debugPrint(totalExpensesByType.toString());

    setState(() {
      barGroupData = totalExpensesByType
          .asMap()
          .entries
          .map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                      toY: e.value.item2,
                      color: e.value.item1.color,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpenses(databaseController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loading ? 'Loading...' : 'Total Expenses by Category',
              style: const TextStyle(fontSize: 20, color: Colors.white70)),
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
                        style: TextStyle(color: Colors.white, fontSize: 20)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          totalExpensesByType[value.toInt()]
                                              .item1
                                              .icon
                                              .data,
                                          color:
                                              totalExpensesByType[value.toInt()]
                                                  .item1
                                                  .color,
                                        ),
                                      ],
                                    ));
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  value.floor().toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ))),
                      backgroundColor: Colors.transparent,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                              '${totalExpensesByType[groupIndex].item1.name}\n${rod.toY}€',
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
                      maxY: (totalExpensesByType.isEmpty
                              ? 0.0
                              : totalExpensesByType
                                      .reduce((value, element) =>
                                          value.item2 > element.item2
                                              ? value
                                              : element)
                                      .item2 *
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
    );
  }
}
