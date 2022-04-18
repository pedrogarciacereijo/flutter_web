import 'package:cloud_firestore/cloud_firestore.dart';

class Ejercicio {
  final String idEjercicio;
  final String idUsuario;
  final DateTime dateInicio;
  final DateTime dateFin;
  final String tipoEjercicio;
  final String? dificultad;
  final int errores;
  final int aciertos;
  final int? letrasCorrectas;

  Ejercicio(this.idUsuario, {required this.idEjercicio, required this.dateInicio, required this.dateFin, required this.tipoEjercicio, this.dificultad, required this.errores, required this.aciertos, this.letrasCorrectas});

  factory Ejercicio.fromJson(Map<String, Ejercicio> json) =>
      _ejercicioFromJson(json);

  Map<String, dynamic> toJson() => _ejercicioToJson(this);

  @override
  String toString() => 'Ejercicio:<$idEjercicio> Usuario:<$idUsuario>';
}

Ejercicio _ejercicioFromJson(Map<String, dynamic> json) {
  return Ejercicio(
    json['idUsuario'] as String,
    idEjercicio: json['idEjercicio'] as String,
    dateInicio: (json['dateInicio'] as Timestamp).toDate(),
    dateFin: (json['dateFin'] as Timestamp).toDate(),
    tipoEjercicio: json['tipoEjercicio'] as String,
    dificultad: json['dificultad'] as String,
    errores: json['errores'] as int,
    aciertos: json['aciertos'] as int,
    letrasCorrectas: json['letrasCorrectas'] as int,
  );
}

Map<String, dynamic> _ejercicioToJson(Ejercicio instance) =>
    <String, dynamic>{
      'idUsuario': instance.idUsuario,
      'idEjercicio': instance.idEjercicio,
      'dateInicio': instance.dateInicio,
      'dateFin': instance.dateFin,
      'tipoEjercicio': instance.tipoEjercicio,
      'dificultad': instance.dificultad,
      'errores': instance.errores,
      'aciertos': instance.aciertos,
      'letrasCorrectas': instance.letrasCorrectas
    };