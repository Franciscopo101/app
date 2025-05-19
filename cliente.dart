import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'cliente.g.dart';

@HiveType(typeId: 1)
class Cliente extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nombreRazonSocial;

  @HiveField(2)
  String rutCliente;

  @HiveField(3)
  String? giroCliente;

  @HiveField(4)
  String? direccion;

  @HiveField(5)
  String? comuna;

  @HiveField(6)
  String? ciudad;

  @HiveField(7)
  String? email;

  @HiveField(8)
  String? telefono;

  @HiveField(9)
  String? nombreContacto;

  @HiveField(10)
  DateTime fechaRegistro;

  Cliente({
    String? id,
    required this.nombreRazonSocial,
    required this.rutCliente,
    this.giroCliente,
    this.direccion,
    this.comuna,
    this.ciudad,
    this.email,
    this.telefono,
    this.nombreContacto,
    DateTime? fechaRegistro,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.fechaRegistro = fechaRegistro ?? DateTime.now();

  // Método para crear una copia con cambios
  Cliente copyWith({
    String? nombreRazonSocial,
    String? rutCliente,
    String? giroCliente,
    String? direccion,
    String? comuna,
    String? ciudad,
    String? email,
    String? telefono,
    String? nombreContacto,
  }) {
    return Cliente(
      id: this.id,
      nombreRazonSocial: nombreRazonSocial ?? this.nombreRazonSocial,
      rutCliente: rutCliente ?? this.rutCliente,
      giroCliente: giroCliente ?? this.giroCliente,
      direccion: direccion ?? this.direccion,
      comuna: comuna ?? this.comuna,
      ciudad: ciudad ?? this.ciudad,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      nombreContacto: nombreContacto ?? this.nombreContacto,
      fechaRegistro: this.fechaRegistro,
    );
  }

  // Método para convertir a Map (útil para exportar/importar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreRazonSocial': nombreRazonSocial,
      'rutCliente': rutCliente,
      'giroCliente': giroCliente,
      'direccion': direccion,
      'comuna': comuna,
      'ciudad': ciudad,
      'email': email,
      'telefono': telefono,
      'nombreContacto': nombreContacto,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  // Método para crear desde Map
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombreRazonSocial: map['nombreRazonSocial'],
      rutCliente: map['rutCliente'],
      giroCliente: map['giroCliente'],
      direccion: map['direccion'],
      comuna: map['comuna'],
      ciudad: map['ciudad'],
      email: map['email'],
      telefono: map['telefono'],
      nombreContacto: map['nombreContacto'],
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }

  @override
  String toString() {
    return 'Cliente(id: $id, nombreRazonSocial: $nombreRazonSocial, rutCliente: $rutCliente)';
  }
}
