import 'package:flutter/material.dart';
import 'package:flutter_poda/models/test_parcela.dart';
import 'package:flutter_poda/pages/add_decisiones.dart';
import 'package:flutter_poda/pages/estaciones.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class DecisionesPage extends StatefulWidget {
  const DecisionesPage({Key key}) : super(key: key);

  @override
  _DecisionesPageState createState() => _DecisionesPageState();
}

class _DecisionesPageState extends State<DecisionesPage> {
  List _tests = [];
  DatabaseHelper _dbHelper;
  List<TestParcela> _test;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshTestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tomar datos y decisiones"),
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
                      MaterialPageRoute(
                          builder: (context) => AddDecisionesPage()),
                    );
                  },
                ),
              ]),
        ));
  }

  _refreshTestList() async {
    List x = await _dbHelper.fetchTestParcela();
    setState(() {
      _tests = x;
    });
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
                      title: Text(_tests[index]['finca'].toString()),
                      subtitle: Text(_tests[index]['parcela'].toString() +
                          '\n fecha: ' +
                          _tests[index]['fecha'].toString()),
                      isThreeLine: true,
                      //   trailing: IconButton(
                      //       icon: Icon(Icons.delete_sweep),
                      //       onPressed: () async {}),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddDecisionesPage(
                                  testid: _tests[index]['id'])),
                        );
                      },
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
                                      builder: (context) => EstacionesPage(
                                          testid: _tests[index]['id'])),
                                );
                              }),
                        ],
                      ),
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
