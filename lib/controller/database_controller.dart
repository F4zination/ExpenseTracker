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
    String path = 'expenses.db';

    // Open the database, creating it if it doesn't exist
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // Function to create the database structure
  void _createDb(Database db, int newVersion) async {
    // Example table creation
    await db.execute(
        'CREATE TABLE expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, type TEXT)');
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
        'type': expense.type.toString(),
      },
    );
  }

  void deleteExpense(String id) async {
    final db = await database;
    db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> loadExpenses() async {
    final db = await database;
    return db.query('expenses').then((value) {
      return value.map((e) {
        return Expense.withID(
          id: e['id'] as String,
          title: e['title'] as String,
          amount: e['amount'] as double,
          date: DateTime.parse(e['date'] as String),
          type: ExpenseType.values
              .firstWhere((element) => element.toString() == e['type']),
        );
      }).toList();
    });
  }
}
