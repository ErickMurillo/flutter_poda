import 'dart:io';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/test_parcela.dart';
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
      await db.execute('CREATE TABLE if not exists TestParcela('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'idFinca INTEGER,'
          'idParcela INTEGER,'
          'fecha TEXT,'
          'FOREIGN KEY(idFinca) REFERENCES Finca(id),'
          'FOREIGN KEY(idParcela) REFERENCES Parcela(id)'
          ')');
      await db.execute('CREATE TABLE if not exists Estaciones('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'estacion INTEGER,'
          'planta INTEGER,'
          'idTest INTEGER,'
          'altura REAL,'
          'ancho REAL,'
          'largo REAL,'
          'buenaArquitectura TEXT,'
          'ramasContacto TEXT,'
          'ramasEntrecruzados TEXT,'
          'ramasSuelo TEXT,'
          'chupones TEXT,'
          'entradaLuz TEXT,'
          'produccion TEXT,'
          'FOREIGN KEY(idTest) REFERENCES TestParcela(id)'
          ')');
    });
  }

// fincas CRUD ---------------------------------------------------
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

  //variedades CRUD ---------------------------------------------------
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

  //parcelas CRUD ---------------------------------------------------
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

//   Future<List<Parcela>> fetchParcela() async {
//     Database db = await database;
//     List<Map> parcelas = await db.query('Parcela');
//     return parcelas.length == 0
//         ? []
//         : parcelas.map((e) => Parcela.fromMap(e)).toList();
//   }

  Future<List> fetchParcela() async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT Parcela.id, Parcela.nombre, Finca.nombre as finca, Parcela.area, Parcela.plantas, Parcela.idVariedad, Parcela.idFinca FROM Parcela INNER JOIN Finca on Finca.id = Parcela.idFinca");
    return result;
  }

  Future<List<Parcela>> getParcelaId(int id) async {
    Database db = await database;
    List<Map> parcela =
        await db.query('Parcela', where: 'id=?', whereArgs: [id]);
    return parcela.length == 0
        ? []
        : parcela.map((e) => Parcela.fromMap(e)).toList();
  }

  Future<List<Parcela>> getParcelaFromFincaId(int id) async {
    Database db = await database;
    List<Map> parcela =
        await db.query('Parcela', where: 'idFinca=?', whereArgs: [id]);
    return parcela.length == 0
        ? []
        : parcela.map((e) => Parcela.fromMap(e)).toList();
  }

  Future<List> fetchParcelaFromFinca(int id) async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT SUM(area) as total FROM Parcela where idFinca=?", [id]);
    return result;
  }

  // test parcela crud ---------------------------------------------------
  Future<int> insertTestParcela(TestParcela testparcela) async {
    Database db = await database;
    return await db.insert('TestParcela', testparcela.toMap());
  }

  Future<int> updateTestParcela(TestParcela testparcela) async {
    Database db = await database;
    return await db.update('TestParcela', testparcela.toMap(),
        where: 'id=?', whereArgs: [testparcela.id]);
  }

  Future<int> deleteTestParcela(int id) async {
    Database db = await database;
    return await db.delete('TestParcela', where: 'id=?', whereArgs: [id]);
  }

  Future<List> fetchTestParcela() async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT TestParcela.id, Parcela.nombre as parcela, Finca.nombre as finca, TestParcela.fecha FROM TestParcela INNER JOIN Finca on Finca.id = TestParcela.idFinca INNER JOIN Parcela on Parcela.id = TestParcela.idParcela");
    return result;
  }

  Future<List<TestParcela>> getTest(int id) async {
    Database db = await database;
    List<Map> test =
        await db.query('TestParcela', where: 'id=?', whereArgs: [id]);
    return test.length == 0
        ? []
        : test.map((e) => TestParcela.fromMap(e)).toList();
  }
}
