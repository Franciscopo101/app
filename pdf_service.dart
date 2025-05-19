import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../models/cotizacion.dart';
import '../models/cliente.dart';
import '../models/empresa.dart';
import '../utils/formatters.dart';

class PdfService {
  Future<String> generateCotizacionPdf({
    required Cotizacion cotizacion,
    required Cliente? cliente,
    required Empresa? empresa,
  }) async {
    // Crear documento PDF
    final pdf = pw.Document();
    
    // Obtener fuente
    final font = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();
    
    // Crear página
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Logo y datos de empresa
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          empresa?.nombreEmpresa ?? 'Mi Empresa',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 18,
                          ),
                        ),
                        pw.Text('RUT: ${empresa?.rutEmpresa ?? ''}'),
                        if (empresa?.giroEmpresa != null)
                          pw.Text('Giro: ${empresa.giroEmpresa}'),
                        if (empresa?.direccionEmpresa != null)
                          pw.Text('Dirección: ${empresa.direccionEmpresa}'),
                        if (empresa?.emailEmpresa != null)
                          pw.Text('Email: ${empresa.emailEmpresa}'),
                        if (empresa?.telefonoEmpresa != null)
                          pw.Text('Teléfono: ${empresa.telefonoEmpresa}'),
                      ],
                    ),
                  ),
                  
                  // Datos del documento
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'COTIZACIÓN',
                          style: pw.TextStyle(
                            font: fontBold,
                          ),
                        ),
                        pw.Text('N°: ${cotizacion.numeroCotizacion}'),
                        pw.Text('Fecha: ${formatDate(cotizacion.fechaEmision)}'),
                        if (cotizacion.fechaValidez != null)
                          pw.Text('Válida hasta: ${formatDate(cotizacion.fechaValidez!)}'),
                      ],
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Datos del cliente
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'CLIENTE',
                      style: pw.TextStyle(
                        font: fontBold,
                      ),
                    ),
                    if (cliente != null) ...[
                      pw.Text('Razón Social: ${cliente.nombreRazonSocial}'),
                      pw.Text('RUT: ${cliente.rutCliente}'),
                      if (cliente.giroCliente != null)
                        pw.Text('Giro: ${cliente.giroCliente}'),
                      if (cliente.direccion != null)
                        pw.Text('Dirección: ${cliente.direccion}${cliente.comuna != null ? ', ${cliente.comuna}' : ''}${cliente.ciudad != null ? ', ${cliente.ciudad}' : ''}'),
                      if (cliente.email != null)
                        pw.Text('Email: ${cliente.email}'),
                      if (cliente.telefono != null)
                        pw.Text('Teléfono: ${cliente.telefono}'),
                    ] else
                      pw.Text('Cliente no encontrado'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Título/Asunto
              if (cotizacion.tituloAsunto != null)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(
                    cotizacion.tituloAsunto!,
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                    ),
                  ),
                ),
              
              // Tabla de ítems
              pw.Text(
                'DETALLE',
                style: pw.TextStyle(
                  font: fontBold,
                ),
              ),
              pw.SizedBox(height: 5),
              
              // Encabezados de tabla
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(),
                  ),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(
                        'Descripción',
                        style: pw.TextStyle(font: fontBold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Cant.',
                        style: pw.TextStyle(font: fontBold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Precio Unit.',
                        style: pw.TextStyle(font: fontBold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Total',
                        style: pw.TextStyle(font: fontBold),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filas de ítems
              pw.ListView.builder(
                itemCount: cotizacion.items.length,
                itemBuilder: (context, index) {
                  final item = cotizacion.items[index];
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 5,
                          child: pw.Text(item.descripcionItem),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            '${item.cantidad} ${item.unidadMedida ?? ''}',
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            formatCurrency(item.precioUnitario),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            formatCurrency(item.valorTotalItem),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              pw.SizedBox(height: 10),
              
              // Totales
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Text('Subtotal:'),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            formatCurrency(cotizacion.subtotalNeto),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    if (cotizacion.descuentoGeneralPorcentaje > 0)
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 120,
                            child: pw.Text('Descuento (${cotizacion.descuentoGeneralPorcentaje}%):'),
                          ),
                          pw.Container(
                            width: 100,
                            child: pw.Text(
                              formatCurrency(cotizacion.montoDescuentoGeneral),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Text('Neto:'),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            formatCurrency(cotizacion.montoNetoFinal),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Text('IVA (${empresa?.ivaPorcentaje ?? 19}%):'),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            formatCurrency(cotizacion.montoIva),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Text(
                            'TOTAL:',
                            style: pw.TextStyle(font: fontBold),
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          child: pw.Text(
                            formatCurrency(cotizacion.montoTotalCotizacion),
                            style: pw.TextStyle(font: fontBold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Condiciones comerciales
              if (cotizacion.formaPagoDescripcion != null ||
                  cotizacion.tiempoEntregaEstimado != null ||
                  cotizacion.validezOfertaDescripcion != null ||
                  cotizacion.notasAdicionales != null)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'CONDICIONES COMERCIALES',
                      style: pw.TextStyle(
                        font: fontBold,
                      ),
                    ),
                    pw.Divider(),
                    if (cotizacion.formaPagoDescripcion != null)
                      pw.Text('Forma de Pago: ${cotizacion.formaPagoDescripcion}'),
                    if (cotizacion.tiempoEntregaEstimado != null)
                      pw.Text('Tiempo de Entrega: ${cotizacion.tiempoEntregaEstimado}'),
                    if (cotizacion.validezOfertaDescripcion != null)
                      pw.Text('Validez de la Oferta: ${cotizacion.validezOfertaDescripcion}'),
                    if (cotizacion.notasAdicionales != null)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10),
                        child: pw.Text('Notas: ${cotizacion.notasAdicionales}'),
                      ),
                  ],
                ),
              
              // Pie de página
              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  'Cotización generada el ${formatDateTime(DateTime.now())}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    
    // Guardar PDF en archivo
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = 'cotizacion_${cotizacion.numeroCotizacion.replaceAll('-', '_')}.pdf';
    final file = File('$path/$fileName');
    
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }
}
