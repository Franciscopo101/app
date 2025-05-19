# Arquitectura de la Aplicación de Cotizaciones para Android

## 1. Visión General

Esta aplicación híbrida desarrollada con Flutter permitirá la creación y gestión de cotizaciones/presupuestos en formato chileno, con un diseño similar a facturas. La aplicación funcionará completamente offline, con almacenamiento local, y está diseñada para un solo usuario administrador.

## 2. Tecnologías Principales

- **Framework**: Flutter (SDK de Google para desarrollo multiplataforma)
- **Lenguaje**: Dart
- **Almacenamiento Local**: Hive (base de datos NoSQL ligera para Flutter)
- **Generación de PDF**: pdf (paquete de Flutter para crear documentos PDF)
- **Gestión de Estado**: Provider (para manejo de estado simple y eficiente)
- **Persistencia de Datos**: path_provider (para acceder a directorios del sistema)

## 3. Estructura de Carpetas

```
cotizaciones_app/
├── android/                 # Configuración específica de Android
├── ios/                     # Configuración específica de iOS (no prioritario)
├── lib/                     # Código fuente principal
│   ├── main.dart            # Punto de entrada de la aplicación
│   ├── models/              # Modelos de datos
│   │   ├── cliente.dart     # Modelo para clientes
│   │   ├── cotizacion.dart  # Modelo para cotizaciones
│   │   ├── empresa.dart     # Modelo para datos de la empresa
│   │   └── item.dart        # Modelo para ítems de cotización
│   ├── screens/             # Pantallas de la aplicación
│   │   ├── home_screen.dart           # Pantalla principal/dashboard
│   │   ├── cotizacion_form_screen.dart # Formulario de cotización
│   │   ├── cotizacion_detail_screen.dart # Detalles de cotización
│   │   ├── cliente_form_screen.dart   # Formulario de cliente
│   │   ├── empresa_config_screen.dart # Configuración de empresa
│   │   └── pdf_preview_screen.dart    # Vista previa de PDF
│   ├── services/            # Servicios de la aplicación
│   │   ├── database_service.dart      # Gestión de base de datos local
│   │   ├── pdf_service.dart           # Generación de PDF
│   │   └── numero_service.dart        # Generación de números de cotización
│   ├── widgets/             # Widgets reutilizables
│   │   ├── item_form.dart             # Formulario para ítems
│   │   ├── cotizacion_list_item.dart  # Item de lista de cotizaciones
│   │   └── custom_inputs.dart         # Inputs personalizados
│   └── utils/               # Utilidades
│       ├── constants.dart             # Constantes de la aplicación
│       ├── formatters.dart            # Formateadores (moneda, RUT, etc.)
│       └── validators.dart            # Validadores de formularios
├── assets/                  # Recursos estáticos
│   ├── fonts/               # Fuentes personalizadas
│   └── images/              # Imágenes e iconos
├── pubspec.yaml             # Dependencias y configuración del proyecto
└── test/                    # Pruebas unitarias y de widgets
```

## 4. Modelos de Datos

### Cliente
```dart
class Cliente {
  final String id;
  String nombreRazonSocial;
  String rutCliente;
  String? giroCliente;
  String? direccion;
  String? comuna;
  String? ciudad;
  String? email;
  String? telefono;
  String? nombreContacto;
  DateTime fechaRegistro;
  
  // Constructor, métodos toJson/fromJson para persistencia
}
```

### Cotización
```dart
class Cotizacion {
  final String id;
  String numeroCotizacion;
  Cliente cliente;
  DateTime fechaEmision;
  DateTime? fechaValidez;
  String? tituloAsunto;
  String estado; // "Creada", "Enviada", "Aceptada", "En Ejecución", "Entregada"
  List<Item> items;
  double subtotalNeto;
  double descuentoGeneralPorcentaje;
  double montoDescuentoGeneral;
  double montoNetoFinal;
  double montoIva;
  double montoTotalCotizacion;
  String? formaPagoDescripcion;
  String? tiempoEntregaEstimado;
  String? validezOfertaDescripcion;
  String? notasAdicionales;
  DateTime fechaCreacionRegistro;
  DateTime fechaUltimaModificacion;
  
  // Constructor, métodos toJson/fromJson para persistencia
  // Método para calcular totales
}
```

### Empresa
```dart
class Empresa {
  String nombreEmpresa;
  String rutEmpresa;
  String? giroEmpresa;
  String? direccionEmpresa;
  String? emailEmpresa;
  String? telefonoEmpresa;
  String? logoPath; // Ruta a la imagen del logo almacenada localmente
  double ivaPorcentaje; // Por defecto 19.00 para Chile
  
  // Constructor, métodos toJson/fromJson para persistencia
}
```

### Item
```dart
class Item {
  final String id;
  String? codigoItem;
  String descripcionItem;
  String? unidadMedida;
  double cantidad;
  double precioUnitario;
  double descuentoItemPorcentaje;
  
  // Constructor, métodos toJson/fromJson para persistencia
  // Método para calcular valor total
  double get valorTotalItem => cantidad * precioUnitario * (1 - descuentoItemPorcentaje / 100);
}
```

## 5. Almacenamiento Local

Utilizaremos **Hive** como base de datos local NoSQL por su simplicidad, rendimiento y facilidad de uso con Flutter. Hive almacena los datos en formato binario y permite consultas rápidas.

### Inicialización de Hive
```dart
Future<void> initHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  
  // Registrar adaptadores para nuestros modelos
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(CotizacionAdapter());
  Hive.registerAdapter(EmpresaAdapter());
  Hive.registerAdapter(ItemAdapter());
  
  // Abrir boxes (colecciones)
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Cotizacion>('cotizaciones');
  await Hive.openBox<Empresa>('empresa');
  await Hive.openBox<Item>('items');
}
```

## 6. Generación de PDF

Utilizaremos el paquete **pdf** para generar documentos PDF de las cotizaciones. El servicio de PDF tomará una cotización y generará un documento con el formato de factura chilena, incluyendo:

- Logo y datos de la empresa
- Información del cliente
- Detalles de la cotización (número, fecha, validez)
- Tabla de ítems con descripciones, cantidades, precios y totales
- Subtotales, descuentos, IVA y total
- Condiciones comerciales y notas

El PDF generado se guardará localmente y podrá ser compartido por correo electrónico, WhatsApp u otras aplicaciones.

## 7. Flujo Principal de la Aplicación

1. **Configuración Inicial**:
   - Al primer inicio, el usuario configura los datos de su empresa
   - Opcionalmente carga un logo

2. **Dashboard**:
   - Muestra lista de cotizaciones recientes
   - Botones para crear nueva cotización, ver clientes, configuración

3. **Creación de Cotización**:
   - Selección de cliente existente o creación de nuevo cliente
   - Ingreso de datos generales de la cotización
   - Adición de ítems (descripción, cantidad, precio, descuento)
   - Cálculo automático de subtotales, IVA y total
   - Ingreso de condiciones comerciales
   - Guardado de la cotización

4. **Gestión de Cotizaciones**:
   - Visualización de detalles
   - Cambio de estado (Enviada, Aceptada, etc.)
   - Generación de PDF
   - Compartir PDF
   - Duplicar cotización
   - Eliminar cotización

5. **Gestión de Clientes**:
   - Creación, edición y eliminación de clientes
   - Visualización de cotizaciones por cliente

## 8. Consideraciones Adicionales

- **Validación de RUT Chileno**: Implementación de validador específico para RUT
- **Formato de Moneda**: Visualización de montos en formato de peso chileno
- **Respaldo de Datos**: Opción para exportar/importar datos
- **Numeración Automática**: Generación secuencial de números de cotización
- **Modo Oscuro**: Soporte para tema claro/oscuro

## 9. Dependencias Principales (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.15
  provider: ^6.0.5
  pdf: ^3.10.4
  printing: ^5.11.0
  intl: ^0.18.1
  uuid: ^3.0.7
  image_picker: ^1.0.4
  share_plus: ^7.1.0
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  hive_generator: ^2.0.0
  build_runner: ^2.4.6
```

Esta arquitectura proporciona una base sólida para desarrollar la aplicación de cotizaciones con todas las funcionalidades requeridas, manteniendo un diseño limpio y modular que facilitará el mantenimiento y posibles expansiones futuras.
