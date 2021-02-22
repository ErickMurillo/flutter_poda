class Estaciones {
  Estaciones(
      {this.id,
      this.estacion,
      this.planta,
      this.idTest,
      this.altura,
      this.ancho,
      this.largo,
      this.buenaArquitectura,
      this.ramasContacto,
      this.ramasEntrecruzados,
      this.ramasSuelo,
      this.chupones,
      this.entradaLuz,
      this.produccion});

  Estaciones.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    estacion = map['estacion'];
    planta = map['planta'];
    idTest = map['idTest'];
    altura = map['altura'].toDouble();
    ancho = map['ancho'].toDouble();
    largo = map['largo'].toDouble();
    buenaArquitectura = map['buenaArquitectura'];
    ramasContacto = map['ramasContacto'];
    ramasEntrecruzados = map['ramasEntrecruzados'];
    ramasSuelo = map['ramasSuelo'];
    chupones = map['chupones'];
    entradaLuz = map['entradaLuz'];
    produccion = map['produccion'];
  }

  int id;
  int estacion;
  int planta;
  int idTest;
  double altura;
  double ancho;
  double largo;
  int buenaArquitectura;
  int ramasContacto;
  int ramasEntrecruzados;
  int ramasSuelo;
  int chupones;
  int entradaLuz;
  int produccion;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'estacion': estacion,
      'planta': planta,
      'idTest': idTest,
      'altura': altura,
      'ancho': ancho,
      'largo': largo,
      'buenaArquitectura': buenaArquitectura,
      'ramasContacto': ramasContacto,
      'ramasEntrecruzados': ramasEntrecruzados,
      'ramasSuelo': ramasSuelo,
      'chupones': chupones,
      'entradaLuz': entradaLuz,
      'produccion': produccion
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
