import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/cotizacion.dart';
import '../models/cliente.dart';
import '../models/item.dart';
import '../utils/formatters.dart';
import '../widgets/item_form.dart';

class CotizacionFormScreen extends StatefulWidget {
  final String? cotizacionId; // Si es null, es una nueva cotización

  const CotizacionFormScreen({Key? key, this.cotizacionId}) : super(key: key);

  @override
  State<CotizacionFormScreen> createState() => _CotizacionFormScreenState();
}

class _CotizacionFormScreenState extends State<CotizacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Controladores para los campos de texto
  late TextEditingController _tituloController;
  late TextEditingController _descuentoGeneralController;
  late TextEditingController _formaPagoController;
  late TextEditingController _tiempoEntregaController;
  late TextEditingController _validezOfertaController;
  late TextEditingController _notasController;
  
  // Valores para la cotización
  String? _selectedClienteId;
  DateTime _fechaEmision = DateTime.now();
  DateTime? _fechaValidez;
  List<Item> _items = [];
  
  // Valores calculados
  double _subtotalNeto = 0.0;
  double _descuentoGeneralPorcentaje = 0.0;
  double _montoDescuentoGeneral = 0.0;
  double _montoNetoFinal = 0.0;
  double _montoIva = 0.0;
  double _montoTotalCotizacion = 0.0;
  
  bool _isEditing = false;
  late Cotizacion _cotizacionOriginal;
  
  @override
  void initState() {
    super.initState();
    
    _tituloController = TextEditingController();
    _descuentoGeneralController = TextEditingController(text: '0.0');
    _formaPagoController = TextEditingController();
    _tiempoEntregaController = TextEditingController();
    _validezOfertaController = TextEditingController();
    _notasController = TextEditingController();
    
    // Si estamos editando una cotización existente
    if (widget.cotizacionId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCotizacion();
      });
    }
  }
  
  @override
  void dispose() {
    _tituloController.dispose();
    _descuentoGeneralController.dispose();
    _formaPagoController.dispose();
    _tiempoEntregaController.dispose();
    _validezOfertaController.dispose();
    _notasController.dispose();
    super.dispose();
  }
  
  void _loadCotizacion() {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    final cotizacion = databaseService.getCotizacionById(widget.cotizacionId!);
    
    if (cotizacion != null) {
      _cotizacionOriginal = cotizacion;
      
      setState(() {
        _selectedClienteId = cotizacion.idCliente;
        _fechaEmision = cotizacion.fechaEmision;
        _fechaValidez = cotizacion.fechaValidez;
        _tituloController.text = cotizacion.tituloAsunto ?? '';
        _items = List.from(cotizacion.items);
        _descuentoGeneralPorcentaje = cotizacion.descuentoGeneralPorcentaje;
        _descuentoGeneralController.text = _descuentoGeneralPorcentaje.toString();
        _formaPagoController.text = cotizacion.formaPagoDescripcion ?? '';
        _tiempoEntregaController.text = cotizacion.tiempoEntregaEstimado ?? '';
        _validezOfertaController.text = cotizacion.validezOfertaDescripcion ?? '';
        _notasController.text = cotizacion.notasAdicionales ?? '';
        
        _subtotalNeto = cotizacion.subtotalNeto;
        _montoDescuentoGeneral = cotizacion.montoDescuentoGeneral;
        _montoNetoFinal = cotizacion.montoNetoFinal;
        _montoIva = cotizacion.montoIva;
        _montoTotalCotizacion = cotizacion.montoTotalCotizacion;
      });
    }
  }
  
  void _calcularTotales() {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    final empresa = databaseService.getEmpresa();
    final ivaPorcentaje = empresa?.ivaPorcentaje ?? 19.0;
    
    setState(() {
      // Calcular subtotal
      _subtotalNeto = 0.0;
      for (var item in _items) {
        _subtotalNeto += item.valorTotalItem;
      }
      
      // Calcular descuento general
      _montoDescuentoGeneral = _subtotalNeto * (_descuentoGeneralPorcentaje / 100);
      
      // Calcular monto neto final
      _montoNetoFinal = _subtotalNeto - _montoDescuentoGeneral;
      
      // Calcular IVA
      _montoIva = _montoNetoFinal * (ivaPorcentaje / 100);
      
      // Calcular total
      _montoTotalCotizacion = _montoNetoFinal + _montoIva;
    });
  }
  
  void _addItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ItemForm(
          onSave: (Item item) {
            setState(() {
              _items.add(item);
              _calcularTotales();
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
  
  void _editItem(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ItemForm(
          item: _items[index],
          onSave: (Item item) {
            setState(() {
              _items[index] = item;
              _calcularTotales();
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
  
  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calcularTotales();
    });
  }
  
  Future<void> _selectDate(BuildContext context, bool isValidityDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isValidityDate ? (_fechaValidez ?? DateTime.now().add(const Duration(days: 30))) : _fechaEmision,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      setState(() {
        if (isValidityDate) {
          _fechaValidez = picked;
        } else {
          _fechaEmision = picked;
        }
      });
    }
  }
  
  void _saveCotizacion() {
    if (_formKey.currentState!.validate()) {
      final databaseService = Provider.of<DatabaseService>(context, listen: false);
      
      // Verificar que haya un cliente seleccionado
      if (_selectedClienteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar un cliente')),
        );
        return;
      }
      
      // Verificar que haya al menos un ítem
      if (_items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe agregar al menos un ítem')),
        );
        return;
      }
      
      // Crear o actualizar la cotización
      if (_isEditing) {
        // Actualizar cotización existente
        final cotizacionActualizada = _cotizacionOriginal.copyWith(
          idCliente: _selectedClienteId,
          fechaEmision: _fechaEmision,
          fechaValidez: _fechaValidez,
          tituloAsunto: _tituloController.text.isNotEmpty ? _tituloController.text : null,
          items: _items,
          subtotalNeto: _subtotalNeto,
          descuentoGeneralPorcentaje: _descuentoGeneralPorcentaje,
          montoDescuentoGeneral: _montoDescuentoGeneral,
          montoNetoFinal: _montoNetoFinal,
          montoIva: _montoIva,
          montoTotalCotizacion: _montoTotalCotizacion,
          formaPagoDescripcion: _formaPagoController.text.isNotEmpty ? _formaPagoController.text : null,
          tiempoEntregaEstimado: _tiempoEntregaController.text.isNotEmpty ? _tiempoEntregaController.text : null,
          validezOfertaDescripcion: _validezOfertaController.text.isNotEmpty ? _validezOfertaController.text : null,
          notasAdicionales: _notasController.text.isNotEmpty ? _notasController.text : null,
        );
        
        databaseService.updateCotizacion(cotizacionActualizada);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización actualizada correctamente')),
        );
      } else {
        // Crear nueva cotización
        final nuevaCotizacion = Cotizacion(
          numeroCotizacion: databaseService.generateNumeroCotizacion(),
          idCliente: _selectedClienteId!,
          fechaEmision: _fechaEmision,
          fechaValidez: _fechaValidez,
          tituloAsunto: _tituloController.text.isNotEmpty ? _tituloController.text : null,
          items: _items,
          subtotalNeto: _subtotalNeto,
          descuentoGeneralPorcentaje: _descuentoGeneralPorcentaje,
          montoDescuentoGeneral: _montoDescuentoGeneral,
          montoNetoFinal: _montoNetoFinal,
          montoIva: _montoIva,
          montoTotalCotizacion: _montoTotalCotizacion,
          formaPagoDescripcion: _formaPagoController.text.isNotEmpty ? _formaPagoController.text : null,
          tiempoEntregaEstimado: _tiempoEntregaController.text.isNotEmpty ? _tiempoEntregaController.text : null,
          validezOfertaDescripcion: _validezOfertaController.text.isNotEmpty ? _validezOfertaController.text : null,
          notasAdicionales: _notasController.text.isNotEmpty ? _notasController.text : null,
        );
        
        databaseService.addCotizacion(nuevaCotizacion);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización creada correctamente')),
        );
      }
      
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cotización' : 'Nueva Cotización'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCotizacion,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              if (_currentStep < 3) {
                _currentStep += 1;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep -= 1;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          steps: [
            // Paso 1: Información General
            Step(
              title: const Text('Información General'),
              content: _buildInformacionGeneralStep(),
              isActive: _currentStep >= 0,
            ),
            // Paso 2: Ítems
            Step(
              title: const Text('Ítems'),
              content: _buildItemsStep(),
              isActive: _currentStep >= 1,
            ),
            // Paso 3: Totales y Condiciones
            Step(
              title: const Text('Totales y Condiciones'),
              content: _buildTotalesCondicionesStep(),
              isActive: _currentStep >= 2,
            ),
            // Paso 4: Vista Previa
            Step(
              title: const Text('Vista Previa'),
              content: _buildVistaPrevia(),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInformacionGeneralStep() {
    return Consumer<DatabaseService>(
      builder: (context, databaseService, child) {
        final clientes = databaseService.getClientes();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de cliente
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Cliente *',
                hintText: 'Seleccione un cliente',
              ),
              value: _selectedClienteId,
              items: clientes.map((cliente) {
                return DropdownMenuItem<String>(
                  value: cliente.id,
                  child: Text('${cliente.nombreRazonSocial} (${cliente.rutCliente})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClienteId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor seleccione un cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            
            // Botón para crear nuevo cliente
            if (clientes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegar a la pantalla de creación de cliente
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteFormScreen()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Cliente'),
                ),
              ),
            
            // Fecha de emisión
            ListTile(
              title: const Text('Fecha de Emisión *'),
              subtitle: Text(formatDate(_fechaEmision)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            
            // Fecha de validez
            ListTile(
              title: const Text('Fecha de Validez'),
              subtitle: Text(_fechaValidez != null ? formatDate(_fechaValidez!) : 'No especificada'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            
            // Título/Asunto
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título/Asunto',
                hintText: 'Ej. Servicio de Instalación Eléctrica',
              ),
              maxLines: 2,
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildItemsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lista de ítems
        if (_items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text('No hay ítems agregados'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(item.descripcionItem),
                  subtitle: Text(
                    '${item.cantidad} ${item.unidadMedida ?? 'unid.'} x ${formatCurrency(item.precioUnitario)} ${item.descuentoItemPorcentaje > 0 ? '(-${item.descuentoItemPorcentaje}%)' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatCurrency(item.valorTotalItem),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItem(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeItem(index),
                      ),
          
(Content truncated due to size limit. Use line ranges to read in chunks)