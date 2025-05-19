import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'cliente.dart';
import 'item.dart';

part 'cotizacion.g.dart';

@HiveType(typeId: 3)
class Cotizacion extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String numeroCotizacion;

  @HiveField(2)
  String idCliente; // Referencia al ID del cliente

  @HiveField(3)
  DateTime fechaEmision;

  @HiveField(4)
  DateTime? fechaValidez;

  @HiveField(5)
  String? tituloAsunto;

  @HiveField(6)
  String estado; // "Creada", "Enviada", "Aceptada", "En Ejecucion", "Entregada"

  @HiveField(7)
  List<Item> items;

  @HiveField(8)
  double subtotalNeto;

  @HiveField(9)
  double descuentoGeneralPorcentaje;

  @HiveField(10)
  double montoDescuentoGeneral;

  @HiveField(11)
  double montoNetoFinal;

  @HiveField(12)
  double montoIva;

  @HiveField(13)
  double montoTotalCotizacion;

  @HiveField(14)
  String? formaPagoDescripcion;

  @HiveField(15)
  String? tiempoEntregaEstimado;

  @HiveField(16)
  String? validezOfertaDescripcion;

  @HiveField(17)
  String? notasAdicionales;

  @HiveField(18)
  DateTime fechaCreacionRegistro;

  @HiveField(19)
  DateTime fechaUltimaModificacion;

  Cotizacion({
    String? id,
    required this.numeroCotizacion,
    required this.idCliente,
    required this.fechaEmision,
    this.fechaValidez,
    this.tituloAsunto,
    this.estado = 'Creada',
    required this.items,
    this.subtotalNeto = 0.0,
    this.descuentoGeneralPorcentaje = 0.0,
    this.montoDescuentoGeneral = 0.0,
    this.montoNetoFinal = 0.0,
    this.montoIva = 0.0,
    this.montoTotalCotizacion = 0.0,
    this.formaPagoDescripcion,
    this.tiempoEntregaEstimado,
    this.validezOfertaDescripcion,
    this.notasAdicionales,
    DateTime? fechaCreacionRegistro,
    DateTime? fechaUltimaModificacion,
  }) : 
    this.id = id ?? const Uuid().v4(),
    this.fechaCreacionRegistro = fechaCreacionRegistro ?? DateTime.now(),
    this.fechaUltimaModificacion = fechaUltimaModificacion ?? DateTime.now();

  // Método para calcular todos los totales
  void calcularTotales(double ivaPorcentaje) {
    // Calcular subtotal sumando el valor total de cada ítem
    subtotalNeto = 0.0;
    for (var item in items) {
      subtotalNeto += item.valorTotalItem;
    }

    // Calcular descuento general
    montoDescuentoGeneral = subtotalNeto * (descuentoGeneralPorcentaje / 100);

    // Calcular monto neto final
    montoNetoFinal = subtotalNeto - montoDescuentoGeneral;

    // Calcular IVA
    montoIva = montoNetoFinal * (ivaPorcentaje / 100);

    // Calcular total
    montoTotalCotizacion = montoNetoFinal + montoIva;

    // Actualizar fecha de modificación
    fechaUltimaModificacion = DateTime.now();
  }

  // Método para crear una copia con cambios
  Cotizacion copyWith({
    String? numeroCotizacion,
    String? idCliente,
    DateTime? fechaEmision,
    DateTime? fechaValidez,
    String? tituloAsunto,
    String? estado,
    List<Item>? items,
    double? subtotalNeto,
    double? descuentoGeneralPorcentaje,
    double? montoDescuentoGeneral,
    double? montoNetoFinal,
    double? montoIva,
    double? montoTotalCotizacion,
    String? formaPagoDescripcion,
    String? tiempoEntregaEstimado,
    String? validezOfertaDescripcion,
    String? notasAdicionales,
  }) {
    return Cotizacion(
      id: this.id,
      numeroCotizacion: numeroCotizacion ?? this.numeroCotizacion,
      idCliente: idCliente ?? this.idCliente,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      fechaValidez: fechaValidez ?? this.fechaValidez,
      tituloAsunto: tituloAsunto ?? this.tituloAsunto,
      estado: estado ?? this.estado,
      items: items ?? List.from(this.items),
      subtotalNeto: subtotalNeto ?? this.subtotalNeto,
      descuentoGeneralPorcentaje: descuentoGeneralPorcentaje ?? this.descuentoGeneralPorcentaje,
      montoDescuentoGeneral: montoDescuentoGeneral ?? this.montoDescuentoGeneral,
      montoNetoFinal: montoNetoFinal ?? this.montoNetoFinal,
      montoIva: montoIva ?? this.montoIva,
      montoTotalCotizacion: montoTotalCotizacion ?? this.montoTotalCotizacion,
      formaPagoDescripcion: formaPagoDescripcion ?? this.formaPagoDescripcion,
      tiempoEntregaEstimado: tiempoEntregaEstimado ?? this.tiempoEntregaEstimado,
      validezOfertaDescripcion: validezOfertaDescripcion ?? this.validezOfertaDescripcion,
      notasAdicionales: notasAdicionales ?? this.notasAdicionales,
      fechaCreacionRegistro: this.fechaCreacionRegistro,
      fechaUltimaModificacion: DateTime.now(),
    );
  }

  // Método para convertir a Map (útil para exportar/importar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroCotizacion': numeroCotizacion,
      'idCliente': idCliente,
      'fechaEmision': fechaEmision.toIso8601String(),
      'fechaValidez': fechaValidez?.toIso8601String(),
      'tituloAsunto': tituloAsunto,
      'estado': estado,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotalNeto': subtotalNeto,
      'descuentoGeneralPorcentaje': descuentoGeneralPorcentaje,
      'montoDescuentoGeneral': montoDescuentoGeneral,
      'montoNetoFinal': montoNetoFinal,
      'montoIva': montoIva,
      'montoTotalCotizacion': montoTotalCotizacion,
      'formaPagoDescripcion': formaPagoDescripcion,
      'tiempoEntregaEstimado': tiempoEntregaEstimado,
      'validezOfertaDescripcion': validezOfertaDescripcion,
      'notasAdicionales': notasAdicionales,
      'fechaCreacionRegistro': fechaCreacionRegistro.toIso8601String(),
      'fechaUltimaModificacion': fechaUltimaModificacion.toIso8601String(),
    };
  }

  // Método para crear desde Map
  factory Cotizacion.fromMap(Map<String, dynamic> map) {
    return Cotizacion(
      id: map['id'],
      numeroCotizacion: map['numeroCotizacion'],
      idCliente: map['idCliente'],
      fechaEmision: DateTime.parse(map['fechaEmision']),
      fechaValidez: map['fechaValidez'] != null ? DateTime.parse(map['fechaValidez']) : null,
      tituloAsunto: map['tituloAsunto'],
      estado: map['estado'],
      items: (map['items'] as List).map((item) => Item.fromMap(item)).toList(),
      subtotalNeto: map['subtotalNeto'],
      descuentoGeneralPorcentaje: map['descuentoGeneralPorcentaje'],
      montoDescuentoGeneral: map['montoDescuentoGeneral'],
      montoNetoFinal: map['montoNetoFinal'],
      montoIva: map['montoIva'],
      montoTotalCotizacion: map['montoTotalCotizacion'],
      formaPagoDescripcion: map['formaPagoDescripcion'],
      tiempoEntregaEstimado: map['tiempoEntregaEstimado'],
      validezOfertaDescripcion: map['validezOfertaDescripcion'],
      notasAdicionales: map['notasAdicionales'],
      fechaCreacionRegistro: DateTime.parse(map['fechaCreacionRegistro']),
      fechaUltimaModificacion: DateTime.parse(map['fechaUltimaModificacion']),
    );
  }

  @override
  String toString() {
    return 'Cotizacion(id: $id, numeroCotizacion: $numeroCotizacion, estado: $estado, montoTotal: $montoTotalCotizacion)';
  }
}
