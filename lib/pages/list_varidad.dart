import 'package:flutter/material.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_poda/models/variedad.dart';

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
    print(_variedades);
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
