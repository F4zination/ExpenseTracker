import 'package:flutter/material.dart';
import 'package:expensetracker/controller/database_controller.dart';

class Metrics extends StatefulWidget {
  const Metrics({super.key});

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  late final DatabaseController _databaseController;

  @override
  void initState() {
    super.initState();
    _databaseController = DatabaseController();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Metrics Page'),
    );
  }
}
