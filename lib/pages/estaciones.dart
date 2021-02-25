import 'package:flutter/material.dart';
import 'package:flutter_poda/models/estaciones.dart';
import 'package:flutter_poda/pages/home.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter_poda/models/resultados.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:select_form_field/select_form_field.dart';

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
  bool resultTest;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _count(widget.testid);
      _getResult(widget.testid);
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
    _count(widget.testid);
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

  _getResult(int id) async {
    List x = await _dbHelper.getResultado(id);
    setState(() {
      if (x != null)
        return resultTest == true;
      else
        return resultTest == false;
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
                ? resultTest == false
                    ? Container(
                        color: Colors.white,
                        child: RaisedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewTest2Page(testid: widget.testid)),
                          ).then((setState) => {
                                _count(widget.testid),
                                _getResult(widget.testid)
                              }),
                          child: Text('Ver Datos'),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        child: RaisedButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (Route<dynamic> route) => false),
                          child: Text('Inicio'),
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
                                  navigateSecondPage(2, planta2);
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
                                  navigateSecondPage(3, planta3);
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

// vista para agregar plantas a la estacion ////////////////////////////////////////////////////////////
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

  final _alturaCtls = TextEditingController();

  final _anchoCtls = TextEditingController();

  final _largoCtls = TextEditingController();

  int radios = 3;
  String numPlanta;
  String numEstacion;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _estaciones.idTest = widget.testid;
      _estaciones.produccion = 3;
      numPlanta = widget.planta.toString();
      numEstacion = widget.estacion.toString();
      _estaciones.estacion = widget.estacion;
      _estaciones.planta = widget.planta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planta #$numPlanta Estación #$numEstacion"),
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
      _alturaCtls.clear();
      _anchoCtls.clear();
      _largoCtls.clear();

      Navigator.pop(context);
    }
  }
}

//////////////////////  Resultados ///////////////////////////////////////////////////////////////////
class NewTest2Page extends StatefulWidget {
  final int testid;
  const NewTest2Page({Key key, this.testid}) : super(key: key);

  @override
  _NewTest2PageState createState() => _NewTest2PageState();
}

class _NewTest2PageState extends State<NewTest2Page> {
  DatabaseHelper _dbHelper;
  List result;
  final _formKey = GlobalKey<FormState>();
  final _ctlAplicar = TextEditingController();
  final _ctlVigor = TextEditingController();
  final _ctlLuz = TextEditingController();
  Resultado _resultado = Resultado();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _getAltura();
      _resultado.idTest = widget.testid;
    });
  }

  _getAltura() async {
    List x = await _dbHelper.getAlturas(widget.testid);
    setState(() {
      result = x;
    });
  }

  _submit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_resultado.id == null)
        await _dbHelper.insertResultado(_resultado);
      else
        await _dbHelper.updateResultado(_resultado);

      form.reset();
      _ctlAplicar.clear();
      _ctlVigor.clear();
      _ctlLuz.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos consolidados'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _submit();
                },
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return index == 0
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            columnSpacing: 25.0,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Estación',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '1',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '2',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '3',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                            rows: result
                                    ?.map(((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                                Text(element[0].toString())),
                                            DataCell(Text(
                                                element[1].toStringAsFixed(0))),
                                            DataCell(Text(
                                                element[2].toStringAsFixed(0))),
                                            DataCell(Text(
                                                element[3].toStringAsFixed(0))),
                                            DataCell(Text(
                                                element[4].toStringAsFixed(0)))
                                          ],
                                        )))
                                    ?.toList() ??
                                [],
                          ),
                        ),
                      )
                    : Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: MultiSelectFormField(
                                    title: Text(
                                      "Problemas de poda",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    dataSource: [
                                      {
                                        "display": "Altura",
                                        "value": '1',
                                      },
                                      {
                                        "display": "Ancho",
                                        "value": '2',
                                      },
                                      {
                                        "display": "Ramas",
                                        "value": '3',
                                      },
                                      {
                                        "display": "Arquitectura",
                                        "value": '4',
                                      },
                                      {
                                        "display": "Chupones",
                                        "value": '5',
                                      },
                                      {
                                        "display": "Poca entrada de luz",
                                        "value": '6',
                                      },
                                      {
                                        "display": "Baja productividad",
                                        "value": '7',
                                      },
                                      {
                                        "display": "Ninguno",
                                        "value": '0',
                                      },
                                    ],
                                    hintWidget: Text('Seleccione uno o más'),
                                    textField: 'display',
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCELAR',
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        _resultado.problemasPoda =
                                            value.toString();
                                      });
                                    }),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: MultiSelectFormField(
                                    title: Text(
                                      "¿Qué tipo de poda debemos aplicar?",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    dataSource: [
                                      {
                                        "display": "Poda de altura",
                                        "value": '1',
                                      },
                                      {
                                        "display": "Poda de ramas",
                                        "value": '2',
                                      },
                                      {
                                        "display": "Poda de formación",
                                        "value": '3',
                                      },
                                      {
                                        "display": "Deschuponar",
                                        "value": '4',
                                      },
                                      {
                                        "display": "Cambio de coronas",
                                        "value": '5',
                                      },
                                    ],
                                    hintWidget: Text('Seleccione uno o más'),
                                    textField: 'display',
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCELAR',
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        _resultado.tipoPoda = value.toString();
                                      });
                                    }),
                              ),
                              Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: SelectFormField(
                                    controller: _ctlAplicar,
                                    items: [
                                      {
                                        "label": "En toda la parcela",
                                        "value": '1',
                                      },
                                      {
                                        "label": "En varios partes",
                                        "value": '2',
                                      },
                                      {
                                        "label": "En algunas partes",
                                        "value": '3',
                                      },
                                    ],
                                    labelText:
                                        '¿En qué parte vamos a aplicar las podas?',
                                    onChanged: (val) => print(val),
                                    onSaved: (val) =>
                                        _resultado.aplicarPoda = val,
                                    validator: (val) =>
                                        (val == null ? 'required' : null),
                                  )),
                              Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: SelectFormField(
                                    controller: _ctlVigor,
                                    items: [
                                      {
                                        "label": "Todas las plantas",
                                        "value": '1',
                                      },
                                      {
                                        "label": "Algunas de las plantas",
                                        "value": '2',
                                      },
                                      {
                                        "label": "Ninguna de las planta",
                                        "value": '3',
                                      },
                                    ],
                                    labelText:
                                        '¿Las plantas tiene suficiente vigor?',
                                    onChanged: (val) => print(val),
                                    onSaved: (val) =>
                                        _resultado.plantasVigor = val,
                                    validator: (val) =>
                                        (val == null ? 'required' : null),
                                  )),
                              Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: SelectFormField(
                                    controller: _ctlLuz,
                                    items: [
                                      {
                                        "label": "Poda de copa",
                                        "value": '1',
                                      },
                                      {
                                        "label": "Poda de ramas entrecruzadas",
                                        "value": '2',
                                      },
                                      {
                                        "label": "Arreglo de la sombra",
                                        "value": '3',
                                      },
                                    ],
                                    labelText:
                                        '¿Cómo podemos mejorar la entrada de luz?',
                                    onChanged: (val) => print(val),
                                    onSaved: (val) =>
                                        _resultado.entradaLuz = val,
                                    validator: (val) =>
                                        (val == null ? 'required' : null),
                                  )),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: MultiSelectFormField(
                                    title: Text(
                                      "¿Cúando vamos a realizar las podas?",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    dataSource: [
                                      {
                                        "display": "Enero",
                                        "value": '1',
                                      },
                                      {
                                        "display": "Febrero",
                                        "value": '2',
                                      },
                                      {
                                        "display": "Marzo",
                                        "value": '3',
                                      },
                                      {
                                        "display": "Abril",
                                        "value": '4',
                                      },
                                      {
                                        "display": "Mayo",
                                        "value": '5',
                                      },
                                      {
                                        "display": "Junio",
                                        "value": '6',
                                      },
                                      {
                                        "display": "Julio",
                                        "value": '7',
                                      },
                                      {
                                        "display": "Agosto",
                                        "value": '8',
                                      },
                                      {
                                        "display": "Septiembre",
                                        "value": '9',
                                      },
                                      {
                                        "display": "Octubre",
                                        "value": '10',
                                      },
                                      {
                                        "display": "Noviembre",
                                        "value": '11',
                                      },
                                      {
                                        "display": "Diciembre",
                                        "value": '12',
                                      },
                                    ],
                                    hintWidget: Text('Seleccione uno o más'),
                                    textField: 'display',
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCELAR',
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        _resultado.mesesPoda = value.toString();
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
