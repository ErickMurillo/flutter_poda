class Variedad {
  Variedad({this.id, this.nombre});

  Variedad.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
  }

  int id;
  String nombre;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nombre': nombre,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
