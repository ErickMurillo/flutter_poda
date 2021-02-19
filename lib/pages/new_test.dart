import 'package:flutter/material.dart';
import 'package:flutter_poda/models/estaciones.dart';
import 'package:flutter_poda/pages/estaciones.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _estacionesCtls.text = widget.estacion.toString();
      _plantasCtls.text = widget.planta.toString();
      _estaciones.idTest = widget.testid;
      _estaciones.produccion = 'Alta';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Test"),
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
                            ? _estaciones.buenaArquitectura = "Si"
                            : _estaciones.buenaArquitectura = "No");
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas en contacto'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasContacto = "Si"
                            : _estaciones.ramasContacto = "No");
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas entrecruzados'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasEntrecruzados = "Si"
                            : _estaciones.ramasEntrecruzados = "No");
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Ramas cercanas al suelo'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.ramasSuelo = "Si"
                            : _estaciones.ramasSuelo = "No");
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Chupones'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.chupones = "Si"
                            : _estaciones.chupones = "No");
                      },
                    ),
                    CheckboxListTileFormField(
                      title: Text('Entrada de luz'),
                      onSaved: (bool value) {
                        setState(() => value == true
                            ? _estaciones.entradaLuz = "Si"
                            : _estaciones.entradaLuz = "No");
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
                            () =>
                                [radios = val, _estaciones.produccion = 'Alta'],
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
                            () => [
                              radios = val,
                              _estaciones.produccion = 'Media'
                            ],
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
                            () =>
                                [radios = val, _estaciones.produccion = 'Baja'],
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

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EstacionesPage(testid: widget.testid)),
      );
    }
  }
}
