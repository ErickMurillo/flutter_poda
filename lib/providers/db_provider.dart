import 'dart:io';
import 'package:flutter_poda/models/estaciones.dart';
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
          'buenaArquitectura INTEGER,'
          'ramasContacto INTEGER,'
          'ramasEntrecruzados INTEGER,'
          'ramasSuelo INTEGER,'
          'chupones INTEGER,'
          'entradaLuz INTEGER,'
          'produccion INTEGER,'
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

  // estaciones CRUD
  Future<int> insertEstacion(Estaciones estacion) async {
    Database db = await database;
    return await db.insert('Estaciones', estacion.toMap());
  }

  Future<int> updateEstacion(Estaciones estacion) async {
    Database db = await database;
    return await db.update('Estaciones', estacion.toMap(),
        where: 'id=?', whereArgs: [estacion.id]);
  }

  Future<List> getEstaciones(int idTest, int estacion) async {
    Database db = await database;
    var result = await db.rawQuery(
        'SELECT * from Estaciones where idTest=? and estacion=? ',
        [idTest, estacion]);
    return result;
  }

  //consolidados
  Future<List> getAlturas(int idTest) async {
    Database db = await database;
    List lista = [];
    var estacion1 = await db.rawQuery(
        'SELECT SUM(altura) as altura,SUM(ancho) as ancho, SUM(largo) as largo,'
        'AVG(buenaArquitectura) * 100 as arquitectura, AVG(ramasContacto) * 100 as contacto,'
        'AVG(ramasEntrecruzados) * 100 as entrecruzados, AVG(ramasSuelo) * 100 as suelo,'
        'AVG(chupones) * 100 as chupones, AVG(entradaLuz) * 100 as luz'
        ' from Estaciones WHERE estacion=1 and idTest=?',
        [idTest]);
    var estacion2 = await db.rawQuery(
        'SELECT SUM(altura) as altura,SUM(ancho) as ancho, SUM(largo) as largo,'
        'AVG(buenaArquitectura) * 100 as arquitectura, AVG(ramasContacto) * 100 as contacto,'
        'AVG(ramasEntrecruzados) * 100 as entrecruzados, AVG(ramasSuelo) * 100 as suelo,'
        'AVG(chupones) * 100 as chupones, AVG(entradaLuz) * 100 as luz'
        ' from Estaciones WHERE estacion=2 and idTest=?',
        [idTest]);
    var estacion3 = await db.rawQuery(
        'SELECT SUM(altura) as altura,SUM(ancho) as ancho, SUM(largo) as largo,'
        'AVG(buenaArquitectura) * 100 as arquitectura, AVG(ramasContacto) * 100 as contacto,'
        'AVG(ramasEntrecruzados) * 100 as entrecruzados, AVG(ramasSuelo) * 100 as suelo,'
        'AVG(chupones) * 100 as chupones, AVG(entradaLuz) * 100 as luz'
        ' from Estaciones WHERE estacion=2 and idTest=?',
        [idTest]);

    //altura
    var totalAltura = estacion1.first['altura'] +
        estacion2.first['altura'] +
        estacion3.first['altura'];

    lista.add([
      'Altura mt',
      estacion1.first['altura'],
      estacion2.first['altura'],
      estacion3.first['altura'],
      totalAltura
    ]);

    //ancho
    var totalAncho = estacion1.first['ancho'] +
        estacion2.first['ancho'] +
        estacion3.first['ancho'];

    lista.add([
      'Ancho mt',
      estacion1.first['ancho'],
      estacion2.first['ancho'],
      estacion3.first['ancho'],
      totalAncho
    ]);

    // alto
    var totalLargo = estacion1.first['largo'] +
        estacion2.first['largo'] +
        estacion3.first['largo'];
    lista.add([
      'Largo mt',
      estacion1.first['largo'],
      estacion2.first['largo'],
      estacion3.first['largo'],
      totalLargo
    ]);

    //arquitectura
    var totalArquitectura = (estacion1.first['arquitectura'] +
            estacion2.first['arquitectura'] +
            estacion3.first['arquitectura']) /
        3;
    lista.add([
      'Buena arquitectura %',
      estacion1.first['arquitectura'],
      estacion2.first['arquitectura'],
      estacion3.first['arquitectura'],
      totalArquitectura
    ]);

    //ramas contacto
    var totalContacto = (estacion1.first['contacto'] +
            estacion2.first['contacto'] +
            estacion3.first['contacto']) /
        3;
    lista.add([
      'Ramas en contacto %',
      estacion1.first['contacto'],
      estacion2.first['contacto'],
      estacion3.first['contacto'],
      totalContacto
    ]);

    //ramasEntrecruzados
    var totalEntrecruzados = (estacion1.first['entrecruzados'] +
            estacion2.first['entrecruzados'] +
            estacion3.first['entrecruzados']) /
        3;
    lista.add([
      'Ramas entrecruzados %',
      estacion1.first['entrecruzados'],
      estacion2.first['entrecruzados'],
      estacion3.first['entrecruzados'],
      totalEntrecruzados
    ]);

    //ramas suelo
    var totalSuelo = (estacion1.first['suelo'] +
            estacion2.first['suelo'] +
            estacion3.first['suelo']) /
        3;
    lista.add([
      'Ramas cercanas al suelo %',
      estacion1.first['suelo'],
      estacion2.first['suelo'],
      estacion3.first['suelo'],
      totalSuelo
    ]);

    //ramas suelo
    var totalChupones = (estacion1.first['suelo'] +
            estacion2.first['suelo'] +
            estacion3.first['suelo']) /
        3;
    lista.add([
      'Chupones %',
      estacion1.first['suelo'],
      estacion2.first['suelo'],
      estacion3.first['suelo'],
      totalChupones
    ]);

    //entrada luz
    var totalLuz = (estacion1.first['luz'] +
            estacion2.first['luz'] +
            estacion3.first['luz']) /
        3;
    lista.add([
      'Entrada de luz %',
      estacion1.first['luz'],
      estacion2.first['luz'],
      estacion3.first['luz'],
      totalLuz
    ]);

    //produccion alta
    var prod1 = await db.rawQuery(
        'SELECT COUNT(produccion) as alta from Estaciones WHERE estacion=1 and idTest=? and produccion=3',
        [idTest]);

    var prod2 = await db.rawQuery(
        'SELECT COUNT(produccion) as alta from Estaciones WHERE estacion=2 and idTest=? and produccion=3',
        [idTest]);

    var prod3 = await db.rawQuery(
        'SELECT COUNT(produccion) as alta from Estaciones WHERE estacion=3 and idTest=? and produccion=3',
        [idTest]);

    // var totalprodAlta =
    //     ([prod1.first / 10]) + prod2.first['alta'] + prod3.first['alta'];

    // lista.add([
    //   '% Producción Alta',
    //   prod1.first['alta'],
    //   prod2.first['alta'],
    //   prod3.first['alta'],
    //   totalprodAlta
    // ]);

    // lista.add([
    //   '% Producción Media',
    //   prod1.first['media'],
    //   prod2.first['media'],
    //   prod3.first['media'],
    //   totalLuz
    // ]);

    // lista.add([
    //   '% Producción Baja',
    //   prod1.first['baja'],
    //   prod2.first['baja'],
    //   prod3.first['baja'],
    //   totalLuz
    // ]);
    return lista;
  }
}
