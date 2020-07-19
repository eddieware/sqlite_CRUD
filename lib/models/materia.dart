import 'package:consumir_web_api/models/base.dart';

class Materia extends Model {
  static String table = 'materiadb';

  int id;
  String nombre;
  String profesor;
  String cuatrimestre;
  String horario;
  bool complete;

  Materia({
    this.id,
    this.nombre,
    this.profesor,
    this.cuatrimestre,
    this.horario,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nombre": nombre,
      "profesor": profesor,
      "cuatrimestre": cuatrimestre,
      "horario": horario,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Materia fromMap(Map<String, dynamic> map) {
    return Materia(
      id: map['id'],
      nombre: map['nombre'],
      profesor: map['profesor'],
      cuatrimestre: map['cuatrimestre'],
      horario: map['horario'],
    );
  }
}
