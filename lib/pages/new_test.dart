import 'package:flutter/material.dart';
import 'package:flutter_poda/models/estaciones.dart';
import 'package:flutter_poda/pages/estaciones.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';

class NewTestPage extends StatefulWidget {
  final int testid;
  final int estacion;
  const NewTestPage({Key key, this.testid, this.estacion}) : super(key: key);

  @override
  _NewTestPageState createState() => _NewTestPageState();
}

class _NewTestPageState extends State<NewTestPage> {
  DatabaseHelper _dbHelper;

  List<Estaciones> _estaciones = [
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
    Estaciones(),
  ];

  List<GlobalKey<FormState>> _formkeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  List<TextEditingController> _estacionesCtls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<TextEditingController> _plantasCtls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<TextEditingController> _alturaCtls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<TextEditingController> _anchoCtls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<TextEditingController> _largoCtls = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<int> radios = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3];
  List _formState = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      for (var i = 0; i <= 9; i++) {
        _estacionesCtls[i].text = widget.estacion.toString();
        _plantasCtls[i].text = (i + 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Test"),
      ),
      body: Swiper(
        loop: false,
        onIndexChanged: (int index) async {
          if (index >= 0) {
            _formState.add(_formkeys[index - 1].currentState);
            if (_formState[index - 1].validate()) {
              if (_estaciones[index - 1].id == null)
                await _dbHelper.insertEstacion(_estaciones[index - 1]);
              else
                await _dbHelper.updateEstacion(_estaciones[index - 1]);

              _formState[index - 1].reset();
              //   _estacionesCtls[index - 1].clear();
              //   _plantasCtls[index - 1].clear();
              //   _alturaCtls[index - 1].clear();
              //   _anchoCtls[index - 1].clear();
              //   _largoCtls[index - 1].clear();
            }
          }

          // _currentIndex = index;
        },
        itemBuilder: (BuildContext context, int index) {
          if (index <= 1) {
            return new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Form(
                        key: _formkeys[index],
                        child: Column(children: <Widget>[
                          TextFormField(
                            enabled: false,
                            controller: _estacionesCtls[index],
                            decoration: InputDecoration(labelText: 'Estacion'),
                            onSaved: (val) => setState(() =>
                                _estaciones[index].estacion = int.parse(val)),
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _plantasCtls[index],
                            decoration: InputDecoration(labelText: 'Planta'),
                            onSaved: (val) => setState(() =>
                                _estaciones[index].planta = int.parse(val)),
                          ),
                          TextFormField(
                            controller: _alturaCtls[index],
                            decoration:
                                InputDecoration(labelText: 'Altura en mt'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (val) =>
                                (val.length == 0 ? 'required' : null),
                            onSaved: (val) => setState(() =>
                                _estaciones[index].altura = double.parse(val)),
                          ),
                          TextFormField(
                            controller: _anchoCtls[index],
                            decoration:
                                InputDecoration(labelText: 'Ancho en mt'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (val) =>
                                (val.length == 0 ? 'required' : null),
                            onSaved: (val) => setState(() =>
                                _estaciones[index].ancho = double.parse(val)),
                          ),
                          TextFormField(
                            controller: _largoCtls[index],
                            decoration: InputDecoration(
                                labelText: 'Largo de madera productiva'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (val) =>
                                (val.length == 0 ? 'required' : null),
                            onSaved: (val) => setState(() =>
                                _estaciones[index].largo = double.parse(val)),
                          ),
                          CheckboxListTileFormField(
                            title: Text('Buena arquitectura'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].buenaArquitectura = "Si"
                                  : _estaciones[index].buenaArquitectura =
                                      "No");
                            },
                          ),
                          CheckboxListTileFormField(
                            title: Text('Ramas en contacto'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].ramasContacto = "Si"
                                  : _estaciones[index].ramasContacto = "No");
                            },
                          ),
                          CheckboxListTileFormField(
                            title: Text('Ramas entrecruzados'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].ramasEntrecruzados = "Si"
                                  : _estaciones[index].ramasEntrecruzados =
                                      "No");
                            },
                          ),
                          CheckboxListTileFormField(
                            title: Text('Ramas cercanas al suelo'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].ramasSuelo = "Si"
                                  : _estaciones[index].ramasSuelo = "No");
                            },
                          ),
                          CheckboxListTileFormField(
                            title: Text('Chupones'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].chupones = "Si"
                                  : _estaciones[index].chupones = "No");
                            },
                          ),
                          CheckboxListTileFormField(
                            title: Text('Entrada de luz'),
                            onSaved: (bool value) {
                              setState(() => value == true
                                  ? _estaciones[index].entradaLuz = "Si"
                                  : _estaciones[index].entradaLuz = "No");
                            },
                          ),
                          Text('Produccion'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                value: 3,
                                groupValue: radios[index],
                                onChanged: (val) => setState(
                                  () => radios[index] = val,
                                ),
                              ),
                              new Text(
                                'Alta',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 2,
                                groupValue: radios[index],
                                onChanged: (val) => setState(
                                  () => radios[index] = val,
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
                                groupValue: radios[index],
                                onChanged: (val) => setState(
                                  () => radios[index] = val,
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
            );
          } else {
            return new Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Guardar'),
                )
              ],
            );
          }
        },
        itemCount: 3,
        pagination: new SwiperPagination(),
      ),
      //   floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () => _onSubmit(),
      //   ),
    );
  }

  _onSubmit() async {
    // for (var i = 0; i <= 1; i++) {
    //   print(['datos $i', _estaciones[i]]);

    //   if (_formState[i].validate()) {
    //     if (_estaciones[i].id == null)
    //       await _dbHelper.insertEstacion(_estaciones[i]);
    //     else
    //       await _dbHelper.updateEstacion(_estaciones[i]);

    //     _formState[i].reset();
    //     _estacionesCtls[i].clear();
    //     _plantasCtls[i].clear();
    //     _alturaCtls[i].clear();
    //     _anchoCtls[i].clear();
    //     _largoCtls[i].clear();
    //   }
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EstacionesPage(testid: widget.testid)),
    );
  }
}
