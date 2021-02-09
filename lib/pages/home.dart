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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Mis fincas'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListFincasPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Mis parcelas'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListParcelasPage()),
                );
              },
            ),
          ]),
    );
  }
}
