import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const Uuid _uuid = Uuid();

enum ExpenseType {
  income,
  food,
  transport,
  fun,
  shopping,
  rent,
  others,
}

const categoryColors = {
  ExpenseType.food: Colors.green,
  ExpenseType.transport: Colors.blue,
  ExpenseType.fun: Colors.red,
  ExpenseType.shopping: Colors.orange,
  ExpenseType.rent: Colors.purple,
  ExpenseType.others: Colors.grey,
};

const categoryIcons = {
  ExpenseType.income: Icons.attach_money,
  ExpenseType.food: Icons.fastfood,
  ExpenseType.fun: Icons.sports_esports,
  ExpenseType.transport: Icons.directions_bus,
  ExpenseType.shopping: Icons.shopping_cart,
  ExpenseType.rent: Icons.home,
  ExpenseType.others: Icons.category,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseType type;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  }) : id = _uuid.v4();

  Expense.withID(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.type});

  IconData get icon {
    return categoryIcons[type] ?? Icons.category;
  }

  String get formattedDate {
    return '${date.day}.${date.month}.${date.year}';
  }
}
