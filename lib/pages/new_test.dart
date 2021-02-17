import 'package:flutter/material.dart';
import 'package:flutter_poda/providers/db_provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewTestPage extends StatefulWidget {
  final int testid;
  final int estacion;
  const NewTestPage({Key key, this.testid, this.estacion}) : super(key: key);

  @override
  _NewTestPageState createState() => _NewTestPageState();
}

class _NewTestPageState extends State<NewTestPage> {
  DatabaseHelper _dbHelper;
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

  static List<String> _produccionOptions = [
    "Alta",
    "Media",
    "Baja",
  ];

  int _radioValue1 = -1;
  int correctScore = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      for (var i = 0; i <= 9; i++) {
        _estacionesCtls[i].text = widget.estacion.toString();
        _plantasCtls[i].text = (i + 1).toString();
        print(i);
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
        itemBuilder: (BuildContext context, int index) {
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
                          //   onSaved: (val) =>
                          //       setState(() => _finca.area = double.parse(val)),
                        ),
                        TextFormField(
                          enabled: false,
                          controller: _plantasCtls[index],
                          decoration: InputDecoration(labelText: 'Planta'),
                          //   onSaved: (val) =>
                          //       setState(() => _finca.area = double.parse(val)),
                        ),
                        TextFormField(
                          controller: _alturaCtls[index],
                          decoration:
                              InputDecoration(labelText: 'Altura en mt'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (val) =>
                              (val.length == 0 ? 'required' : null),
                          //   onSaved: (val) =>
                          //       setState(() => _finca.area = double.parse(val)),
                        ),
                        TextFormField(
                          controller: _anchoCtls[index],
                          decoration: InputDecoration(labelText: 'Ancho en mt'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (val) =>
                              (val.length == 0 ? 'required' : null),
                          //   onSaved: (val) =>
                          //       setState(() => _finca.area = double.parse(val)),
                        ),
                        TextFormField(
                          controller: _largoCtls[index],
                          decoration: InputDecoration(
                              labelText: 'Largo de madera productiva'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (val) =>
                              (val.length == 0 ? 'required' : null),
                          //   onSaved: (val) =>
                          //       setState(() => _finca.area = double.parse(val)),
                        ),
                        CheckboxListTileFormField(
                          title: Text('Buena arquitectura'),
                          onSaved: (bool value) {
                            if (value) {
                              return "Si";
                            } else {
                              return "No";
                            }
                          },
                        ),
                        CheckboxListTileFormField(
                          title: Text('Ramas en contacto'),
                          onSaved: (bool value) {},
                        ),
                        CheckboxListTileFormField(
                          title: Text('Ramas entrecruzados'),
                          onSaved: (bool value) {},
                        ),
                        CheckboxListTileFormField(
                          title: Text('Ramas cercanas al suelo'),
                          onSaved: (bool value) {},
                        ),
                        CheckboxListTileFormField(
                          title: Text('Chupones'),
                          onSaved: (bool value) {},
                        ),
                        CheckboxListTileFormField(
                          title: Text('Entrada de luz'),
                          onSaved: (bool value) {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Radio(
                              value: 0,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            new Text(
                              'Carnivore',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            new Text(
                              'Herbivore',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            new Radio(
                              value: 2,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                            ),
                            new Text(
                              'Omnivore',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ])))
            ],
          );
        },
        itemCount: 10,
        pagination: new SwiperPagination(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _onSubmit(),
      ),
    );
  }

  _onSubmit() async {
    for (var i = 0; i <= 9; i++) {
      print(_formkeys[i].currentState);
      print('aqui');
    }
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          Fluttertoast.showToast(
              msg: 'Correct !', toastLength: Toast.LENGTH_SHORT);
          correctScore++;
          break;
        case 1:
          Fluttertoast.showToast(
              msg: 'Try again !', toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          Fluttertoast.showToast(
              msg: 'Try again !', toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }
}
