import 'package:expensetracker/widgets/graph_cards/bar_chart_category.dart';
import 'package:expensetracker/widgets/graph_cards/graph_card.dart';
import 'package:expensetracker/widgets/graph_cards/line_chart_total.dart';
import 'package:expensetracker/widgets/month_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MetricGraphScreen extends ConsumerStatefulWidget {
  const MetricGraphScreen({super.key});

  @override
  ConsumerState<MetricGraphScreen> createState() => _MetricGraphScreenState();
}

class _MetricGraphScreenState extends ConsumerState<MetricGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text('Graphs',
                  style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 10),
              MonthDropdownButton(ref: ref),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GraphCard(
                    title: 'Category Expenses',
                    graph: BarChartCategory(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
