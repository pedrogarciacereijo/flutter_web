class Usuario {

  String nombre;
  String apellidos;
  String email;

  Usuario(this.nombre, this.apellidos, this.email);

  factory Usuario.fromJson(Map<String, dynamic> json) => _usuarioFromJson(json);

  Map<String, dynamic> toJson() => _usuarioToJson(this);

  @override
  String toString() => 'Usuario:$nombre Apellidos:$apellidos Correo:$email';
}

  Usuario _usuarioFromJson(Map<String, dynamic> json) {
    return Usuario(json['nombre'] as String, json['apellidos'] as String,
        json['email'] as String);
  }

  Map<String, dynamic> _usuarioToJson(Usuario instance) => <String, dynamic>{
    'nombre': instance.nombre,
    'apellidos': instance.apellidos,
    'email': instance.email,
  };

  Usuario convertAlumno(dynamic alumno) {
    return Usuario.fromJson(alumno as Map<String, dynamic>);
  }