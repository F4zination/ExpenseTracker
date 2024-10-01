import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseListProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  final DatabaseController _databaseController = DatabaseController();

  ExpenseListProvider() {
    _databaseController.loadCurrentMonthExpenses().then((value) {
      _expenses = value;
      notifyListeners();
    });
  }

  List<Expense> get expenses => _expenses;

  double get totalExpenses {
    return _expenses.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.type.isExpense ? element.amount : 0.0));
  }

  double getTotalAmountExpensesPerType(ExpenseType type) {
    final expensesOfType =
        _expenses.where((element) => element.type.name == type.name).toList();
    return expensesOfType.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.type.isExpense ? element.amount : 0.0));
  }

  List<Expense> getExpensesByType(ExpenseType type) {
    return _expenses
        .where((element) => element.type.name == type.name)
        .toList();
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    debugPrint('Adding expense: $expense');
    notifyListeners();
    _databaseController.addExpense(expense);
  }

  void categoryWasRemoved(ExpenseType category) {
    _expenses.removeWhere((element) => element.type.name == category.name);
    notifyListeners();
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
    _databaseController.deleteExpense(expense.id);
  }
}

final expenseListProvider = ChangeNotifierProvider<ExpenseListProvider>((ref) {
  return ExpenseListProvider();
});
