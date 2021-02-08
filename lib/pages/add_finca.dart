import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/pages/list_fincas.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class AddFincaPage extends StatefulWidget {
  const AddFincaPage({Key key}) : super(key: key);

  @override
  _AddFincaPageState createState() => _AddFincaPageState();
}

class _AddFincaPageState extends State<AddFincaPage> {
  Finca _finca = Finca();
  DatabaseHelper _dbHelper;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agregar finca"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_form()]),
        ));
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
                  child: Text('Agregar'),
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
      form.reset();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListFincasPage()),
      );
    }
  }
}
