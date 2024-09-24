import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const Uuid _uuid = Uuid();

String? serializeIcon(IconPickerIcon icon) {
  return '${icon.name}|${icon.data.codePoint}|${icon.data.fontFamily}|${icon.data.fontPackage}|${icon.data.matchTextDirection}|${icon.pack.toString()}';
}

IconPickerIcon deserializeIcon(String? serialized) {
  final parts = serialized?.split('|');
  if (parts == null || parts.length != 6) {
    throw Exception('Invalid serialized icon: $serialized');
  }

  var icon = IconPickerIcon(
    name: parts[0],
    data: IconData(
      int.parse(parts[1]),
      fontFamily: parts[2],
      fontPackage: parts[3],
      matchTextDirection: parts[4] == 'true',
    ),
    pack:
        IconPack.values.firstWhere((element) => element.toString() == parts[5]),
  );
  debugPrint('Deserialized icon: ${icon.data}');
  return icon;
}

class ExpenseType {
  final String id;
  final String name;
  final Color color;
  final IconPickerIcon icon;
  final bool isExpense;

  ExpenseType({
    required this.name,
    required this.color,
    required this.icon,
    this.isExpense = true,
  }) : id = _uuid.v4();

  ExpenseType.withID({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isExpense = true,
  });
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? attachment;
  final ExpenseType type;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.attachment,
  }) : id = _uuid.v4();

  Expense.withID(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.attachment,
      required this.type});

  IconPickerIcon get icon {
    return type.icon;
  }

  String get formattedDate {
    return '${date.day}.${date.month}.${date.year}';
  }
}
