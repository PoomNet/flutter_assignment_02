import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'todoItem.dart';

final String todoTable = "TodoItems";

class DataAccess {
  static final DataAccess _instance = DataAccess._internal();
  Database _db;

  factory DataAccess() {
    return _instance;
  }

  DataAccess._internal();

  Future open() async {

    var databasesPath = await getDatabasesPath();
    String path = databasesPath + "\todo.db";

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $todoTable ( 
            id integer primary key autoincrement, 
            title text not null,
            done integer not null)
            ''');
    });
  }

  Future<List<TodoItem>> getTodoItems() async {
    var data = await _db.query(todoTable);
    return data.map((d) => TodoItem.fromMap(d)).toList();
  }

  Future insertTodo(TodoItem item) {
    return _db.insert(todoTable, item.toMap());
  }

  Future updateTodo(TodoItem item) {
    return _db.update(todoTable, item.toMap(),
      where: "id = ?", whereArgs: [item.id]);
  }
  
  Future deleteTodo() {
    return _db.delete(todoTable, where: "done = ?", whereArgs: [true]);
  }
}