import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart'
    show IconPickerIcon, IconPack;
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
      await checkAndAddColumn(db, 'expenses', 'typeID', 'INTEGER');
      await checkAndAddColumn(db, 'expenses', 'attachment', 'TEXT');
      await updateTypeIDs(db);
      await insertExpenseTypes(db);
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
          'CREATE TABLE IF NOT EXISTS expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, typeID INTEGER, attachement TEXT)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS expenseType(id TEXT PRIMARY KEY, name TEXT, color TEXT, icon TEXT, expense TEXT)',
        );
        await insertExpenseTypes(db);
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
        'type': expense.type.id,
        'attachment': expense.attachment,
      },
    );
    debugPrint('Added expense: ${expense.title} with amount ${expense.amount}');
  }

  void deleteExpense(String id) async {
    final db = await database;
    db.delete('expenses', where: 'id = ?', whereArgs: [id]);
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
    // using print to show the results, wich are in a bad format for debugPrint
    print(results);
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
        attachment: e['attachment'] as String,
      );
    }).toList();
  }

  Future<List<Expense>> loadAllExpenses() async {
    final db = await database;
    final results = await db.query('expenses');
    print(results);
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
        attachment: e['attachment'] as String,
      );
    }).toList();
  }

  Future<List<Expense>> loadExpenseByType(ExpenseType type) async {
    final db = await database;
    final results = await db
        .query('expenses', where: 'type = ?', whereArgs: [type.toString()]);
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
        attachment: e['attachment'] as String,
      );
    }).toList();
  }

  Future<List<Expense>> loadExpensesByTypeAndMonth(
      ExpenseType type, String month) async {
    final db = await database;

    final results = await db.query(
      'expenses',
      where: 'type = ? AND strftime(\'%m\', date) = ?',
      whereArgs: [type.toString(), month],
    );
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
          icon: deserializeIcon(
            (e['icon'] as String),
          ),
        ),
        attachment: e['attachment'] as String,
      );
    }).toList();
  }

  Future<void> updateTypeIDs(Database db) async {
    // Mapping of Type to typeID
    Map<String, int> typeMapping = {
      'food': 1,
      'transport': 2,
      'fun': 3,
      'shopping': 4,
      'rent': 5,
      'others': 6,
    };

    // Begin a transaction to ensure atomicity
    await db.transaction((txn) async {
      // Loop through the mapping and update typeID based on Type
      for (var entry in typeMapping.entries) {
        String type = entry.key;
        int typeID = entry.value;

        await txn.update(
          'expenses',
          {'typeID': typeID},
          where: 'type = ?',
          whereArgs: [type],
        );
      }
    });
  }

  Future<void> insertExpenseTypes(Database db) async {
    // List of categories with their corresponding details
    List<Map<String, dynamic>> expenseTypes = [
      {
        'id': 1,
        'name': 'food',
        'color': 'FF2AA614',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'fastfood',
            data: Icons.fastfood,
            pack: IconPack.allMaterial)),
        'expense': true.toString(),
      },
      {
        'id': 2,
        'name': 'transport',
        'color': 'FF828282',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'directions_bus',
            data: Icons.directions_bus,
            pack: IconPack.allMaterial)),
        'expense': true.toString(),
      },
      {
        'id': 3,
        'name': 'fun',
        'color': 'FF00DDFF',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'local_movies',
            data: Icons.local_movies,
            pack: IconPack.allMaterial)),
        'expense': true.toString(),
      },
      {
        'id': 4,
        'name': 'shopping',
        'color': 'FFE81043',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'shopping_cart',
            data: Icons.shopping_cart,
            pack: IconPack.allMaterial)),
        'expense': true.toString(),
      },
      {
        'id': 5,
        'name': 'rent',
        'color': 'FF424242',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'home', data: Icons.home, pack: IconPack.allMaterial)),
        'expense': true.toString(),
      },
      {
        'id': 6,
        'name': 'add category',
        'color': 'FFFFA733',
        'icon':
            'playlist_add_rounded|983208|MaterialIcons|null|true|IconPack.allMaterial',
        'expense': true.toString(),
      },
      {
        'id': 7,
        'name': 'salary',
        'color': 'FF2AA614',
        'icon': serializeIcon(const IconPickerIcon(
            name: 'wallet', data: Icons.wallet, pack: IconPack.allMaterial)),
        'expense': false.toString(),
      }
    ];

    // Begin a transaction to ensure atomicity
    await db.transaction((txn) async {
      for (var expenseType in expenseTypes) {
        await txn.insert(
          'expenseType',
          expenseType,
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Replace if already exists
        );
      }
    });
  }
}
