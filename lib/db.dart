import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'models/materia.dart';

class DB {
  static Database _db;

  static int get _version => 1;

  // ignore: missing_return
  static Future<Database> init() async {
    if (_db != null) {
      return _db;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  /*
  "Id": id,
      "Nombre": nombre,
      "Profesor": profesor,
      "Cuatrimestre": cuatrimestre,
      "Horario": horario*/

  static void onCreate(Database db, int version) async => await db.execute(
      'CREATE TABLE db_school (id INTEGER PRIMARY KEY NOT NULL, Nombre STRING, Profesor STRING, Cuatrimestre STRING, Horario STRING)');

  static Future<List<Materia>> query(String table) async {
    var res = await _db.query(table);
    //return (res).map((itemWord) => profileFromJson(itemWord)).toList();
    return List<Materia>.from(res.map((item) => Materia.fromJson(item)));
  }

  /*
      var res= await _db.insert(table, model.toJson());
    return res;*/

//retoorna int/ recibe string y nombre de talbla
  static Future<int> insert(String table, Materia model) async {
    await _db.insert(table, model.toJson());
  }

  static Future<int> update(String table, Materia model) async => await _db
      .update(table, model.toJson(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Materia model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
