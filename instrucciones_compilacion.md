# Instrucciones para Compilar el APK

Para generar el archivo APK instalable de la aplicación de Cotizaciones, siga estos pasos:

## Requisitos Previos

1. Flutter SDK instalado (versión 3.0.0 o superior)
2. Android SDK instalado
3. Java Development Kit (JDK) instalado
4. Un dispositivo Android conectado o un emulador configurado

## Pasos para Compilar

1. Abra una terminal o línea de comandos
2. Navegue al directorio raíz del proyecto:
   ```
   cd /ruta/a/cotizaciones_app_flutter
   ```
3. Asegúrese de que todas las dependencias estén instaladas:
   ```
   flutter pub get
   ```
4. Genere los archivos necesarios para Hive:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. Compile la aplicación en modo release:
   ```
   flutter build apk --release
   ```
6. El APK generado se encontrará en:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

## Instalación en Dispositivo

Para instalar el APK en un dispositivo Android:

1. Transfiera el archivo APK al dispositivo (vía USB, email, etc.)
2. En el dispositivo, navegue al archivo APK y tóquelo para iniciar la instalación
3. Si es la primera vez que instala una aplicación desde fuera de Google Play, deberá habilitar "Orígenes desconocidos" en la configuración de seguridad del dispositivo

## Notas Adicionales

- El APK generado está firmado con una clave de depuración, lo que es adecuado para pruebas pero no para distribución en Google Play
- Para una distribución más amplia, se recomienda generar una clave de firma personalizada y configurar el archivo `key.properties`
- La aplicación requiere Android 5.0 (API nivel 21) o superior
