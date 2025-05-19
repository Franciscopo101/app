import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/cotizacion.dart';
import '../utils/formatters.dart';
import '../services/pdf_service.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'cotizacion_form_screen.dart';

class CotizacionDetailScreen extends StatefulWidget {
  final String cotizacionId;

  const CotizacionDetailScreen({Key? key, required this.cotizacionId}) : super(key: key);

  @override
  State<CotizacionDetailScreen> createState() => _CotizacionDetailScreenState();
}

class _CotizacionDetailScreenState extends State<CotizacionDetailScreen> {
  bool _isGeneratingPdf = false;
  String? _pdfPath;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseService>(
      builder: (context, databaseService, child) {
        final cotizacion = databaseService.getCotizacionById(widget.cotizacionId);
        
        if (cotizacion == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalle de Cotización'),
            ),
            body: const Center(
              child: Text('Cotización no encontrada'),
            ),
          );
        }
        
        final cliente = databaseService.getClienteById(cotizacion.idCliente);
        final empresa = databaseService.getEmpresa();
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Cotización ${cotizacion.numeroCotizacion}'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CotizacionFormScreen(cotizacionId: cotizacion.id),
                        ),
                      );
                      break;
                    case 'duplicate':
                      _duplicateCotizacion(cotizacion, databaseService);
                      break;
                    case 'delete':
                      _showDeleteConfirmationDialog(cotizacion, databaseService);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Editar'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'duplicate',
                    child: ListTile(
                      leading: Icon(Icons.copy),
                      title: Text('Duplicar'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Eliminar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de estado
                Card(
                  color: _getColorForEstado(cotizacion.estado),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForEstado(cotizacion.estado),
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estado: ${cotizacion.estado}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          onSelected: (newEstado) {
                            _updateEstado(cotizacion, newEstado, databaseService);
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Creada',
                              child: Text('Creada'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Enviada',
                              child: Text('Enviada'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Aceptada',
                              child: Text('Aceptada'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'En Ejecucion',
                              child: Text('En Ejecución'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Entregada',
                              child: Text('Entregada'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Información del cliente
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CLIENTE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (cliente != null) ...[
                          Text('Razón Social: ${cliente.nombreRazonSocial}'),
                          Text('RUT: ${cliente.rutCliente}'),
                          if (cliente.giroCliente != null)
                            Text('Giro: ${cliente.giroCliente}'),
                          if (cliente.direccion != null)
                            Text('Dirección: ${cliente.direccion}${cliente.comuna != null ? ', ${cliente.comuna}' : ''}${cliente.ciudad != null ? ', ${cliente.ciudad}' : ''}'),
                          if (cliente.email != null)
                            Text('Email: ${cliente.email}'),
                          if (cliente.telefono != null)
                            Text('Teléfono: ${cliente.telefono}'),
                        ] else
                          const Text('Cliente no encontrado'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Información general
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'INFORMACIÓN GENERAL',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        Text('Número: ${cotizacion.numeroCotizacion}'),
                        Text('Fecha Emisión: ${formatDate(cotizacion.fechaEmision)}'),
                        if (cotizacion.fechaValidez != null)
                          Text('Fecha Validez: ${formatDate(cotizacion.fechaValidez!)}'),
                        if (cotizacion.tituloAsunto != null)
                          Text('Título/Asunto: ${cotizacion.tituloAsunto}'),
                        Text('Fecha Creación: ${formatDateTime(cotizacion.fechaCreacionRegistro)}'),
                        Text('Última Modificación: ${formatDateTime(cotizacion.fechaUltimaModificacion)}'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Lista de ítems
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ÍTEMS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cotizacion.items.length,
                          itemBuilder: (context, index) {
                            final item = cotizacion.items[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(item.descripcionItem),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${item.cantidad} ${item.unidadMedida ?? ''}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      formatCurrency(item.precioUnitario),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      formatCurrency(item.valorTotalItem),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Spacer(flex: 6),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Subtotal:'),
                                  Text('Descuento:'),
                                  Text('Neto:'),
                                  Text('IVA (19%):'),
                                  Text(
                                    'TOTAL:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(formatCurrency(cotizacion.subtotalNeto)),
                                  Text(formatCurrency(cotizacion.montoDescuentoGeneral)),
                                  Text(formatCurrency(cotizacion.montoNetoFinal)),
                                  Text(formatCurrency(cotizacion.montoIva)),
                                  Text(
                                    formatCurrency(cotizacion.montoTotalCotizacion),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Condiciones comerciales
                if (cotizacion.formaPagoDescripcion != null ||
                    cotizacion.tiempoEntregaEstimado != null ||
                    cotizacion.validezOfertaDescripcion != null ||
                    cotizacion.notasAdicionales != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CONDICIONES COMERCIALES',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          if (cotizacion.formaPagoDescripcion != null)
                            Text('Forma de Pago: ${cotizacion.formaPagoDescripcion}'),
                          if (cotizacion.tiempoEntregaEstimado != null)
                            Text('Tiempo de Entrega: ${cotizacion.tiempoEntregaEstimado}'),
                          if (cotizacion.validezOfertaDescripcion != null)
                            Text('Validez de la Oferta: ${cotizacion.validezOfertaDescripcion}'),
                          if (cotizacion.notasAdicionales != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Notas: ${cotizacion.notasAdicionales}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isGeneratingPdf
                          ? null
                          : () => _generatePdf(cotizacion, cliente, empresa, databaseService),
                      icon: _isGeneratingPdf
                          ? const SizedBox(
(Content truncated due to size limit. Use line ranges to read in chunks)