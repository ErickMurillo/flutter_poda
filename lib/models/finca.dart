class Finca {
  Finca({this.id, this.nombre, this.area, this.unidad, this.productor});

  Finca.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    area = map['area'].toDouble();
    unidad = map['unidad'];
    productor = map['productor'];
  }

  int id;
  String nombre;
  double area;
  String unidad;
  String productor;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': nombre,
      'area': area,
      'unidad': unidad,
      'productor': productor
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
