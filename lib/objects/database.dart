import 'package:sqflite/sqflite.dart';
import 'collo.dart';


String path = 'database.db';

class DatabaseManager
{
  late Database db;


  Future<void> open() async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table Colli ( 
  uid integer primary key autoincrement, 
  name text not null)
''');
        });
  }

  Future<List<Collo>> getColli() async
  {
    final List<Map<String, dynamic>> maps = await db.query('Colli');
    return List.generate(maps.length, (i) {
      return Collo(
        uid: maps[i]['uid'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  Future<Collo> insert(Collo todo) async {
    todo.uid = await db.insert('Colli', todo.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return todo;
  }

  Future<Collo> getTodo(int id) async {
    List<Map<String,dynamic>> maps = await db.query('Colli',
        columns: ['uid', 'name'],
        where: 'uid = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Collo.fromMap(maps.first);
    }
    return Collo(uid : -1, name: 'invalid');
  }

  Future<int> delete(int id) async {
    return await db.delete('Colli', where: 'uid = ?', whereArgs: [id]);
  }

  Future<int> update(Collo todo) async {
    return await db.update('Colli', todo.toMap(),
        where: 'uid = ?', whereArgs: [todo.uid]);
  }

  Future close() async => db.close();
}

