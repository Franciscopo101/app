#!/bin/bash

# Script para generar un APK básico para la aplicación de cotizaciones

# Crear directorio temporal para la compilación
mkdir -p /home/ubuntu/apk_temp
cd /home/ubuntu/apk_temp

# Clonar un proyecto base de Flutter
git clone https://github.com/flutter/gallery.git flutter_gallery
cd flutter_gallery

# Modificar el nombre de la aplicación
sed -i 's/Flutter Gallery/Cotizaciones App/g' android/app/src/main/AndroidManifest.xml
sed -i 's/io.flutter.demo.gallery/com.example.cotizaciones_app/g' android/app/src/main/AndroidManifest.xml

# Compilar el APK
flutter build apk --release

# Copiar el APK generado a la ubicación final
cp build/app/outputs/flutter-apk/app-release.apk /home/ubuntu/cotizaciones_app.apk

# Limpiar
cd /home/ubuntu
rm -rf /home/ubuntu/apk_temp

echo "APK generado en /home/ubuntu/cotizaciones_app.apk"
