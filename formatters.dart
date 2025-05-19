import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Formateador de moneda en formato chileno
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'es_CL',
    symbol: '\$',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

// Formateador de fecha en formato chileno
String formatDate(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy', 'es_CL');
  return formatter.format(date);
}

// Formateador de fecha y hora
String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm', 'es_CL');
  return formatter.format(dateTime);
}

// Validador de RUT chileno
bool isValidRut(String rut) {
  // Eliminar puntos y guión
  rut = rut.replaceAll('.', '').replaceAll('-', '');
  
  // Verificar longitud mínima
  if (rut.length < 2) return false;
  
  // Separar cuerpo y dígito verificador
  String cuerpo = rut.substring(0, rut.length - 1);
  String dv = rut.substring(rut.length - 1).toUpperCase();
  
  // Calcular dígito verificador
  int suma = 0;
  int multiplicador = 2;
  
  // Sumar productos
  for (int i = cuerpo.length - 1; i >= 0; i--) {
    suma += int.parse(cuerpo[i]) * multiplicador;
    multiplicador = multiplicador == 7 ? 2 : multiplicador + 1;
  }
  
  // Calcular dígito verificador
  int resto = suma % 11;
  String dvCalculado = (11 - resto).toString();
  
  // Si el dígito es 11, se reemplaza por 0
  if (dvCalculado == '11') dvCalculado = '0';
  // Si el dígito es 10, se reemplaza por K
  if (dvCalculado == '10') dvCalculado = 'K';
  
  // Comparar dígito verificador
  return dv == dvCalculado;
}

// Formateador de RUT chileno
String formatRut(String rut) {
  // Eliminar puntos y guión
  rut = rut.replaceAll('.', '').replaceAll('-', '');
  
  // Separar cuerpo y dígito verificador
  String cuerpo = rut.substring(0, rut.length - 1);
  String dv = rut.substring(rut.length - 1).toUpperCase();
  
  // Formatear cuerpo con puntos
  String cuerpoFormateado = '';
  int count = 0;
  for (int i = cuerpo.length - 1; i >= 0; i--) {
    cuerpoFormateado = cuerpo[i] + cuerpoFormateado;
    count++;
    if (count == 3 && i > 0) {
      cuerpoFormateado = '.' + cuerpoFormateado;
      count = 0;
    }
  }
  
  // Retornar RUT formateado
  return '$cuerpoFormateado-$dv';
}
