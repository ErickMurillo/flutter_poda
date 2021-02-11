class TestParcela {
  TestParcela({this.id, this.idFinca, this.idParcela, this.fecha});

  TestParcela.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idFinca = map['idFinca'];
    idParcela = map['idParcela'];
    fecha = map['nombre'];
  }

  int id;
  int idFinca;
  int idParcela;
  String fecha;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idFinca': idFinca,
      'idParcela': idParcela,
      'fecha': fecha
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
