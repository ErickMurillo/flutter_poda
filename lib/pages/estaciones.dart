import 'package:flutter/material.dart';
import 'package:flutter_poda/pages/new_test.dart';
import 'package:flutter_poda/pages/new_test2.dart';
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
  int planta1 = 0;
  int planta2 = 0;
  int planta3 = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _count();
    });
  }

  _count() async {
    List x1 = await _dbHelper.getEstaciones(widget.testid, 1);
    List x2 = await _dbHelper.getEstaciones(widget.testid, 2);
    List x3 = await _dbHelper.getEstaciones(widget.testid, 3);
    setState(() {
      planta1 = x1.length;
      planta2 = x2.length;
      planta3 = x3.length;
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
          children: <Widget>[
            _list(),
            planta1 == 10 && planta2 == 10 && planta3 == 10
                ? Container(
                    color: Colors.white,
                    child: RaisedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewTest2Page(testid: widget.testid)),
                      ),
                      child: Text('Ver Datos'),
                    ),
                  )
                : Container(),
          ]),
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
                    title: Text('Estacion 1 - plantas $planta1/10'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        planta1 < 10
                            ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewTestPage(
                                            testid: widget.testid,
                                            estacion: 1,
                                            planta: planta1 + 1)),
                                  );
                                })
                            : IconButton(
                                icon: Icon(Icons.check), onPressed: () {}),
                        //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Estacion 2 - plantas $planta2/10'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        planta2 < 10
                            ?
                            //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewTestPage(
                                            testid: widget.testid,
                                            estacion: 2,
                                            planta: planta2 + 1)),
                                  );
                                })
                            : IconButton(
                                icon: Icon(Icons.check), onPressed: () {}),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Estacion 3 - plantas $planta3/10'),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        planta3 < 10
                            ?
                            //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewTestPage(
                                            testid: widget.testid,
                                            estacion: 3,
                                            planta: planta3 + 1)),
                                  );
                                })
                            : IconButton(
                                icon: Icon(Icons.check), onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              ).toList(),
            )),
      );
}
