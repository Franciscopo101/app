import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/empresa.dart';
import '../models/cliente.dart';
import '../models/cotizacion.dart';
import '../models/item.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DatabaseService extends ChangeNotifier {
  // Boxes para almacenamiento local
  late Box<Empresa> _empresaBox;
  late Box<Cliente> _clientesBox;
  late Box<Cotizacion> _cotizacionesBox;
  late Box<Item> _itemsBox;
  
  // Constructor
  DatabaseService() {
    _initBoxes();
  }
  
  // Inicializar boxes
  Future<void> _initBoxes() async {
    _empresaBox = Hive.box<Empresa>('empresa');
    _clientesBox = Hive.box<Cliente>('clientes');
    _cotizacionesBox = Hive.box<Cotizacion>('cotizaciones');
    _itemsBox = Hive.box<Item>('items');
  }
  
  // Inicializar empresa si no existe
  Future<void> initializeEmpresaIfNeeded() async {
    if (_empresaBox.isEmpty) {
      final defaultEmpresa = Empresa.defaultEmpresa();
      await _empresaBox.put(0, defaultEmpresa);
    }
  }
  
  // Obtener empresa
  Empresa? getEmpresa() {
    return _empresaBox.get(0);
  }
  
  // Actualizar empresa
  Future<void> updateEmpresa(Empresa empresa) async {
    await _empresaBox.put(0, empresa);
    notifyListeners();
  }
  
  // Obtener todos los clientes
  List<Cliente> getClientes() {
    return _clientesBox.values.toList();
  }
  
  // Obtener cliente por ID
  Cliente? getClienteById(String id) {
    return _clientesBox.values.firstWhere(
      (cliente) => cliente.id == id,
      orElse: () => null as Cliente,
    );
  }
  
  // Agregar cliente
  Future<void> addCliente(Cliente cliente) async {
    await _clientesBox.put(cliente.id, cliente);
    notifyListeners();
  }
  
  // Actualizar cliente
  Future<void> updateCliente(Cliente cliente) async {
    await _clientesBox.put(cliente.id, cliente);
    notifyListeners();
  }
  
  // Eliminar cliente
  Future<void> deleteCliente(String id) async {
    await _clientesBox.delete(id);
    notifyListeners();
  }
  
  // Obtener todas las cotizaciones
  List<Cotizacion> getCotizaciones() {
    return _cotizacionesBox.values.toList()
      ..sort((a, b) => b.fechaCreacionRegistro.compareTo(a.fechaCreacionRegistro));
  }
  
  // Obtener cotización por ID
  Cotizacion? getCotizacionById(String id) {
    return _cotizacionesBox.values.firstWhere(
      (cotizacion) => cotizacion.id == id,
      orElse: () => null as Cotizacion,
    );
  }
  
  // Generar número de cotización
  String generateNumeroCotizacion() {
    final now = DateTime.now();
    final year = now.year;
    
    // Obtener el último número de cotización
    int lastNumber = 0;
    final cotizaciones = getCotizaciones();
    
    if (cotizaciones.isNotEmpty) {
      for (var cotizacion in cotizaciones) {
        // Formato esperado: COT-YYYY-NNNN
        final parts = cotizacion.numeroCotizacion.split('-');
        if (parts.length == 3) {
          final cotYear = int.tryParse(parts[1]);
          final cotNumber = int.tryParse(parts[2]);
          
          if (cotYear == year && cotNumber != null && cotNumber > lastNumber) {
            lastNumber = cotNumber;
          }
        }
      }
    }
    
    // Incrementar el número y formatear
    final nextNumber = lastNumber + 1;
    return 'COT-$year-${nextNumber.toString().padLeft(4, '0')}';
  }
  
  // Agregar cotización
  Future<void> addCotizacion(Cotizacion cotizacion) async {
    await _cotizacionesBox.put(cotizacion.id, cotizacion);
    notifyListeners();
  }
  
  // Actualizar cotización
  Future<void> updateCotizacion(Cotizacion cotizacion) async {
    await _cotizacionesBox.put(cotizacion.id, cotizacion);
    notifyListeners();
  }
  
  // Eliminar cotización
  Future<void> deleteCotizacion(String id) async {
    await _cotizacionesBox.delete(id);
    notifyListeners();
  }
  
  // Exportar datos
  Future<String> exportData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'cotizaciones_backup_$timestamp.json';
    final file = File('$path/$fileName');
    
    // Crear mapa con todos los datos
    final data = {
      'empresa': getEmpresa()?.toMap(),
      'clientes': getClientes().map((cliente) => cliente.toMap()).toList(),
      'cotizaciones': getCotizaciones().map((cotizacion) => cotizacion.toMap()).toList(),
    };
    
    // Guardar como JSON
    await file.writeAsString(data.toString());
    
    return file.path;
  }
  
  // Importar datos
  Future<void> importData(String jsonString) async {
    // Implementar la lógica para importar datos desde JSON
    // Esto requeriría parsear el JSON y recrear los objetos
    // Luego guardarlos en sus respectivos boxes
    
    notifyListeners();
  }
}
