import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/pages/add_finca.dart';
import 'package:flutter_poda/providers/db_provider.dart';

import 'modify_finca.dart';

class ListFincasPage extends StatefulWidget {
  const ListFincasPage({Key key}) : super(key: key);

  @override
  _ListFincasPageState createState() => _ListFincasPageState();
}

class _ListFincasPageState extends State<ListFincasPage> {
  List<Finca> _fincas = [];

  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshFincasList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis fincas"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _list(),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFincaPage()),
                    );
                  },
                ),
              ]),
        ));
  }

  _refreshFincasList() async {
    List<Finca> x = await _dbHelper.fetchFincas();
    setState(() {
      _fincas = x;
    });
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_fincas[index].nombre.toUpperCase()),
                      subtitle: Text(_fincas[index].area.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ModifyFincaPage(objFincas: _fincas[index])),
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
