import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/test_parcela.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

import 'decisiones.dart';

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
        title: Text("Tomar datos y decisiones"),
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
                    _parcelas = result;
                    selectedFinca = value;
                  });
                },
                onSaved: (value) => setState(() => _test.idFinca = value),
              ),
              DropdownButtonFormField<int>(
                validator: (value) => value == null ? 'required' : null,
                value: selectedParcela,
                hint: Text('Parcela'),
                items: _parcelas
                    .map((label) => DropdownMenuItem(
                          child: Text(label.nombre),
                          value: label.id,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedParcela = value);
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
