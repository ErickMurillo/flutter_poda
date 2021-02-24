import 'package:flutter/material.dart';

class ConsultarRegistroPage extends StatefulWidget {
  const ConsultarRegistroPage({Key key}) : super(key: key);

  @override
  _ConsultarRegistroPageState createState() => _ConsultarRegistroPageState();
}

class _ConsultarRegistroPageState extends State<ConsultarRegistroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consultar registro de poda de Cacao"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[]),
        ));
  }
}
