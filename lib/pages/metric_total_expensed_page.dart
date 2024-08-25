import 'package:flutter/material.dart';

class MetricTotalScreen extends StatelessWidget {
  const MetricTotalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metric Total'),
      ),
      body: const Center(
        child: Text('This is the metric total page'),
      ),
    );
  }
}
