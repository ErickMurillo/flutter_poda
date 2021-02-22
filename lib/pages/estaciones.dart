import 'package:flutter/material.dart';
import 'package:flutter_poda/models/estaciones.dart';
import 'package:flutter_poda/pages/new_test2.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

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
  int id;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      id = widget.testid;
      _count(id);
    });
  }

  _count(int id) async {
    List x1 = await _dbHelper.getEstaciones(id, 1);
    List x2 = await _dbHelper.getEstaciones(id, 2);
    List x3 = await _dbHelper.getEstaciones(id, 3);
    setState(() {
      planta1 = x1.length;
      planta2 = x2.length;
      planta3 = x3.length;
    });
  }

  void refreshData() {
    _count(id);
  }

  onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void navigateSecondPage(int estacion, int planta) {
    Route route = MaterialPageRoute(
        builder: (context) => NewTestPage(
            testid: widget.testid, estacion: estacion, planta: planta + 1));
    Navigator.push(context, route).then(onGoBack);
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
                      ).then((setState) => _count(widget.testid)),
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
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => NewTestPage(
                                  //             testid: widget.testid,
                                  //             estacion: 1,
                                  //             planta: planta1 + 1)),
                                  //   );
                                  navigateSecondPage(1, planta1);
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

// vista para agregar plantas a la estacion
class NewTestPage extends StatefulWidget {
  final int testid;
  final int estacion;
  final int planta;
  const NewTestPage({Key key, this.testid, this.estacion, this.planta})
      : super(key: key);

  @override
  _NewTestPageState createState() => _NewTestPageState();
}

class _NewTestPageState extends State<NewTestPage> {
  DatabaseHelper _dbHelper;

  Estaciones _estaciones = Estaciones();

  final _formKey = GlobalKey<FormState>();

  final _estacionesCtls = TextEditingController();

  final _plantasCtls = TextEditingController();

  final _alturaCtls = TextEditingController();

  final _anchoCtls = TextEditingController();

  final _largoCtls = TextEditingController();

  int radios = 3;
  String numPlanta;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _estacionesCtls.text = widget.estacion.toString();
      _plantasCtls.text = widget.planta.toString();
      _estaciones.idTest = widget.testid;
      _estaciones.produccion = 3;
      numPlanta = widget.planta.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planta #$numPlanta"),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      enabled: false,
                      controller: _estacionesCtls,
                      decoration: InputDecoration(labelText: 'Estacion'),
                      onSaved: (val) =>
                          setState(() => _estaciones.estacion = int.parse(val)),
                    ),
                    TextFormField(
                      enabled: false,
                      controller: _plantasCtls,
                      decoration: InputDecoration(labelText: 'Planta'),
                      onSaved: (val) =>
                          setState(() => _estaciones.planta = int.parse(val)),
                    ),
                    TextFormField(
                      controller: _alturaCtls,
                      decoration: InputDecoration(labelText: 'Altura en mt'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val.length == 0 ? 'required' : null),
                      onSaved: (val) => setState(
                          () => _estaciones.altura = double.parse(val)),
                    ),
                    TextFormField(
                      controller: _anchoCtls,
                      decoration: InputDecoration(labelText: 'Ancho en mt'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val.length == 0 ? 'required' : null),
                      onSaved: (val) =>
                          setState(() => _estaciones.ancho = double.parse(val)),
                    ),
                    TextFormField(
                      controller: _largoCtls,
                      decoration: InputDecoration(
                          labelText: 'Largo de madera productiva'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val.length == 0 ? 'required' : null),
                      onSaved: (val) =>
                          setState(() => _estaciones.largo = double.parse(val)),
                    ),
                    CheckboxListTileFormField(
                      title: Text('Buena arquitectura'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.buenaArquitectura = 1
                            : _estaciones.buenaArquitectura = 0);
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas en contacto'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasContacto = 1
                            : _estaciones.ramasContacto = 0);
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas entrecruzados'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasEntrecruzados = 1
                            : _estaciones.ramasEntrecruzados = 0);
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas cercanas al suelo'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasSuelo = 1
                            : _estaciones.ramasSuelo = 0);
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Chupones'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.chupones = 1
                            : _estaciones.chupones = 0);
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Entrada de luz'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.entradaLuz = 1
                            : _estaciones.entradaLuz = 0);
                      },
                    ),
                    Text('Produccion'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: 3,
                          groupValue: radios,
                          onChanged: (val) => setState(
                            () => [radios = val, _estaciones.produccion = 3],
                          ),
                        ),
                        new Text(
                          'Alta',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: radios,
                          onChanged: (val) => setState(
                            () => [radios = val, _estaciones.produccion = 2],
                          ),
                          //   onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'Media',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: radios,
                          onChanged: (val) => setState(
                            () => [radios = val, _estaciones.produccion = 1],
                          ),
                        ),
                        new Text(
                          'Baja',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ])))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _onSubmit(),
      ),
    );
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_estaciones.id == null)
        await _dbHelper.insertEstacion(_estaciones);
      else
        await _dbHelper.updateEstacion(_estaciones);

      form.reset();
      _estacionesCtls.clear();
      _plantasCtls.clear();
      _alturaCtls.clear();
      _anchoCtls.clear();
      _largoCtls.clear();

      Navigator.pop(context);
    }
  }
}
