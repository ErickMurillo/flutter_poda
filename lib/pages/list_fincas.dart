import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class ListFincasPage extends StatefulWidget {
  const ListFincasPage({Key key}) : super(key: key);

  @override
  _ListFincasPageState createState() => _ListFincasPageState();
}

class _ListFincasPageState extends State<ListFincasPage> {
  List<Finca> _fincas = [];

  DatabaseHelper _dbHelper;
  Finca _finca = Finca();
  String selected;
  final _formKey = GlobalKey<FormState>();
  final _ctlNombre = TextEditingController();
  final _ctlArea = TextEditingController();
  final _ctlProd = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshFincasList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis fincas"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _form(), _list(),
                // IconButton(
                //   icon: Icon(Icons.add),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => AddFincaPage()),
                //     );
                //   },
                // ),
              ]),
        ));
  }

  _refreshFincasList() async {
    List<Finca> x = await _dbHelper.fetchFincas();
    setState(() {
      _fincas = x;
    });
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
                onSaved: (val) => setState(() => _finca.nombre = val),
                validator: (val) => (val.length == 0 ? 'required' : null),
              ),
              TextFormField(
                controller: _ctlArea,
                decoration: InputDecoration(labelText: 'Area'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (val) =>
                    setState(() => _finca.area = double.parse(val)),
              ),
              DropdownButtonFormField<String>(
                value: selected,
                hint: Text('Unidad'),
                items: ["ha", "mz"]
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selected = value);
                },
                onSaved: (value) => setState(() => _finca.unidad = value),
              ),
              TextFormField(
                controller: _ctlProd,
                decoration: InputDecoration(labelText: 'Productor'),
                onSaved: (val) => setState(() => _finca.productor = val),
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

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_finca.id == null)
        await _dbHelper.insertFinca(_finca);
      else
        await _dbHelper.updateFinca(_finca);
      _refreshFincasList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctlNombre.clear();
      _ctlArea.clear();
      _ctlProd.clear();
      _finca.id = null;
      selected = null;
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
                      title: Text(_fincas[index].nombre.toUpperCase()),
                      subtitle: Text(_fincas[index].area.toString()),
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),
                          onPressed: () async {
                            await _dbHelper.deleteFinca(_fincas[index].id);
                            _resetForm();
                            _refreshFincasList();
                          }),
                      onTap: () {
                        setState(() {
                          _finca = _fincas[index];
                          _ctlNombre.text = _fincas[index].nombre;
                          _ctlArea.text = _fincas[index].area.toString();
                          _ctlProd.text = _fincas[index].productor;
                          selected = _fincas[index].unidad;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _fincas.length,
            )),
      );
}
