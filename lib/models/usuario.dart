class Usuario {

  String nombre;
  String? email;
  String? referenceId;

  Usuario(this.nombre,
      {this.email, this.referenceId});

  factory Usuario.fromJson(Map<String, dynamic> json) => _usuarioFromJson(json);

  Map<String, dynamic> toJson() => _usuarioToJson(this);

  @override
  String toString() => 'Usuario<$nombre>';
}

  Usuario _usuarioFromJson(Map<String, dynamic> json) {
    return Usuario(json['nombre'] as String,
        email: json['email'] as String,
        referenceId: json['referenceId'] as String);
  }

  Map<String, dynamic> _usuarioToJson(Usuario instance) => <String, dynamic>{
    'nombre': instance.nombre,
    'email': instance.email,
    'referenceId': instance.referenceId,
  };