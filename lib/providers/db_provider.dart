import 'dart:io';
import 'package:flutter_poda/models/finca.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the tables
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'poda.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE if not exists Finca('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nombre TEXT,'
          'area REAL,'
          'unidad TEXT,'
          'productor TEXT'
          ')');
    });
  }

//   // Insert on database
//   createFinca(Finca newFinca) async {
//     // await deleteAllFinca();
//     final db = await database;
//     final res = await db.insert('Finca', newFinca.toJson());

//     return res;
//   }

//   // Delete all
//   Future<int> deleteAllFinca() async {
//     final db = await database;
//     final res = await db.rawDelete('DELETE FROM Finca');

//     return res;
//   }

//   //select all
//   Future<List<Finca>> getAllFincas() async {
//     final db = await database;
//     final res = await db.rawQuery("SELECT * FROM Finca");
//     List<Finca> list =
//         res.isNotEmpty ? res.map((c) => Finca.fromJson(c)).toList() : [];
//     return list;
//   }

  Future<int> insertFinca(Finca finca) async {
    Database db = await database;
    return await db.insert('Finca', finca.toMap());
  }

  Future<int> updateFinca(Finca finca) async {
    Database db = await database;
    return await db
        .update('Finca', finca.toMap(), where: 'id=?', whereArgs: [finca.id]);
  }

  Future<List<Finca>> fetchFincas() async {
    Database db = await database;
    List<Map> fincas = await db.query('Finca');
    return fincas.length == 0
        ? []
        : fincas.map((e) => Finca.fromMap(e)).toList();
  }
}
