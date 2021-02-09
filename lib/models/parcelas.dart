class Parcela {
  Parcela(
      {this.id,
      this.idFinca,
      this.nombre,
      this.area,
      this.idVariedad,
      this.plantas});

  Parcela.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idFinca = map['idFinca'];
    nombre = map['nombre'];
    area = map['area'].toDouble();
    idVariedad = map['idVariedad'];
    plantas = map['plantas'];
  }

  int id;
  int idFinca;
  String nombre;
  double area;
  int idVariedad;
  int plantas;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idFinca': idFinca,
      'nombre': nombre,
      'area': area,
      'idVariedad': idVariedad,
      'plantas': plantas
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
