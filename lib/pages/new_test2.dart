import 'package:flutter/material.dart';
import 'package:flutter_poda/providers/db_provider.dart';

class NewTest2Page extends StatefulWidget {
  final int testid;
  const NewTest2Page({Key key, this.testid}) : super(key: key);

  @override
  _NewTest2PageState createState() => _NewTest2PageState();
}

class _NewTest2PageState extends State<NewTest2Page> {
  DatabaseHelper _dbHelper;
  List result;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      _getAltura();
    });
  }

  _getAltura() async {
    List x = await _dbHelper.getAlturas(widget.testid);
    setState(() {
      result = x;
      print(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos consolidados'),
        centerTitle: true,
        actions: <Widget>[],
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
                            rows: const <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('Mohit')),
                                  DataCell(Text('23')),
                                  DataCell(Text('12 ')),
                                  DataCell(Text('2')),
                                  DataCell(Text('1')),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('Ramas cercanas al suelo %')),
                                  DataCell(Text('2')),
                                  DataCell(Text('1')),
                                  DataCell(Text('2')),
                                  DataCell(Text('25')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        child: ListTile(
                            title: Text('Motivation $index'),
                            subtitle: Text(
                                'this is a description of the motivation')),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
