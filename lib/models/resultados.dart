class Resultado {
  Resultado(
      {this.id,
      this.problemasPoda,
      this.tipoPoda,
      this.aplicarPoda,
      this.plantasVigor,
      this.entradaLuz,
      this.mesesPoda,
      this.idTest});

  Resultado.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    problemasPoda = map['problemasPoda'];
    tipoPoda = map['tipoPoda'];
    aplicarPoda = map['aplicarPoda'];
    plantasVigor = map['plantasVigor'];
    entradaLuz = map['entradaLuz'];
    mesesPoda = map['mesesPoda'];
    idTest = map['idTest'];
  }

  int id;
  int idTest;
  String problemasPoda;
  String tipoPoda;
  String aplicarPoda;
  String plantasVigor;
  String entradaLuz;
  String mesesPoda;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'problemasPoda': problemasPoda,
      'tipoPoda': tipoPoda,
      'aplicarPoda': aplicarPoda,
      'plantasVigor': plantasVigor,
      'entradaLuz': entradaLuz,
      'mesesPoda': mesesPoda,
      'idTest': idTest
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
