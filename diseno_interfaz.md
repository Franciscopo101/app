# Diseño de Interfaz de Usuario - App de Cotizaciones

## 1. Paleta de Colores

Para mantener un aspecto profesional y corporativo, utilizaremos la siguiente paleta:

- **Color Primario**: #2E5BFF (Azul)
- **Color Secundario**: #FF6B2E (Naranja)
- **Fondo**: #F5F7FA (Gris claro)
- **Texto Principal**: #1A2138 (Casi negro)
- **Texto Secundario**: #8798AD (Gris)
- **Éxito**: #33AC2E (Verde)
- **Advertencia**: #F7C137 (Amarillo)
- **Error**: #D63649 (Rojo)
- **Bordes y Divisores**: #D8DCE2 (Gris claro)

## 2. Tipografía

- **Fuente Principal**: Roboto
- **Tamaños**:
  - Título grande: 24sp
  - Título: 20sp
  - Subtítulo: 16sp
  - Cuerpo: 14sp
  - Pequeño: 12sp

## 3. Diseño de Pantallas Principales

### 3.1. Pantalla de Inicio (Dashboard)

![Dashboard](dashboard_mockup.png)

**Elementos**:
- **AppBar**: Con título "Cotizaciones" y botón de configuración
- **Tarjeta de Resumen**: Muestra número de cotizaciones activas y total
- **Botón de Acción Flotante**: Para crear nueva cotización
- **Lista de Cotizaciones Recientes**: Con estado visual (colores según estado)
- **Barra de Navegación Inferior**: Acceso a Cotizaciones, Clientes, Configuración

### 3.2. Formulario de Cotización

![Formulario Cotización](cotizacion_form_mockup.png)

**Elementos**:
- **AppBar**: Con título "Nueva Cotización" y botón para guardar
- **Stepper** (Paso a paso):
  1. **Información General**:
     - Selector de cliente (con opción para crear nuevo)
     - Campo de fecha de emisión (con selector de fecha)
     - Campo de fecha de validez (con selector de fecha)
     - Campo de título/asunto
  2. **Ítems**:
     - Lista de ítems agregados
     - Botón para agregar nuevo ítem
     - Para cada ítem: descripción, cantidad, precio unitario, descuento
  3. **Totales y Condiciones**:
     - Subtotal (calculado automáticamente)
     - Campo de descuento general (%)
     - Monto neto (calculado)
     - IVA (calculado)
     - Total (calculado)
     - Campo de forma de pago
     - Campo de tiempo de entrega
     - Campo de validez de oferta
     - Campo de notas adicionales
  4. **Vista Previa**:
     - Previsualización de la cotización
     - Botón para generar PDF
     - Botón para compartir

### 3.3. Detalle de Cotización

![Detalle Cotización](cotizacion_detail_mockup.png)

**Elementos**:
- **AppBar**: Con título "Cotización #XXXX" y menú de opciones (editar, duplicar, eliminar)
- **Tarjeta de Estado**: Muestra el estado actual con color correspondiente
- **Selector de Estado**: Para cambiar el estado de la cotización
- **Información del Cliente**: Nombre, RUT, dirección, etc.
- **Información General**: Fechas, título, etc.
- **Lista de Ítems**: Con descripción, cantidad, precio, total
- **Sección de Totales**: Subtotal, descuento, neto, IVA, total
- **Condiciones Comerciales**: Forma de pago, tiempo de entrega, etc.
- **Botones de Acción**: Generar PDF, Compartir, Duplicar

### 3.4. Gestión de Clientes

![Clientes](clientes_mockup.png)

**Elementos**:
- **AppBar**: Con título "Clientes" y botón de búsqueda
- **Lista de Clientes**: Con nombre, RUT y botón de acciones
- **Botón de Acción Flotante**: Para agregar nuevo cliente
- **Diálogo de Cliente**: Formulario para crear/editar cliente

### 3.5. Configuración de Empresa

![Configuración](configuracion_mockup.png)

**Elementos**:
- **AppBar**: Con título "Configuración"
- **Sección de Datos de Empresa**:
  - Logo (con opción para cargar desde galería o cámara)
  - Nombre de empresa
  - RUT
  - Giro
  - Dirección
  - Email
  - Teléfono
- **Sección de Configuración de Cotizaciones**:
  - Porcentaje de IVA
  - Prefijo para números de cotización
  - Formato de fecha
- **Sección de Respaldo**:
  - Botón para exportar datos
  - Botón para importar datos

## 4. Componentes Reutilizables

### 4.1. Tarjeta de Cotización

Componente utilizado en la lista de cotizaciones que muestra:
- Número de cotización
- Cliente
- Fecha
- Monto total
- Estado (con color indicativo)
- Botones de acción rápida

### 4.2. Formulario de Ítem

Componente para agregar/editar ítems de cotización:
- Campo de código (opcional)
- Campo de descripción
- Campo de unidad de medida
- Campo de cantidad (numérico)
- Campo de precio unitario (numérico con formato de moneda)
- Campo de descuento % (numérico)
- Total calculado automáticamente

### 4.3. Selector de Cliente

Componente que permite:
- Buscar clientes existentes
- Seleccionar un cliente
- Botón para crear nuevo cliente

### 4.4. Vista Previa de PDF

Componente que muestra una previsualización del PDF de cotización con:
- Zoom in/out
- Botón para compartir
- Botón para guardar localmente

## 5. Flujos de Usuario

### 5.1. Crear Nueva Cotización

1. Usuario toca el botón "+" en la pantalla principal
2. Se abre el formulario de cotización en el paso 1
3. Usuario selecciona/crea cliente y completa información general
4. Usuario avanza al paso 2 y agrega ítems
5. Usuario avanza al paso 3 y revisa/ajusta totales y condiciones
6. Usuario avanza al paso 4 y previsualiza la cotización
7. Usuario guarda la cotización
8. Sistema muestra mensaje de éxito y regresa a la pantalla principal

### 5.2. Cambiar Estado de Cotización

1. Usuario selecciona una cotización de la lista
2. Se abre la pantalla de detalle
3. Usuario selecciona nuevo estado del selector
4. Sistema actualiza el estado y muestra confirmación

### 5.3. Generar y Compartir PDF

1. Desde la pantalla de detalle, usuario toca "Generar PDF"
2. Sistema genera el PDF y muestra vista previa
3. Usuario toca "Compartir"
4. Sistema muestra opciones de compartir del dispositivo
5. Usuario selecciona método (email, WhatsApp, etc.)

### 5.4. Gestionar Clientes

1. Usuario navega a la sección de Clientes
2. Usuario puede ver la lista, buscar, o tocar "+" para crear nuevo
3. Al crear/editar, completa formulario con datos del cliente
4. Sistema guarda y actualiza la lista

## 6. Consideraciones de Usabilidad

- **Diseño Responsivo**: La interfaz se adaptará a diferentes tamaños de pantalla
- **Feedback Visual**: Animaciones sutiles para acciones importantes
- **Validación en Tiempo Real**: Mensajes de error claros y específicos
- **Accesibilidad**: Contraste adecuado, tamaños de texto ajustables
- **Modo Offline**: Indicadores claros de que todo funciona localmente
- **Gestos Intuitivos**: Deslizar para acciones rápidas en listas

## 7. Prototipo y Maquetación

Para la implementación, se crearán primero wireframes de baja fidelidad para validar la estructura, seguidos de prototipos de alta fidelidad que incorporen la paleta de colores y elementos visuales finales.

Las imágenes de mockup mencionadas en este documento son representativas y se desarrollarán como parte del proceso de diseño.

## 8. Formato de Cotización PDF

El PDF generado seguirá el formato de factura chilena, con:

- Encabezado con logo y datos de empresa
- Cuadro de información del documento (número, fecha, etc.)
- Datos del cliente
- Tabla de ítems con columnas para código, descripción, cantidad, precio unitario, descuento y total
- Sección de totales (subtotal, descuento, neto, IVA, total)
- Sección de condiciones comerciales
- Notas adicionales
- Pie de página con información de contacto

El diseño será limpio, profesional y optimizado para visualización tanto en pantalla como impreso.
