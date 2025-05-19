import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item.g.dart';

@HiveType(typeId: 2)
class Item extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String? codigoItem;

  @HiveField(2)
  String descripcionItem;

  @HiveField(3)
  String? unidadMedida;

  @HiveField(4)
  double cantidad;

  @HiveField(5)
  double precioUnitario;

  @HiveField(6)
  double descuentoItemPorcentaje;

  Item({
    String? id,
    this.codigoItem,
    required this.descripcionItem,
    this.unidadMedida,
    required this.cantidad,
    required this.precioUnitario,
    this.descuentoItemPorcentaje = 0.0,
  }) : this.id = id ?? const Uuid().v4();

  // Método para calcular el valor total del ítem
  double get valorTotalItem {
    return cantidad * precioUnitario * (1 - descuentoItemPorcentaje / 100);
  }

  // Método para crear una copia con cambios
  Item copyWith({
    String? codigoItem,
    String? descripcionItem,
    String? unidadMedida,
    double? cantidad,
    double? precioUnitario,
    double? descuentoItemPorcentaje,
  }) {
    return Item(
      id: this.id,
      codigoItem: codigoItem ?? this.codigoItem,
      descripcionItem: descripcionItem ?? this.descripcionItem,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      descuentoItemPorcentaje: descuentoItemPorcentaje ?? this.descuentoItemPorcentaje,
    );
  }

  // Método para convertir a Map (útil para exportar/importar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigoItem': codigoItem,
      'descripcionItem': descripcionItem,
      'unidadMedida': unidadMedida,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'descuentoItemPorcentaje': descuentoItemPorcentaje,
    };
  }

  // Método para crear desde Map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      codigoItem: map['codigoItem'],
      descripcionItem: map['descripcionItem'],
      unidadMedida: map['unidadMedida'],
      cantidad: map['cantidad'],
      precioUnitario: map['precioUnitario'],
      descuentoItemPorcentaje: map['descuentoItemPorcentaje'],
    );
  }

  @override
  String toString() {
    return 'Item(id: $id, descripcionItem: $descripcionItem, cantidad: $cantidad, precioUnitario: $precioUnitario)';
  }
}
