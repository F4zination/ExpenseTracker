import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
  }) : id = _uuid.v4();
}
