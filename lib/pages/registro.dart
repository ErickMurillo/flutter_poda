import 'package:flutter/material.dart';
import 'package:flutter_poda/models/test_parcela.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class ConsultarRegistroPage extends StatefulWidget {
  const ConsultarRegistroPage({Key key}) : super(key: key);

  @override
  _ConsultarRegistroPageState createState() => _ConsultarRegistroPageState();
}

class _ConsultarRegistroPageState extends State<ConsultarRegistroPage> {
  DatabaseHelper _dbHelper;
  List _fincas = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshFincasList();
  }

  _refreshFincasList() async {
    List x = await _dbHelper.getFincasRegistro();
    setState(() {
      _fincas = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consultar registro de poda de Cacao"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_list()]),
        ));
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_fincas[index]['nombre'].toUpperCase()),
                      subtitle: Text(_fincas[index]['area'].toString() +
                          ' ' +
                          _fincas[index]['unidad'] +
                          '\n # Parcelas: ' +
                          _fincas[index]['parcelas'].toString()),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistroParcelaPage(
                                  idFinca: _fincas[index]['id'],
                                  nombreFinca: _fincas[index]['nombre'])),
                        );
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _fincas.length,
            )),
      );
}

class RegistroParcelaPage extends StatefulWidget {
  final int idFinca;
  final String nombreFinca;
  const RegistroParcelaPage({Key key, this.idFinca, this.nombreFinca})
      : super(key: key);

  @override
  _RegistroParcelaPageState createState() => _RegistroParcelaPageState();
}

class _RegistroParcelaPageState extends State<RegistroParcelaPage> {
  DatabaseHelper _dbHelper;
  String nombre;
  List _parcelas = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      nombre = widget.nombreFinca;
      _listas(widget.idFinca);
    });
  }

  _listas(int id) async {
    List parcela = await _dbHelper.fetchParcela(id);
    setState(() {
      _parcelas = parcela;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$nombre"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_list()]),
        ));
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_parcelas[index]['nombre'].toUpperCase()),
                      subtitle: Text(_parcelas[index]['area'].toString() +
                          '\n Plantas:' +
                          _parcelas[index]['plantas'].toString()),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistroTestPage(
                                  idParcela: _parcelas[index]['id'])),
                        );
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _parcelas.length,
            )),
      );
}

class RegistroTestPage extends StatefulWidget {
  final int idParcela;
  const RegistroTestPage({Key key, this.idParcela}) : super(key: key);

  @override
  _RegistroTestPageState createState() => _RegistroTestPageState();
}

class _RegistroTestPageState extends State<RegistroTestPage> {
  List _tests;
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _getTest(widget.idParcela);
    });
  }

  _getTest(int id) async {
    List x = await _dbHelper.getTestRegistro(id);
    setState(() {
      _tests = x;
      print(_tests);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tests"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_list()]),
        ));
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_tests[index]['fecha'].toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalidaRegistroPage(
                                  testid: _tests[index]['id'])),
                        );
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _tests.length,
            )),
      );
}

class SalidaRegistroPage extends StatefulWidget {
  final int testid;
  const SalidaRegistroPage({Key key, this.testid}) : super(key: key);

  @override
  _SalidaRegistroPageState createState() => _SalidaRegistroPageState();
}

class _SalidaRegistroPageState extends State<SalidaRegistroPage> {
  DatabaseHelper _dbHelper;
  List _tabla;
  List _preguntas;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _getResultados(widget.testid);
    });
  }

  _getResultados(int id) async {
    List x = await _dbHelper.getAlturas(id);
    List result = await _dbHelper.getResultado(id);
    setState(() {
      _tabla = x;
      _preguntas = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Resultados"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_resultTabla()]),
        ));
  }

  _resultTabla() => Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columnSpacing: 25.0,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Estación',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '1',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '2',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '3',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: _tabla
                          ?.map(((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(element[0].toString())),
                                  DataCell(Text(element[1].toStringAsFixed(0))),
                                  DataCell(Text(element[2].toStringAsFixed(0))),
                                  DataCell(Text(element[3].toStringAsFixed(0))),
                                  DataCell(Text(element[4].toStringAsFixed(0)))
                                ],
                              )))
                          ?.toList() ??
                      [],
                ),
              ),
            );
          }));
}
