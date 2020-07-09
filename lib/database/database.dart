import 'package:learn_sqflite/model/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase{
  static Future<Database> database;

  initDb() async{
    database = openDatabase(
      join(await getDatabasesPath(), 'db_test.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE test(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1,
    );
  }

  insertData(Map<String, dynamic> map) async{
    Database db = await database;

    db.insert('test', map,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String,dynamic>>> displayData() async{
    Database db = await database;

    var result = await db.rawQuery('SELECT * FROM test');
    print('result : $result');
    return result;
  }

  deleteData(int id) async{
    Database db = await database;
    
    db.delete('test',where: "id = ?",whereArgs: [id]);
    print('data deleted (message from database.dart)');
  }

  updateData(Model model) async{
    Database db = await database;

    print('${model.id} ${model.name} ${model.age} (message from database.dart)');

    db.update('test', model.toMap(), where: "id = ?",whereArgs: [model.id]);
    print('data updated (message from database.dart)');
  }

  Future<int> deleteAllData() async{
    Database db = await database;

    return db.rawDelete('DELETE FROM test');
  }

}
