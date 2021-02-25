import 'package:flutter/material.dart';
import 'package:flutter_poda/models/test_parcela.dart';
import 'package:flutter_poda/pages/estaciones.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DecisionesPage extends StatefulWidget {
  const DecisionesPage({Key key}) : super(key: key);

  @override
  _DecisionesPageState createState() => _DecisionesPageState();
}

class _DecisionesPageState extends State<DecisionesPage> {
  List _tests = [];
  DatabaseHelper _dbHelper;
  List<TestParcela> _test;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshTestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tomar datos y decisiones"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddDecisionesPage()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _list(),
              ]),
        ));
  }

  _refreshTestList() async {
    List x = await _dbHelper.fetchTestParcela();
    setState(() {
      _tests = x;
    });
  }

  _deleteTest(int id, context) {
    Alert(
        context: context,
        title: "Eliminar",
        desc: "¿Esta seguro de querer eliminar el test?",
        buttons: [
          DialogButton(
            onPressed: () async => {
              await _dbHelper.deleteTestParcela(id),
              _refreshTestList(),
              Navigator.pop(context),
            },
            child: Text(
              "Si",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _list() => Expanded(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(_tests[index]['finca'].toString()),
                      subtitle: Text(_tests[index]['parcela'].toString() +
                          '\n fecha: ' +
                          _tests[index]['fecha']),
                      isThreeLine: true,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddDecisionesPage(
                                  testid: _tests[index]['id'])),
                        );
                      },
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          //   IconButton(icon: Icon(Icons.edit), onPressed: () {}),

                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                _deleteTest(_tests[index]['id'], context);
                              }),
                          IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EstacionesPage(
                                          testid: _tests[index]['id'])),
                                );
                              })
                        ],
                      ),
                    ),
                    Divider(
                      height: 5.0,
                    )
                  ],
                );
              },
              itemCount: _tests.length,
            )),
      );
}

class AddDecisionesPage extends StatefulWidget {
  final int testid;
  AddDecisionesPage({Key key, this.testid}) : super(key: key);

  @override
  _AddDecisionesPageState createState() => _AddDecisionesPageState();
}

class _AddDecisionesPageState extends State<AddDecisionesPage> {
  final _formKey = GlobalKey<FormState>();
  int selectedParcela;
  int selectedFinca;
  TestParcela _test = TestParcela();
  List<Finca> _fincas = [];
  List<Parcela> _parcelas = [];
  DatabaseHelper _dbHelper;
  final _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _refreshFincaList();
      if (widget.testid != null) {
        _getTest(widget.testid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.testid == null ? "Agregar datos" : "Modificar datos",
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_form()]),
    );
  }

  _refreshFincaList() async {
    List<Finca> x = await _dbHelper.fetchFincas();
    setState(() {
      _fincas = x;
    });
  }

  _getTest(int id) async {
    List<TestParcela> x = await _dbHelper.getTest(id);
    List<Parcela> p = await _dbHelper.getParcelaFromFincaId(x.first.idFinca);
    setState(() {
      _parcelas = p;
      _test = x.first;
      selectedFinca = x.first.idFinca;
      selectedParcela = x.first.idParcela;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date = formatter.format(picked);
        _dateController.text = date;
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
                validator: (value) => value == null ? 'required' : null,
                value: selectedFinca,
                hint: Text('Finca'),
                items: _fincas
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) async {
                  List<Parcela> result =
                      await _dbHelper.getParcelaFromFincaId(value);
                  setState(() {
                    _parcelas.clear();
                    _parcelas = result;
                    selectedParcela = _parcelas.first.id;
                    selectedFinca = value;
                  });
                },
                onSaved: (value) => setState(() => _test.idFinca = value),
              ),
              DropdownButtonFormField<int>(
                // key: _key,
                validator: (value) => value == null ? 'required' : null,
                value: selectedParcela != null ? selectedParcela : null,
                hint: Text('Parcela'),
                items: _parcelas
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedParcela = value);
                  //   _key.currentState.reset();
                },
                onSaved: (value) => setState(() => _test.idParcela = value),
              ),
              GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      onSaved: (val) {
                        _test.fecha = selectedDate.toString();
                      },
                      controller: _dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Fecha",
                        icon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value.isEmpty)
                          return "Seleccionar una fecha valida";
                        return null;
                      },
                    ),
                  )),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _onSubmit(),
                    child: Text('Guardar'),
                  )
                ],
              )
            ],
          ),
        ),
      );

  _onSubmit() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DecisionesPage()),
    );
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_test.id == null)
        await _dbHelper.insertTestParcela(_test);
      else
        await _dbHelper.updateTestParcela(_test);
    }
  }
}
