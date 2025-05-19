import 'package:flutter/material.dart';
import '../models/cotizacion.dart';
import '../utils/formatters.dart';

class CotizacionListItem extends StatelessWidget {
  final Cotizacion cotizacion;
  final String clienteNombre;
  final VoidCallback onTap;

  const CotizacionListItem({
    Key? key,
    required this.cotizacion,
    required this.clienteNombre,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cotizacion.numeroCotizacion,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildEstadoChip(cotizacion.estado),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                clienteNombre,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha: ${formatDate(cotizacion.fechaEmision)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    formatCurrency(cotizacion.montoTotalCotizacion),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoChip(String estado) {
    Color color;
    switch (estado) {
      case 'Creada':
        color = Colors.blue;
        break;
      case 'Enviada':
        color = Colors.orange;
        break;
      case 'Aceptada':
        color = Colors.green;
        break;
      case 'En Ejecucion':
        color = Colors.purple;
        break;
      case 'Entregada':
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
