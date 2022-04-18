import 'package:flutter_web/models/usuario.dart';

class Admin {

  String nombre;
  String email;
  List<Usuario> alumnos;

  Admin({required this.nombre,required this.email, required this.alumnos});

  factory Admin.fromJson(Map<String, dynamic> json) => _adminFromJson(json);

  Map<String, dynamic> toJson() => _adminToJson(this);

  @override
  String toString() => 'Admin<$nombre>';
}

  Admin _adminFromJson(Map<String, dynamic> json) {
    return Admin(
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        alumnos: convertAlumnos(json['alumnos'] as List<dynamic>));
  }

  Map<String, dynamic> _adminToJson(Admin instance) => <String, dynamic>{
    'nombre': instance.nombre,
    'email': instance.email,
    'alumnos': alumnoList(instance.alumnos),
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
    alumnos.forEach((alumno) {
      alumnoMap.add(alumno.toJson());
    });
    return alumnoMap;
  }

  /* List<String>? alumnoListToString(List<Usuario> alumnos){
    if (alumnos == null) {
      return null;
    }
    final nombres = <String>[];
    for (final alumno in alumnos) {
      nombres.add(alumno.toJson()['nombre']);
    }
  }*/