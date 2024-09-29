import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthProvider extends ChangeNotifier {
  String month = 'September';
  List<DateTime> existingMonths = [];
  DatabaseController databaseController = DatabaseController();

  MonthProvider() {
    _loadMonth();
  }

  String get getUsername => month;

  void _loadMonth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    month = prefs.getString('month') ?? 'September';
    notifyListeners();
    existingMonths = await databaseController.loadAllExistingMonths();
  }

  void setMonth(String month) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('month', month);
    month = month;
    notifyListeners();
  }
}

final monthProvider = ChangeNotifierProvider<MonthProvider>((ref) {
  return MonthProvider();
});
