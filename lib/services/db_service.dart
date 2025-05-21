import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DBService {
  static final DBService _i = DBService._();
  factory DBService() => _i;
  DBService._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await openDatabase(
      join(await getDatabasesPath(), 'items.db'),
      version: 2, // ⬅️ bump version to trigger schema upgrade
      onCreate: _createTables,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS items');
        await _createTables(db, newVersion);
      },
    );
    return _db!;
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT,
        category TEXT,
        brand TEXT
      )
    ''');
  }

  Future<List<Item>> getItems() async {
    final d = await db;
    final maps = await d.query('items');
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  Future<void> addItem(Item it) async {
    final d = await db;
    await d.insert('items', it.toMap());
  }

  Future<void> updateItem(Item it) async {
    final d = await db;
    await d.update('items', it.toMap(), where: 'id=?', whereArgs: [it.id]);
  }

  Future<void> deleteItem(int id) async {
    final d = await db;
    await d.delete('items', where: 'id=?', whereArgs: [id]);
  }
}