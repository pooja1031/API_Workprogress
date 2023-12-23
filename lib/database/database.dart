import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database _database;

  Future openDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'repositories_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE repositories(id INTEGER PRIMARY KEY, name TEXT, description TEXT, stars INTEGER, username TEXT, avatar TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveData(List<Map<String, dynamic>> repositories) async {
    await _database.delete('repositories');

    for (var repo in repositories) {
      await _database.insert(
        'repositories',
        {
          'name': repo['name'],
          'description': repo['description'],
          'stars': repo['stars'],
          'username': repo['owner']['username'],
          'avatar': repo['owner']['avatar'],
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final List<Map<String, dynamic>> repositories = await _database.query('repositories');
    return repositories;
  }

  Future<void> updateData(int id, Map<String, dynamic> updatedRepo) async {
    await _database.update(
      'repositories',
      updatedRepo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteData(int id) async {
    await _database.delete(
      'repositories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
}
