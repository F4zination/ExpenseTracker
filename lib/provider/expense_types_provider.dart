import 'package:expensetracker/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseTypesProvider with ChangeNotifier {
  final DatabaseController _databaseController = DatabaseController();

  ExpenseTypesProvider() {
    // Fetch expense types when the provider is initialized
    fetchExpenseTypes();
  }

  List<ExpenseType> _expenseTypes = [];

  List<ExpenseType> get expenseTypes => _expenseTypes;

  Future<int> addExpenseType(ExpenseType expenseType) async {
    try {
      // Add the expense type to the database using the database controller
      final id = await _databaseController.addExpenseType(expenseType);
      // Update the expense type list with the new expense type
      _expenseTypes.add(expenseType);
      notifyListeners();
      return id;
    } catch (error) {
      // Handle any errors that occur during adding
      debugPrint('Error adding expense type: $error');
      return -1;
    }
  }

  Future<void> deleteExpenseType(ExpenseType expenseType) async {
    try {
      // Delete the expense type from the database using the database controller
      await _databaseController.deleteAllExpnsesOfType(expenseType);

      await _databaseController.deleteExpenseType(expenseType);

      // Update the expense type list by removing the deleted expense type
      _expenseTypes.removeWhere((element) => element.name == expenseType.name);
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during deletion
      debugPrint('Error deleting expense type: $error');
    }
  }

  Future<void> fetchExpenseTypes() async {
    try {
      // Fetch expense types from the database using the database controller
      _expenseTypes = await _databaseController.loadExpenseTypes();
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during fetching
      debugPrint('Error fetching expense types: $error');
    }
  }
}

final expenseTypesProvider =
    ChangeNotifierProvider<ExpenseTypesProvider>((ref) {
  return ExpenseTypesProvider();
});
