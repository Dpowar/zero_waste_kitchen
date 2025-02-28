import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'food_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            expiryDate TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertFood(String name, String expiryDate) async {
    final db = await database;
    await db.insert('foods', {'name': name, 'expiryDate': expiryDate});
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    final db = await database;
    return db.query('foods');
  }
}
