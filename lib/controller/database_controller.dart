import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expensetracker/models/expense.dart';

class DatabaseController {
  static final DatabaseController _instance = DatabaseController._internal();
  Database? _database;

  // Private constructor
  DatabaseController._internal();

  // Public factory
  factory DatabaseController() {
    return _instance;
  }

  // Getter to access the database. It ensures database initialization.
  Future<Database> get database async {
    _database ??= await initializeDatabase();

    return _database!;
  }

  // Initialize the database
  Future<Database> initializeDatabase() async {
    // Get the path to the database directory
    String path = './expenses.db';

    // Open the database, creating it if it doesn't exist
    return await openDatabase(path,
        version: 2,
        onCreate: _createDb,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from $oldVersion to $newVersion');
    if (oldVersion == 1 && newVersion == 2) {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS expenseType(id TEXT PRIMARY KEY, name TEXT, color TEXT, icon TEXT, expense BOOLEAN)',
      );
      debugPrint('Created table expenseType');
      await checkAndAddColumn(db, 'expenses', 'typeID', 'TEXT');
      await checkAndAddColumn(db, 'expenses', 'attachment', 'TEXT');
      await db.execute(
        'ALTER TABLE expenses DROP COLUMN type',
      );
    }
  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Downgrading database from $oldVersion to $newVersion');
    switch (oldVersion) {
      case 2:
        await db.execute(
          'ALTER TABLE expenses ADD COLUMN type TEXT',
        );
        await db.execute(
          'UPDATE expenses SET type = (SELECT name FROM expenseType WHERE id = typeID)',
        );
        await db.execute(
          'ALTER TABLE expenses DROP COLUMN typeID',
        );
        debugPrint('droped typeID');
        await db.execute(
          'DROP TABLE expenseType',
        );
    }
  }

  // Function to create the database structure
  void _createDb(Database db, int newVersion) async {
    debugPrint('Creating database version $newVersion');
    // Example table creation
    switch (newVersion) {
      case 1:
        await db.execute(
          'CREATE TABLE IF NOT EXISTS expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, type TEXT)',
        );
      case 2:
        await db.execute(
          'CREATE TABLE IF NOT EXISTS expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, typeID TEXT, attachement TEXT)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS expenseType(id TEXT PRIMARY KEY, name TEXT, color TEXT, icon TEXT, expense TEXT)',
        );
    }
  }

  Future<void> checkAndAddColumn(
    Database db,
    tableName,
    columnName,
    columnType,
  ) async {
    // Retrieve the table info using PRAGMA
    List<Map<String, dynamic>> tableInfo =
        await db.rawQuery('PRAGMA table_info($tableName)', null);

    // Check if the column exists
    bool columnExists = tableInfo.any((column) => column['name'] == columnName);

    if (!columnExists) {
      // Column does not exist, add it
      await db
          .execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
      print('Column $columnName added to table $tableName.');
    } else {
      print('Column $columnName already exists in table $tableName.');
    }
  }

  void addExpense(Expense expense) async {
    final db = await database;
    db.insert(
      'expenses',
      {
        'id': expense.id,
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'typeID': expense.type.id,
        'attachement': expense.attachment,
      },
    );
    debugPrint('Added expense: ${expense.title} with amount ${expense.amount}');
  }

  void deleteExpense(String id) async {
    final db = await database;
    db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExpenseType(ExpenseType expenseType) async {
    final db = await database;
    return db
        .delete('expenseType', where: 'name = ?', whereArgs: [expenseType.id]);
  }

  void deleteAllExpenses() async {
    final db = await database;
    db.delete('expenses');
  }

  Future<List<ExpenseType>> loadExpenseTypes() async {
    final db = await database;
    final results = await db.query('expenseType');

    return results.map((e) {
      var icon = deserializeIcon(e['icon'] as String);
      return ExpenseType.withID(
        id: e['id'] as String,
        name: e['name'] as String,
        color: Color(int.parse(e['color'] as String, radix: 16)),
        icon: icon,
        isExpense: e['expense'] == 'true' ? true : false,
      );
    }).toList();
  }

  Future<ExpenseType> loadExpenseType(String id) async {
    final db = await database;
    final results =
        await db.query('expenseType', where: 'id = ?', whereArgs: [id]);

    List<ExpenseType> listOfresults = results.map((e) {
          var icon = deserializeIcon(e['icon'] as String);
          return ExpenseType.withID(
            id: e['id'] as String,
            name: e['name'] as String,
            color: Color(int.parse(e['color'] as String, radix: 16)),
            icon: icon,
            isExpense: e['expense'] == 'true' ? true : false,
          );
        }).toList() ??
        [];
    return listOfresults[0];
  }

  Future<void> deleteAllExpnsesOfType(ExpenseType type) async {
    final db = await database;
    db.delete('expenses', where: 'typeID = ?', whereArgs: [type.id]);
  }

  Future<List<DateTime>> loadAllExistingMonths() async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT DISTINCT strftime(\'%m-%Y\', date) as month FROM expenses',
    );
    return results.map((e) {
      String dateString = e['month'] as String;
      List<String> parts = dateString.split('-');
      int month = int.parse(parts[0]);
      int year = int.parse(parts[1]);

      // Create a DateTime object with the parsed year and month, using day as 1
      return DateTime(year, month, 1);
    }).toList();
  }

  Future<int> addExpenseType(ExpenseType type) async {
    final db = await database;
    return db.insert(
      'expenseType',
      {
        'id': type.id,
        'name': type.name,
        'color': type.color.value.toRadixString(16),
        'icon': jsonEncode(serializeIcon(type.icon)),
        'expense': type.isExpense.toString(),
      },
    );
  }

  Future<List<Expense>> loadCurrentMonthExpenses() async {
    final db = await database;
    String month = DateTime.now().month.toString().padLeft(2, '0');

    const query = '''
    SELECT * FROM expenses 
    WHERE strftime('%m', date) = ?
  ''';
    final results = await db.rawQuery(query, [month]);
    List<Expense> list_results = [];
    // using print to show the results, wich are in a bad format for debugPrint
    for (var e in results) {
      list_results.add(Expense.withID(
        id: e['id'] as String,
        title: e['title'] as String,
        amount: e['amount'] as double,
        date: DateTime.parse(e['date'] as String),
        type: await loadExpenseType(e['typeID'] as String),
        attachment: e['attachment'].toString() == 'null'
            ? ''
            : e['attachment'] as String,
      ));
    }

    return Future.value(list_results);
  }

  Future<List<Expense>> loadAllExpenses() async {
    final db = await database;
    final results = await db.query('expenses');
    return results.map((e) {
      return Expense.withID(
        id: e['id'] as String,
        title: e['title'] as String,
        amount: e['amount'] as double,
        date: DateTime.parse(e['date'] as String),
        type: ExpenseType.withID(
          id: e['id'] as String,
          name: e['name'] as String,
          color: Color(int.parse(e['color'] as String)),
          icon: deserializeIcon(e['icon'] as String),
        ),
        attachment: e['attachment'].toString() == 'null'
            ? ''
            : e['attachment'] as String,
      );
    }).toList();
  }

  Future<List<Expense>> loadExpenseByType(ExpenseType type) async {
    final db = await database;
    final results = await db.query('expenses',
        where: 'typeID = ?', whereArgs: [type.id.toString()]);
    return results.map((e) {
      debugPrint(e.toString());
      return Expense.withID(
        id: e['id'] as String,
        title: e['title'] as String,
        amount: e['amount'] as double,
        date: DateTime.parse(e['date'] as String),
        type: type,
        attachment: e['attachment'].toString() == 'null'
            ? ''
            : e['attachment'] as String,
      );
    }).toList();
  }

  Future<List<Expense>> loadExpensesByTypeAndMonth(
      ExpenseType type, String month) async {
    final db = await database;

    final results = await db.query(
      'expenses',
      where: 'typeID = ? AND strftime(\'%m\', date) = ?',
      whereArgs: [type.id.toString(), month],
    );
    return results.map((e) {
      return Expense.withID(
        id: e['id'] as String,
        title: e['title'] as String,
        amount: e['amount'] as double,
        date: DateTime.parse(e['date'] as String),
        type: type,
        attachment: e['attachment'].toString() == 'null'
            ? ''
            : e['attachment'] as String,
      );
    }).toList();
  }
}
