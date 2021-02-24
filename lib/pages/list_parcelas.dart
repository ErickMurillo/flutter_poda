import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/variedad.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListParcelasPage extends StatefulWidget {
  const ListParcelasPage({Key key}) : super(key: key);

  @override
  _ListParcelasPageState createState() => _ListParcelasPageState();
}

class _ListParcelasPageState extends State<ListParcelasPage> {
  Parcela _parcela = Parcela();
  final _formKey = GlobalKey<FormState>();
  final _ctlNombre = TextEditingController();
  final _ctlArea = TextEditingController();
  final _ctlPlantas = TextEditingController();
  int selectedVariedad;
  int selectedFinca;
  List<Variedad> _variedades = [];
  List<Finca> _fincas = [];
  List _parcelas = [];
  DatabaseHelper _dbHelper;
  var totalArea;
  List<Finca> _areaFinca = [];
  double validateParcela;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshVariedadList();
    _refreshFincaList();
    _refreshParcelaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mis Parcelas"), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _openPopup(context);
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ]),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _list(),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Agregar variedad'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListVariedadesPage()),
                        ).then((val) => _refreshVariedadList());
                      },
                    ),
                  ],
                )
              ]),
        ));
  }

  _openPopup(context) {
    Alert(
        context: context,
        title: "Agregar parcela",
        content: Column(
          children: <Widget>[_form()],
        ),
        buttons: [
          DialogButton(
            onPressed: () => _onSubmit(),
            child: Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _refreshVariedadList() async {
    List<Variedad> x = await _dbHelper.fetchVariedad();
    setState(() {
      _variedades = x;
    });
  }

  _refreshFincaList() async {
    List<Finca> x = await _dbHelper.fetchFincas();
    setState(() {
      _fincas = x;
    });
  }

  _refreshParcelaList() async {
    List x = await _dbHelper.fetchParcela();
    setState(() {
      _parcelas = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_parcela.id == null)
        await _dbHelper.insertParcela(_parcela);
      else
        await _dbHelper.updateParcela(_parcela);
      _refreshParcelaList();
      _resetForm();
      Navigator.of(context).pop();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctlNombre.clear();
      _ctlArea.clear();
      _ctlPlantas.clear();
      selectedFinca = null;
      selectedVariedad = null;
    });
  }

  Future<double> _validateTotalAreaParcela(int id) async {
    List x = await _dbHelper.fetchParcelaFromFinca(id);
    double result;
    if (x.first['total'] != null) {
      result = x.first['total'];
    } else {
      result = 0;
    }

    return result;
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<int>(
                validator: (value) => value == null ? 'required' : null,
                value: selectedFinca,
                hint: Text('Finca'),
                items: _fincas
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre +
                              ' (' +
                              label.area.toString() +
                              ' ' +
                              label.unidad +
                              ')'),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) async {
                  List<Finca> area = await _dbHelper.getFinca(value);
                  print(selectedFinca);
                  setState(() {
                    selectedFinca = value;
                    _areaFinca = area;
                  });
                },
                onSaved: (value) => setState(() => _parcela.idFinca = value),
              ),
              TextFormField(
                controller: _ctlNombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (val) => setState(() => _parcela.nombre = val),
                validator: (val) => (val.length == 0 ? 'required' : null),
              ),
              TextFormField(
                controller: _ctlArea,
                decoration: InputDecoration(labelText: 'Area'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) async {
                  double asd = await _validateTotalAreaParcela(selectedFinca);
                  setState(() {
                    validateParcela = asd;
                  });
                },
                validator: (val) => (_areaFinca.first.area <=
                        (validateParcela + double.parse(val))
                    ? 'Suma areas parcelas mayor a total finca'
                    : null),
                onSaved: (val) =>
                    setState(() => _parcela.area = double.parse(val)),
              ),
              DropdownButtonFormField<int>(
                validator: (value) => value == null ? 'required' : null,
                value: selectedVariedad,
                hint: Text('Variedad'),
                items: _variedades
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedVariedad = value);
                },
                onSaved: (value) => setState(() => _parcela.idVariedad = value),
              ),
              TextFormField(
                controller: _ctlPlantas,
                decoration: InputDecoration(labelText: 'Plantas'),
                keyboardType: TextInputType.numberWithOptions(),
                validator: (val) => (val.length == 0 ? 'required' : null),
                onSaved: (val) =>
                    setState(() => _parcela.plantas = int.parse(val)),
              ),
            ],
          ),
        ),
      );

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_parcelas[index]['nombre'].toString()),
                      subtitle: Text('Finca: ' +
                          _parcelas[index]['finca'].toString() +
                          '\nArea ' +
                          _parcelas[index]['area'].toString()),
                      isThreeLine: true,
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),
                          onPressed: () async {
                            await _dbHelper
                                .deleteParcela(_parcelas[index]['id']);
                            _resetForm();
                            _refreshParcelaList();
                          }),
                      onTap: () async {
                        List<Parcela> x = await _dbHelper
                            .getParcelaId(_parcelas[index]['id']);
                        List<Finca> area = await _dbHelper
                            .getFinca(_parcelas[index]['idFinca']);
                        double asd = await _validateTotalAreaParcela(
                            _parcelas[index]['id']);
                        setState(() {
                          _parcela = x.first;
                          _ctlNombre.text = _parcelas[index]['nombre'];
                          _ctlArea.text = _parcelas[index]['area'].toString();
                          _ctlPlantas.text =
                              _parcelas[index]['plantas'].toString();
                          selectedVariedad = _parcelas[index]['idVariedad'];
                          selectedFinca = _parcelas[index]['idFinca'];
                          _areaFinca = area;
                          validateParcela = asd;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _parcelas.length,
            )),
      );
}

class ListVariedadesPage extends StatefulWidget {
  const ListVariedadesPage({Key key}) : super(key: key);

  @override
  _ListVariedadesPageState createState() => _ListVariedadesPageState();
}

class _ListVariedadesPageState extends State<ListVariedadesPage> {
  Variedad _variedad = Variedad();
  final _formKey = GlobalKey<FormState>();
  final _ctlNombre = TextEditingController();

  List<Variedad> _variedades = [];
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshVariedadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Variedades"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_form(), _list()]),
        ));
  }

  _refreshVariedadList() async {
    List<Variedad> x = await _dbHelper.fetchVariedad();
    setState(() {
      _variedades = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_variedad.id == null)
        await _dbHelper.insertVariedad(_variedad);
      else
        await _dbHelper.updateVariedad(_variedad);
      _refreshVariedadList();
      _resetForm();
    }
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ctlNombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (val) => setState(() => _variedad.nombre = val),
                validator: (val) => (val.length == 0 ? 'required' : null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Guardar'),
                ),
              )
            ],
          ),
        ),
      );

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctlNombre.clear();
      _variedad.id = null;
    });
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_variedades[index].nombre.toUpperCase()),
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),
                          onPressed: () async {
                            await _dbHelper
                                .deleteVariedad(_variedades[index].id);
                            _resetForm();
                            _refreshVariedadList();
                          }),
                      onTap: () {
                        setState(() {
                          _variedad = _variedades[index];
                          _ctlNombre.text = _variedades[index].nombre;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _variedades.length,
            )),
      );
}
