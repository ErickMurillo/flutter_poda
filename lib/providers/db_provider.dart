import 'dart:io';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/variedad.dart';
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
      await db.execute('CREATE TABLE if not exists Variedad('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nombre TEXT'
          ')');
      await db.execute('CREATE TABLE if not exists Parcela('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nombre TEXT,'
          'area REAL,'
          'plantas INTEGER,'
          'idVariedad INTEGER,'
          'idFinca INTEGER,'
          'FOREIGN KEY(idVariedad) REFERENCES Variedad(id),'
          'FOREIGN KEY(idFinca) REFERENCES Finca(id)'
          ')');
    });
  }

// fincas CRUD
  Future<int> insertFinca(Finca finca) async {
    Database db = await database;
    return await db.insert('Finca', finca.toMap());
  }

  Future<int> updateFinca(Finca finca) async {
    Database db = await database;
    return await db
        .update('Finca', finca.toMap(), where: 'id=?', whereArgs: [finca.id]);
  }

  Future<int> deleteFinca(int id) async {
    Database db = await database;
    return await db.delete('Finca', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Finca>> getFinca(int id) async {
    Database db = await database;
    List<Map> fincas = await db.query('Finca',
        columns: ['area'], where: 'id=?', whereArgs: [id]);
    return fincas.length == 0
        ? []
        : fincas.map((e) => Finca.fromMap(e)).toList();
  }

  Future<List<Finca>> fetchFincas() async {
    Database db = await database;
    List<Map> fincas = await db.query('Finca');
    return fincas.length == 0
        ? []
        : fincas.map((e) => Finca.fromMap(e)).toList();
  }

  //variedades CRUD
  Future<int> insertVariedad(Variedad variedad) async {
    Database db = await database;
    return await db.insert('Variedad', variedad.toMap());
  }

  Future<int> updateVariedad(Variedad variedad) async {
    Database db = await database;
    return await db.update('Variedad', variedad.toMap(),
        where: 'id=?', whereArgs: [variedad.id]);
  }

  Future<int> deleteVariedad(int id) async {
    Database db = await database;
    return await db.delete('Variedad', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Variedad>> fetchVariedad() async {
    Database db = await database;
    List<Map> variedades = await db.query('Variedad');
    return variedades.length == 0
        ? []
        : variedades.map((e) => Variedad.fromMap(e)).toList();
  }

  //parcelas CRUD
  Future<int> insertParcela(Parcela parcela) async {
    Database db = await database;
    return await db.insert('Parcela', parcela.toMap());
  }

  Future<int> updateParcela(Parcela parcela) async {
    Database db = await database;
    return await db.update('Parcela', parcela.toMap(),
        where: 'id=?', whereArgs: [parcela.id]);
  }

  Future<int> deleteParcela(int id) async {
    Database db = await database;
    return await db.delete('Parcela', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Parcela>> fetchParcela() async {
    Database db = await database;
    List<Map> parcelas = await db.query('Parcela');
    return parcelas.length == 0
        ? []
        : parcelas.map((e) => Parcela.fromMap(e)).toList();
  }

  Future<List> fetchParcelaFromFinca(int id) async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT SUM(area) as total FROM Parcela where idFinca=?", [id]);
    return result;
  }
}
