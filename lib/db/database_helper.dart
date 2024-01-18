import 'package:expense_tracker/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _getDB() async {
    final path = join(await getDatabasesPath(), 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE expenses (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              amount REAL NOT NULL,
              date TEXT NOT NULL,
              category TEXT NOT NULL
            )
          ''');
      },
    );
  }

  static Future<int> insertExpense(Expense expense) async {
    final db = await _getDB();
    return await db.insert('expenses', expense.toMap());
  }

  static Future<int> deleteExpense(Expense expense) async {
    final db = await _getDB();
    return await db.delete(
      'expenses',
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }

  static Future<List<Expense>> retrieveExpenses() async {
    final db = await _getDB();
    final List<Map<String, Object?>> queryResult = await db.query('expenses');
    return queryResult.map((e) => Expense.fromMap(e)).toList();
  }
}
