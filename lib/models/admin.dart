
class Admin {

  String nombre;
  String apellidos;
  String email;
  List<String> alumnos;

  Admin({required this.nombre, required this. apellidos, required this.email, required this.alumnos});

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
        alumnos: json['alumnos'] as List<String>);
  }

  Map<String, dynamic> _adminToJson(Admin instance) => <String, dynamic>{
    'nombre': instance.nombre,
    'apellidos': instance.apellidos,
    'email': instance.email,
    'alumnos': instance.alumnos
  };

  Admin convertAdmin(dynamic admin) {
    return Admin.fromJson(admin as Map<String, dynamic>);
  }


  
