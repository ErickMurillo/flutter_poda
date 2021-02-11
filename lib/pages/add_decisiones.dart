import 'package:flutter/material.dart';
import 'package:flutter_poda/models/finca.dart';
import 'package:flutter_poda/models/parcelas.dart';
import 'package:flutter_poda/models/test_parcela.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AddDecisionesPage extends StatefulWidget {
  const AddDecisionesPage({Key key}) : super(key: key);

  @override
  _AddDecisionesPageState createState() => _AddDecisionesPageState();
}

class _AddDecisionesPageState extends State<AddDecisionesPage> {
  final _formKey = GlobalKey<FormState>();
  final _ctlFecha = TextEditingController();
  int selectedParcela;
  int selectedFinca;
  TestParcela _test = TestParcela();
  List<Finca> _fincas = [];
  List<Parcela> _parcelas = [];
  DatabaseHelper _dbHelper;

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
          title: Text("Tomar datos y decisiones"),
        ),
        body: Swiper(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_form()]),
            );
          },
        ));
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
                  setState(() {
                    selectedFinca = value;
                  });
                },
                onSaved: (value) => setState(() => _test.idFinca = value),
              ),
              DropdownButtonFormField<int>(
                validator: (value) => value == null ? 'required' : null,
                value: selectedParcela,
                hint: Text('Variedad'),
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
              TextFormField(
                controller: _ctlFecha,
                decoration: InputDecoration(labelText: 'Fecha'),
                onSaved: (val) => setState(() => _test.fecha = val),
                validator: (val) => (val.length == 0 ? 'required' : null),
              ),
            ],
          ),
        ),
      );
}
