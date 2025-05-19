import 'package:hive/hive.dart';

part 'empresa.g.dart';

@HiveType(typeId: 0)
class Empresa extends HiveObject {
  @HiveField(0)
  String nombreEmpresa;

  @HiveField(1)
  String rutEmpresa;

  @HiveField(2)
  String? giroEmpresa;

  @HiveField(3)
  String? direccionEmpresa;

  @HiveField(4)
  String? emailEmpresa;

  @HiveField(5)
  String? telefonoEmpresa;

  @HiveField(6)
  String? logoPath;

  @HiveField(7)
  double ivaPorcentaje;

  Empresa({
    required this.nombreEmpresa,
    required this.rutEmpresa,
    this.giroEmpresa,
    this.direccionEmpresa,
    this.emailEmpresa,
    this.telefonoEmpresa,
    this.logoPath,
    this.ivaPorcentaje = 19.0,
  });

  // Método para crear una copia con cambios
  Empresa copyWith({
    String? nombreEmpresa,
    String? rutEmpresa,
    String? giroEmpresa,
    String? direccionEmpresa,
    String? emailEmpresa,
    String? telefonoEmpresa,
    String? logoPath,
    double? ivaPorcentaje,
  }) {
    return Empresa(
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      rutEmpresa: rutEmpresa ?? this.rutEmpresa,
      giroEmpresa: giroEmpresa ?? this.giroEmpresa,
      direccionEmpresa: direccionEmpresa ?? this.direccionEmpresa,
      emailEmpresa: emailEmpresa ?? this.emailEmpresa,
      telefonoEmpresa: telefonoEmpresa ?? this.telefonoEmpresa,
      logoPath: logoPath ?? this.logoPath,
      ivaPorcentaje: ivaPorcentaje ?? this.ivaPorcentaje,
    );
  }

  // Método para convertir a Map (útil para exportar/importar)
  Map<String, dynamic> toMap() {
    return {
      'nombreEmpresa': nombreEmpresa,
      'rutEmpresa': rutEmpresa,
      'giroEmpresa': giroEmpresa,
      'direccionEmpresa': direccionEmpresa,
      'emailEmpresa': emailEmpresa,
      'telefonoEmpresa': telefonoEmpresa,
      'logoPath': logoPath,
      'ivaPorcentaje': ivaPorcentaje,
    };
  }

  // Método para crear desde Map
  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      nombreEmpresa: map['nombreEmpresa'],
      rutEmpresa: map['rutEmpresa'],
      giroEmpresa: map['giroEmpresa'],
      direccionEmpresa: map['direccionEmpresa'],
      emailEmpresa: map['emailEmpresa'],
      telefonoEmpresa: map['telefonoEmpresa'],
      logoPath: map['logoPath'],
      ivaPorcentaje: map['ivaPorcentaje'],
    );
  }

  // Método para crear una empresa por defecto
  factory Empresa.defaultEmpresa() {
    return Empresa(
      nombreEmpresa: 'Mi Empresa',
      rutEmpresa: '76.000.000-K',
      giroEmpresa: 'Servicios Generales',
      ivaPorcentaje: 19.0,
    );
  }

  @override
  String toString() {
    return 'Empresa(nombreEmpresa: $nombreEmpresa, rutEmpresa: $rutEmpresa)';
  }
}
