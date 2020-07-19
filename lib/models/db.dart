import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'base.dart';
import 'materia.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE materiadb (id INTEGER PRIMARY KEY NOT NULL, nombre STRING,profesor STRING, cuatrimestre STRING, horario STRING, complete BOOLEAN)');

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async {
    final response =
        await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

    return response;
  }

  static Future<List<Materia>> getMaterias() async {
    List<Materia> _tasks = [];

    List<Map<String, dynamic>> _results = await DB.query(Materia.table);
    _tasks = _results.map((item) => Materia.fromMap(item)).toList();
    return _tasks;
  }
}

/*
      var res= await _db.insert(table, model.toJson());
    return res;*/
