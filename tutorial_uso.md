# Tutorial de Uso - App de Cotizaciones

## Introducción

Bienvenido a la aplicación de Cotizaciones, una herramienta diseñada específicamente para crear y gestionar cotizaciones en formato chileno. Esta aplicación funciona completamente offline, almacenando todos los datos en su dispositivo, lo que le permite trabajar sin necesidad de conexión a internet.

Este tutorial le guiará a través de todas las funcionalidades de la aplicación, desde la configuración inicial hasta la generación y compartición de cotizaciones en formato PDF.

## Instalación

1. Descargue el archivo APK proporcionado
2. En su dispositivo Android, vaya a Configuración > Seguridad
3. Active la opción "Orígenes desconocidos" (puede variar según la versión de Android)
4. Abra el archivo APK descargado y siga las instrucciones para instalar
5. Una vez instalada, busque el ícono de la aplicación "Cotizaciones" en su pantalla de inicio o cajón de aplicaciones

## Primer Inicio y Configuración

Al abrir la aplicación por primera vez, se creará automáticamente una configuración por defecto. Se recomienda personalizar esta configuración con los datos de su empresa:

1. Vaya a la pestaña "Configuración" (ícono de engranaje en la barra inferior)
2. Complete los siguientes campos:
   - Nombre de la Empresa
   - RUT de la Empresa
   - Giro de la Empresa
   - Dirección
   - Email
   - Teléfono
   - Porcentaje de IVA (por defecto 19%)
3. Opcionalmente, puede cargar el logo de su empresa tocando en el área de imagen
4. Presione "Guardar" para aplicar los cambios

## Gestión de Clientes

### Crear un Nuevo Cliente

1. Vaya a la pestaña "Clientes" (ícono de personas en la barra inferior)
2. Toque el botón "+" en la esquina inferior derecha
3. Complete los campos del formulario:
   - Nombre o Razón Social (obligatorio)
   - RUT (obligatorio)
   - Giro
   - Dirección
   - Comuna
   - Ciudad
   - Email
   - Teléfono
   - Nombre de Contacto
4. Presione "Guardar" para crear el cliente

### Editar o Eliminar un Cliente

1. En la lista de clientes, toque el cliente que desea modificar
2. Para editar: toque el ícono de lápiz, realice los cambios y presione "Guardar"
3. Para eliminar: toque el ícono de papelera y confirme la eliminación

## Creación de Cotizaciones

### Crear una Nueva Cotización

1. En la pantalla principal, toque el botón "+" en la esquina inferior derecha
2. Siga los pasos del asistente:

#### Paso 1: Información General
- Seleccione un cliente de la lista desplegable
- Ajuste la fecha de emisión (por defecto es la fecha actual)
- Opcionalmente, establezca una fecha de validez
- Ingrese un título o asunto para la cotización

#### Paso 2: Ítems
- Toque "Agregar Ítem" para añadir productos o servicios
- Para cada ítem, complete:
  - Descripción (obligatorio)
  - Cantidad (obligatorio)
  - Precio Unitario (obligatorio)
  - Unidad de Medida (opcional)
  - Código (opcional)
  - Descuento % (opcional)
- El valor total se calculará automáticamente
- Puede editar o eliminar ítems existentes tocando los íconos correspondientes

#### Paso 3: Totales y Condiciones
- Revise el subtotal (calculado automáticamente)
- Opcionalmente, aplique un descuento general (%)
- Los valores de Neto, IVA y Total se calcularán automáticamente
- Complete las condiciones comerciales:
  - Forma de Pago (ej. "50% anticipo, 50% contra entrega")
  - Tiempo de Entrega (ej. "15 días hábiles")
  - Validez de la Oferta (ej. "30 días")
  - Notas Adicionales

#### Paso 4: Vista Previa
- Revise cómo se verá la cotización
- Si todo está correcto, toque "Guardar" en la barra superior

### Ver y Gestionar Cotizaciones

1. En la pantalla principal, verá la lista de cotizaciones ordenadas por fecha
2. Cada cotización muestra:
   - Número de cotización
   - Cliente
   - Fecha
   - Monto total
   - Estado (con color indicativo)
3. Toque una cotización para ver sus detalles

### Detalle de Cotización

En la pantalla de detalle puede:

1. Ver toda la información de la cotización
2. Cambiar el estado: toque el estado actual y seleccione uno nuevo
   - Creada: estado inicial
   - Enviada: cuando se envía al cliente
   - Aceptada: cuando el cliente la aprueba
   - En Ejecución: cuando se está realizando el trabajo
   - Entregada: cuando se completa el servicio/proyecto
3. Generar PDF: toque "Generar PDF" para crear un documento PDF de la cotización
4. Compartir: toque "Compartir" para enviar el PDF por correo, WhatsApp, etc.
5. Editar: toque el ícono de menú (tres puntos) y seleccione "Editar"
6. Duplicar: útil para crear una cotización similar a una existente
7. Eliminar: para borrar la cotización

## Generación y Compartición de PDF

### Generar PDF

1. En la pantalla de detalle de cotización, toque "Generar PDF"
2. Espere mientras se genera el documento (puede tomar unos segundos)
3. Una vez generado, se mostrará un mensaje de confirmación

### Compartir PDF

1. Después de generar el PDF, toque "Compartir"
2. Seleccione la aplicación con la que desea compartir (correo, WhatsApp, Drive, etc.)
3. Complete la información adicional según la aplicación seleccionada y envíe

## Respaldo de Datos

### Exportar Datos

1. Vaya a la pestaña "Configuración"
2. Toque "Exportar Datos"
3. Se generará un archivo de respaldo
4. Seleccione dónde guardar el archivo (recomendado: Google Drive u otro servicio en la nube)

### Importar Datos

1. Vaya a la pestaña "Configuración"
2. Toque "Importar Datos"
3. Seleccione el archivo de respaldo previamente exportado
4. Confirme la importación (esto reemplazará todos los datos actuales)

## Consejos y Trucos

- **Trabajo Offline**: La aplicación funciona completamente sin internet, todos los datos se guardan localmente en su dispositivo
- **Respaldos Regulares**: Realice exportaciones periódicas para evitar pérdida de datos
- **Duplicar Cotizaciones**: Use la función "Duplicar" para ahorrar tiempo cuando cree cotizaciones similares
- **Previsualización**: Siempre revise la vista previa antes de generar el PDF final
- **Organización**: Mantenga actualizado el estado de sus cotizaciones para un mejor seguimiento

## Solución de Problemas

### La aplicación se cierra inesperadamente
- Asegúrese de tener la última versión instalada
- Reinicie su dispositivo
- Si el problema persiste, desinstale y vuelva a instalar la aplicación

### No puedo generar PDF
- Verifique que tiene suficiente espacio de almacenamiento
- Asegúrese de que la cotización tiene al menos un ítem
- Reinicie la aplicación e intente nuevamente

### Los cálculos no parecen correctos
- Verifique el porcentaje de IVA en la configuración
- Revise los descuentos aplicados (por ítem y general)
- Compruebe que las cantidades y precios unitarios son correctos

## Contacto y Soporte

Si encuentra algún problema o tiene sugerencias para mejorar la aplicación, por favor contacte al desarrollador.

---

¡Gracias por utilizar nuestra aplicación de Cotizaciones! Esperamos que esta herramienta le ayude a gestionar sus cotizaciones de manera eficiente y profesional.
