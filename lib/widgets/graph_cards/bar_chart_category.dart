import 'package:expensetracker/controller/database_controller.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class BarChartCategory extends ConsumerStatefulWidget {
  const BarChartCategory({super.key});

  @override
  ConsumerState<BarChartCategory> createState() => _BarChartCategoryState();
}

class _BarChartCategoryState extends ConsumerState<BarChartCategory> {
  DatabaseController databaseController = DatabaseController();
  List<Tuple2<ExpenseType, double>> totalExpensesByType = [];
  List<BarChartGroupData> barGroupData = [];
  bool _tooManyBars = false;
  int amountThatFits = 4;

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

    setState(() {
      barGroupData = totalExpensesByType
          .asMap()
          .entries
          .map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                      toY: 0,
                      color: e.value.item1.color,
                      width: 20,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)))
                ],
              ))
          .toList();
      if (totalExpensesByType.length > amountThatFits) {
        _tooManyBars = true;
      }
    });

    debugPrint('before wait');
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('after wait');

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
    var screenWidth = MediaQuery.of(context).size.width;
    return AspectRatio(
      aspectRatio: 0.8,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _tooManyBars
              ? screenWidth + (totalExpensesByType.length - amountThatFits) * 20
              : screenWidth * 0.8,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarChart(
              BarChartData(
                barGroups: barGroupData,
                alignment: BarChartAlignment.spaceEvenly,
                borderData: FlBorderData(
                    border: const Border(
                  bottom: BorderSide(
                    color: Colors.white54,
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Colors.white54,
                    width: 1,
                  ),
                )),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    totalExpensesByType[value.toInt()]
                                        .item1
                                        .icon
                                        .data,
                                    color: totalExpensesByType[value.toInt()]
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
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          space: 15,
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
                            color: Colors.white, fontWeight: FontWeight.bold));
                  }),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Colors.white12,
                    strokeWidth: 1,
                  ),
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
              swapAnimationDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
      ),
    );
  }
}
