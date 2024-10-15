import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaxSpendingProvider extends ChangeNotifier {
  double maxSpending = 600.0;

  MaxSpendingProvider() {
    _loadMaxSpending();
  }

  double get getMaxSpendings => maxSpending;

  void _loadMaxSpending() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    maxSpending = prefs.getDouble('maxSpending') ?? 600.0;
    if (maxSpending < 0) {
      maxSpending = 0.0;
    }
    notifyListeners();
  }

  void setNewMaxSpendings(double newMaxSpendings) async {
    final prefs = await SharedPreferences.getInstance();
    if (newMaxSpendings < 0) {
      newMaxSpendings = 1.0;
    }
    await prefs.setDouble('maxSpending', newMaxSpendings);
    maxSpending = newMaxSpendings;
    notifyListeners();
  }
}

final maxSepndingProvider = ChangeNotifierProvider<MaxSpendingProvider>((ref) {
  return MaxSpendingProvider();
});
