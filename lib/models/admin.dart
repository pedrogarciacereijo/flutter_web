import 'package:flutter_web/models/usuario.dart';

class Admin {

  String nombre;
  String apellidos;
  String email;
  List<Usuario> alumnos;
  String referenceId;

  Admin({required this.nombre, required this. apellidos, required this.email, required this.alumnos, required this.referenceId});

  factory Admin.fromJson(Map<String, dynamic> json) => _adminFromJson(json);

  Map<String, dynamic> toJson() => _adminToJson(this);

  @override
  String toString() => 'Admin<$nombre>';
}

  Admin _adminFromJson(Map<String, dynamic> json) {
    return Admin(
        nombre: json['nombre'] as String,
        apellidos: json['apellidos'] as String,
        email: json['email'] as String,
        alumnos: convertAlumnos(json['alumnos'] as List<dynamic>),
        referenceId: json['referenceId'] as String, );
  }

  Map<String, dynamic> _adminToJson(Admin instance) => <String, dynamic>{
    'nombre': instance.nombre,
    'apellidos': instance.apellidos,
    'email': instance.email,
    'alumnos': alumnoList(instance.alumnos),
    'referenceId': instance.referenceId
  };

  List<Usuario> convertAlumnos(List<dynamic> alumnoMap) {
    final alumnos = <Usuario>[];

    for (final alumno in alumnoMap) {
      alumnos.add(Usuario.fromJson(alumno as Map<String, dynamic>));
    }
    return alumnos;
  }

  List<Map<String, dynamic>>? alumnoList(List<Usuario> alumnos) {
    
    final alumnoMap = <Map<String, dynamic>>[];
    for (var alumno in alumnos) {
      alumnoMap.add(alumno.toJson());
    }
    return alumnoMap;
  }
