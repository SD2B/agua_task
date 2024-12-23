import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalStorage {
  static Database? _database;

  // Initialize the database
  static Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // For desktop platforms
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'local_storage.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tables can be created here if needed
      },
    );
  }

  // Get the database instance
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  // Helper method to check if a table exists
  static Future<bool> _checkTableExists(Database db, String tableName) async {
    final result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name = ?", [tableName]);
    return result.isNotEmpty;
  }

  // Create table dynamically based on the JSON data
  static Future<void> _createTableIfNotExists(Database db, String tableName, Map<String, dynamic> data) async {
    final exists = await _checkTableExists(db, tableName);
    if (!exists) {
      // Build CREATE TABLE SQL dynamically based on the keys of the JSON data
      final columns = data.keys
          .where((key) => key != 'id') // Exclude the 'id' key
          .map((key) {
        // Determine the type of the column (TEXT for simplicity)
        // ignore: prefer_const_declarations
        final columnType = 'TEXT'; // You can customize this based on value types
        return '$key $columnType';
      }).join(', ');

      final createTableQuery = '''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          $columns
        )
      ''';

      // Execute the CREATE TABLE statement
      await db.execute(createTableQuery);
    }
  }

  /// Save (Insert) data into a table
  static Future<int> save(String tableName, Map<String, dynamic> data) async {
    final db = await _getDatabase();

    // Create the table if it doesn't exist
    await _createTableIfNotExists(db, tableName, data);

    // Now insert the data (excluding the 'id' if exists)
    final dataWithoutId = Map<String, dynamic>.from(data)..remove('id');
    return await db.insert(tableName, dataWithoutId);
  }

  /// Get (Query) data from a table
  static Future<List<Map<String, dynamic>>> get(String tableName, {Map<String, dynamic>? where, String? search, Map<String, dynamic>? notWhere, int? limit}) async {
    final db = await _getDatabase();

    // Building the WHERE clause
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    // Add WHERE conditions
    if (where != null) {
      where.forEach((key, value) {
        whereClauses.add('$key = ?');
        whereArgs.add(value);
      });
    }

    // Add NOT WHERE conditions
    if (notWhere != null) {
      notWhere.forEach((key, value) {
        whereClauses.add('$key != ?');
        whereArgs.add(value);
      });
    }

    // Add SEARCH condition
    if (search != null) {
      whereClauses.add('name LIKE ?'); // Adjust column name as needed
      whereArgs.add('%$search%');
    }

    // Combine all conditions
    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    // Execute the query
    return await db.query(
      tableName,
      where: whereString,
      whereArgs: whereArgs,
      limit: limit,
    );
  }

  /// Update data in a table
  static Future<int> update(String tableName, Map<String, dynamic> data, {Map<String, dynamic>? where}) async {
    final db = await _getDatabase();

    // Building the WHERE clause
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (where != null) {
      where.forEach((key, value) {
        whereClauses.add('$key = ?');
        whereArgs.add(value);
      });
    }

    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    // Execute the update
    return await db.update(
      tableName,
      data,
      where: whereString,
      whereArgs: whereArgs,
    );
  }

  /// Delete data from a table
  static Future<int> delete(String tableName, {Map<String, dynamic>? where}) async {
    final db = await _getDatabase();

    // Building the WHERE clause
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (where != null) {
      where.forEach((key, value) {
        whereClauses.add('$key = ?');
        whereArgs.add(value);
      });
    }

    final whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    // Execute the delete
    return await db.delete(
      tableName,
      where: whereString,
      whereArgs: whereArgs,
    );
  }
}

class DBTable {
  static String task = "task";
}
