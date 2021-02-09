import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/pages/list_varidad.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/variedad.dart';

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
  List<Parcela> _parcelas = [];
  DatabaseHelper _dbHelper;
//   var totalArea;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshVariedadList();
    _refreshFincaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis Parcelas"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _form(),
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
                _list(),
              ]),
        ));
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
    List<Parcela> x = await _dbHelper.fetchParcela();
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

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<int>(
                value: selectedFinca,
                hint: Text('Finca'),
                items: _fincas
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre + ' - ' + label.unidad),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFinca = value;
                    // totalArea = _dbHelper.getFinca(value);
                  });
                },
                // validator: (value) => (value <= totalArea
                //     ? 'valor es mayor a area total finca'
                //     : null),
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
                validator: (val) => (val.length == 0 ? 'required' : null),
                onSaved: (val) =>
                    setState(() => _parcela.area = double.parse(val)),
              ),
              DropdownButtonFormField<int>(
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
                onSaved: (val) =>
                    setState(() => _parcela.plantas = int.parse(val)),
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

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_parcelas[index].nombre.toUpperCase()),
                      subtitle: Text(_parcelas[index].area.toString()),
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),
                          onPressed: () async {
                            await _dbHelper.deleteParcela(_parcelas[index].id);
                            _resetForm();
                            _refreshParcelaList();
                          }),
                      onTap: () {
                        setState(() {
                          _parcela = _parcelas[index];
                          _ctlNombre.text = _parcelas[index].nombre;
                          _ctlArea.text = _parcelas[index].area.toString();
                          _ctlPlantas.text =
                              _parcelas[index].plantas.toString();
                          selectedVariedad = _parcelas[index].idVariedad;
                          selectedFinca = _parcelas[index].idFinca;
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
