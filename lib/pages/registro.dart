import 'package:flutter/material.dart';
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
      print(_fincas);
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
                                  finca: _fincas[index]['id'])),
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
  final int finca;
  const RegistroParcelaPage({Key key, this.finca}) : super(key: key);

  @override
  _RegistroParcelaPageState createState() => _RegistroParcelaPageState();
}

class _RegistroParcelaPageState extends State<RegistroParcelaPage> {
  DatabaseHelper _dbHelper;
  String nombre;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[]),
        ));
  }
}
