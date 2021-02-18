import 'package:flutter/material.dart';
import 'package:flutter_poda/pages/new_test.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class EstacionesPage extends StatefulWidget {
  final int testid;
  const EstacionesPage({Key key, this.testid}) : super(key: key);

  @override
  _EstacionesPageState createState() => _EstacionesPageState();
}

class _EstacionesPageState extends State<EstacionesPage> {
  DatabaseHelper _dbHelper;
  List result;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _count();
    });
  }

  _count() async {
    List x = await _dbHelper.getEstaciones(widget.testid);
    setState(() {
      result = x;
      print(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estaciones"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_list()]),
    );
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: Text('Estacion 1'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewTestPage(
                                        testid: widget.testid, estacion: 1)),
                              );
                            }),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Estacion 2'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewTestPage(
                                        testid: widget.testid, estacion: 2)),
                              );
                            }),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Estacion 3'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewTestPage(
                                        testid: widget.testid, estacion: 3)),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ).toList(),
            )),
      );
}
