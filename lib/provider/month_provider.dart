import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthProvider extends ChangeNotifier {
  DateTime month = DateTime.now();
  List<DateTime> existingMonths = [];
  DatabaseController databaseController = DatabaseController();

  MonthProvider() {
    _loadMonth();
  }

  String getMonth() {
    return DateFormat('MMMM-yyyy').format(month);
  }

  void _loadMonth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    month = prefs.getString('month') != null
        ? DateTime.parse(prefs.getString('month')!)
        : DateTime.now();
    existingMonths = await databaseController.loadAllExistingMonths();
    notifyListeners();
  }

  void setMonth(DateTime month) async {
    debugPrint('setting month to $month');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('month', month.toIso8601String());
    month = month;
    notifyListeners();
  }
}

final monthProvider = ChangeNotifierProvider<MonthProvider>((ref) {
  return MonthProvider();
});
