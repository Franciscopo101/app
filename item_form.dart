import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/item.dart';
import '../utils/formatters.dart';

class ItemForm extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  const ItemForm({Key? key, this.item, required this.onSave}) : super(key: key);

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codigoController;
  late TextEditingController _descripcionController;
  late TextEditingController _unidadMedidaController;
  late TextEditingController _cantidadController;
  late TextEditingController _precioUnitarioController;
  late TextEditingController _descuentoController;
  
  double _cantidad = 1.0;
  double _precioUnitario = 0.0;
  double _descuentoPorcentaje = 0.0;
  double _valorTotal = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores
    _codigoController = TextEditingController(text: widget.item?.codigoItem ?? '');
    _descripcionController = TextEditingController(text: widget.item?.descripcionItem ?? '');
    _unidadMedidaController = TextEditingController(text: widget.item?.unidadMedida ?? '');
    _cantidadController = TextEditingController(text: widget.item?.cantidad.toString() ?? '1.0');
    _precioUnitarioController = TextEditingController(text: widget.item?.precioUnitario.toString() ?? '0.0');
    _descuentoController = TextEditingController(text: widget.item?.descuentoItemPorcentaje.toString() ?? '0.0');
    
    // Inicializar valores
    _cantidad = widget.item?.cantidad ?? 1.0;
    _precioUnitario = widget.item?.precioUnitario ?? 0.0;
    _descuentoPorcentaje = widget.item?.descuentoItemPorcentaje ?? 0.0;
    
    // Calcular valor total inicial
    _calcularValorTotal();
  }
  
  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    _unidadMedidaController.dispose();
    _cantidadController.dispose();
    _precioUnitarioController.dispose();
    _descuentoController.dispose();
    super.dispose();
  }
  
  void _calcularValorTotal() {
    setState(() {
      _valorTotal = _cantidad * _precioUnitario * (1 - _descuentoPorcentaje / 100);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item == null ? 'Agregar Ítem' : 'Editar Ítem',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Código (opcional)
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código (opcional)',
                  hintText: 'Ej. PROD-001',
                ),
              ),
              const SizedBox(height: 16),
              
              // Descripción (requerido)
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  hintText: 'Ej. Servicio de instalación eléctrica',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              // Unidad de medida (opcional)
              TextFormField(
                controller: _unidadMedidaController,
                decoration: const InputDecoration(
                  labelText: 'Unidad de Medida (opcional)',
                  hintText: 'Ej. hr, und, m2',
                ),
              ),
              const SizedBox(height: 16),
              
              // Cantidad (requerido)
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad *',
                  hintText: 'Ej. 10',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad';
                  }
                  final cantidad = double.tryParse(value);
                  if (cantidad == null || cantidad <= 0) {
                    return 'La cantidad debe ser mayor a 0';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _cantidad = double.tryParse(value) ?? 0.0;
                    _calcularValorTotal();
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Precio unitario (requerido)
              TextFormField(
                controller: _precioUnitarioController,
                decoration: const InputDecoration(
                  labelText: 'Precio Unitario *',
                  hintText: 'Ej. 25000',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio unitario';
                  }
                  final precio = double.tryParse(value);
                  if (precio == null || precio < 0) {
                    return 'El precio debe ser mayor o igual a 0';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _precioUnitario = double.tryParse(value) ?? 0.0;
                    _calcularValorTotal();
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Descuento (opcional)
              TextFormField(
                controller: _descuentoController,
                decoration: const InputDecoration(
                  labelText: 'Descuento (%)',
                  hintText: 'Ej. 10',
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final descuento = double.tryParse(value);
                    if (descuento == null || descuento < 0 || descuento > 100) {
                      return 'El descuento debe estar entre 0 y 100';
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _descuentoPorcentaje = double.tryParse(value) ?? 0.0;
                    _calcularValorTotal();
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Valor total (calculado)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Valor Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrency(_valorTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final item = Item(
                          id: widget.item?.id,
                          codigoItem: _codigoController.text.isNotEmpty ? _codigoController.text : null,
                          descripcionItem: _descripcionController.text,
                          unidadMedida: _unidadMedidaController.text.isNotEmpty ? _unidadMedidaController.text : null,
                          cantidad: _cantidad,
                          precioUnitario: _precioUnitario,
                          descuentoItemPorcentaje: _descuentoPorcentaje,
                        );
                        
                        widget.onSave(item);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
