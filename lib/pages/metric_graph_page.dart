import 'package:flutter/material.dart';

class MetricGraphScreen extends StatelessWidget {
  const MetricGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metric Graph'),
      ),
      body: const Center(
        child: Text('This is the metric graph page'),
      ),
    );
  }
}
