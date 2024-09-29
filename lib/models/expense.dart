import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const Uuid _uuid = Uuid();

String? serializeIcon(IconPickerIcon icon) {
  return '${icon.name}|${icon.data.codePoint}|${icon.data.fontFamily}|${icon.data.fontPackage}|${icon.data.matchTextDirection}|${icon.pack}';
}

IconPickerIcon deserializeIcon(String? serialized) {
  final parts = serialized?.split('|');
  if (parts == null || parts.length != 6) {
    throw Exception('Invalid serialized icon: $serialized');
  }
  IconPack? pack;

  if (parts[5] == 'IconPack.fontAwesomeIcons"') {
    pack = IconPack.fontAwesomeIcons;
  } else if (parts[5] == 'IconPack.allMaterial"') {
    pack = IconPack.allMaterial;
  } else if (parts[5] == 'IconPack.custom"') {
    pack = IconPack.custom;
  } else if (parts[5] == 'IconPack.material"') {
    pack = IconPack.material;
  } else if (parts[5] == 'IconPack.cupertino"') {
    pack = IconPack.cupertino;
  } else if (parts[5] == 'IconPack.sharpMaterial"') {
    pack = IconPack.sharpMaterial;
  } else if (parts[5] == 'IconPack.roundedMaterial"') {
    pack = IconPack.roundedMaterial;
  } else if (parts[5] == 'IconPack.outlinedMaterial"') {
    pack = IconPack.outlinedMaterial;
  } else if (parts[5] == 'IconPack.lineAwesomeIcons"') {
    pack = IconPack.lineAwesomeIcons;
  }

  IconPickerIcon icon = IconPickerIcon(
    name: parts[0],
    data: IconData(
      int.parse(parts[1]),
      fontFamily: parts[2],
      fontPackage: parts[3] == 'null' ? null : parts[3],
      matchTextDirection: parts[4] == 'true',
    ),
    pack: pack!,
  );
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
  final String attachment;
  final ExpenseType type;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.attachment = 'none',
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
