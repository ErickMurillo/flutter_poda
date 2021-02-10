import 'package:flutter/material.dart';
import 'package:flutter_poda/pages/list_fincas.dart';

import 'list_parcelas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inicio'),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Fincas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListFincasPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Parcelas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListParcelasPage()),
                );
              },
            ),
          ],
        ));
  }
}
