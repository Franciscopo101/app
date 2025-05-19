# Diseño del Modelo de Datos y Flujo de Cotizaciones

## 1. Diagrama Entidad-Relación (Conceptual)

(Se omitirá un diagrama visual aquí, pero se describirán las entidades y sus relaciones)

## 2. Definición de Entidades (Tablas)

### 2.1. Tabla: `Usuarios`

-   **Propósito:** Almacena la información de los usuarios del sistema.
-   **Campos:**
    -   `id_usuario` (PK, INT, Autoincremental)
    -   `nombre_usuario` (VARCHAR(100), Not Null)
    -   `email` (VARCHAR(255), Not Null, Unique)
    -   `password_hash` (VARCHAR(255), Not Null)
    -   `rol` (ENUM('user', 'admin', 'tecnico'), Not Null)
    -   `fecha_creacion` (TIMESTAMP, Default CURRENT_TIMESTAMP)
    -   `activo` (BOOLEAN, Default True)

### 2.2. Tabla: `Clientes`

-   **Propósito:** Almacena la información de los clientes.
-   **Campos:**
    -   `id_cliente` (PK, INT, Autoincremental)
    -   `nombre_razon_social` (VARCHAR(255), Not Null)
    -   `rut_cliente` (VARCHAR(20), Not Null, Unique)
    -   `giro_cliente` (VARCHAR(255))
    -   `direccion_calle_numero` (VARCHAR(255))
    -   `comuna` (VARCHAR(100))
    -   `ciudad` (VARCHAR(100))
    -   `email_cliente` (VARCHAR(255))
    -   `telefono_cliente` (VARCHAR(50))
    -   `nombre_contacto` (VARCHAR(100))
    -   `fecha_registro` (TIMESTAMP, Default CURRENT_TIMESTAMP)

### 2.3. Tabla: `EmpresaConfig` (Singleton o tabla con una sola fila)

-   **Propósito:** Almacena la información de la empresa emisora de las cotizaciones.
-   **Campos:**
    -   `id_config` (PK, INT, Default 1)
    -   `nombre_empresa` (VARCHAR(255), Not Null)
    -   `rut_empresa` (VARCHAR(20), Not Null)
    -   `giro_empresa` (VARCHAR(255))
    -   `direccion_empresa` (VARCHAR(255))
    -   `email_empresa` (VARCHAR(255))
    -   `telefono_empresa` (VARCHAR(50))
    -   `logo_url` (VARCHAR(255)) (o almacenar como BLOB si es pequeño)
    -   `iva_porcentaje` (DECIMAL(5,2), Default 19.00)

### 2.4. Tabla: `Cotizaciones`

-   **Propósito:** Almacena la información principal de cada cotización.
-   **Campos:**
    -   `id_cotizacion` (PK, INT, Autoincremental)
    -   `numero_cotizacion` (VARCHAR(50), Not Null, Unique) (Ej: COT-2025-0001)
    -   `id_cliente` (FK, INT, Not Null, Refiere a `Clientes.id_cliente`)
    -   `id_usuario_creador` (FK, INT, Not Null, Refiere a `Usuarios.id_usuario`)
    -   `fecha_emision` (DATE, Not Null)
    -   `fecha_validez` (DATE)
    -   `titulo_asunto` (VARCHAR(255))
    -   `estado` (ENUM('Creada', 'Enviada', 'Aceptada', 'En Ejecucion', 'Entregada', 'Rechazada', 'Modificada', 'Cancelada'), Not Null, Default 'Creada')
    -   `subtotal_neto` (DECIMAL(15,2), Default 0.00)
    -   `descuento_general_porcentaje` (DECIMAL(5,2), Default 0.00)
    -   `monto_descuento_general` (DECIMAL(15,2), Default 0.00)
    -   `monto_neto_final` (DECIMAL(15,2), Default 0.00)
    -   `monto_iva` (DECIMAL(15,2), Default 0.00)
    -   `monto_total_cotizacion` (DECIMAL(15,2), Default 0.00)
    -   `forma_pago_descripcion` (TEXT)
    -   `tiempo_entrega_estimado` (VARCHAR(255))
    -   `validez_oferta_descripcion` (TEXT)
    -   `notas_adicionales` (TEXT)
    -   `fecha_creacion_registro` (TIMESTAMP, Default CURRENT_TIMESTAMP)
    -   `fecha_ultima_modificacion` (TIMESTAMP, Default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 2.5. Tabla: `ItemsCotizacion`

-   **Propósito:** Almacena los ítems detallados de cada cotización.
-   **Campos:**
    -   `id_item_cotizacion` (PK, INT, Autoincremental)
    -   `id_cotizacion` (FK, INT, Not Null, Refiere a `Cotizaciones.id_cotizacion`)
    -   `codigo_item` (VARCHAR(50))
    -   `descripcion_item` (TEXT, Not Null)
    -   `unidad_medida` (VARCHAR(50))
    -   `cantidad` (DECIMAL(10,2), Not Null)
    -   `precio_unitario` (DECIMAL(15,2), Not Null)
    -   `descuento_item_porcentaje` (DECIMAL(5,2), Default 0.00)
    -   `valor_total_item` (DECIMAL(15,2), Not Null) (Calculado: cantidad * precio_unitario * (1 - descuento_item_porcentaje/100))

### 2.6. Tabla: `Proyectos` (Opcional, si se quiere separar la gestión de ejecución del documento cotización)

-   **Propósito:** Gestionar la ejecución del trabajo una vez que la cotización es aceptada.
-   **Campos:**
    -   `id_proyecto` (PK, INT, Autoincremental)
    -   `id_cotizacion_origen` (FK, INT, Not Null, Unique, Refiere a `Cotizaciones.id_cotizacion`)
    -   `nombre_proyecto` (VARCHAR(255))
    -   `fecha_inicio_planificada` (DATE)
    -   `fecha_fin_planificada` (DATE)
    -   `fecha_inicio_real` (DATE)
    -   `fecha_fin_real` (DATE)
    -   `id_tecnico_asignado` (FK, INT, Refiere a `Usuarios.id_usuario`)
    -   `estado_proyecto` (ENUM('Pendiente', 'En Progreso', 'Completado', 'Suspendido', 'Cancelado'), Default 'Pendiente')
    -   `presupuesto_costo_equipos_estimado` (DECIMAL(15,2), Default 0.00)
    -   `presupuesto_costo_mano_obra_estimado` (DECIMAL(15,2), Default 0.00)
    -   `presupuesto_otros_gastos_estimado` (DECIMAL(15,2), Default 0.00)
    -   `costo_equipos_real` (DECIMAL(15,2), Default 0.00)
    -   `costo_mano_obra_real` (DECIMAL(15,2), Default 0.00)
    -   `costo_otros_gastos_real` (DECIMAL(15,2), Default 0.00)

### 2.7. Tabla: `PagosCliente`

-   **Propósito:** Registrar los pagos realizados por el cliente asociados a una cotización/proyecto.
-   **Campos:**
    -   `id_pago` (PK, INT, Autoincremental)
    -   `id_cotizacion` (FK, INT, Not Null, Refiere a `Cotizaciones.id_cotizacion`)
    -   `fecha_pago` (DATE, Not Null)
    -   `monto_pagado` (DECIMAL(15,2), Not Null)
    -   `metodo_pago` (VARCHAR(100)) (Ej: Transferencia, Efectivo, Cheque)
    -   `referencia_pago` (VARCHAR(255))
    -   `notas` (TEXT)

### 2.8. Tabla: `GastosProyecto` (Si se usa la tabla `Proyectos`)

-   **Propósito:** Registrar los gastos incurridos durante la ejecución de un proyecto.
-   **Campos:**
    -   `id_gasto` (PK, INT, Autoincremental)
    -   `id_proyecto` (FK, INT, Not Null, Refiere a `Proyectos.id_proyecto`)
    -   `fecha_gasto` (DATE, Not Null)
    -   `descripcion_gasto` (TEXT, Not Null)
    -   `tipo_gasto` (ENUM('Equipos/Materiales', 'Mano de Obra', 'Otros'), Not Null)
    -   `monto_gasto` (DECIMAL(15,2), Not Null)
    -   `id_proveedor` (FK, INT, Refiere a una futura tabla `Proveedores` - opcional)
    -   `documento_respaldo_url` (VARCHAR(255)) (Ej: factura de compra)

## 3. Relaciones Principales

-   `Usuarios` (1) -- (N) `Cotizaciones` (Un usuario crea muchas cotizaciones)
-   `Clientes` (1) -- (N) `Cotizaciones` (Un cliente puede tener muchas cotizaciones)
-   `Cotizaciones` (1) -- (N) `ItemsCotizacion` (Una cotización tiene muchos ítems)
-   `Cotizaciones` (1) -- (1) `Proyectos` (Una cotización aceptada genera un proyecto - si se implementa `Proyectos`)
-   `Cotizaciones` (1) -- (N) `PagosCliente` (Una cotización puede tener múltiples pagos)
-   `Proyectos` (1) -- (N) `GastosProyecto` (Un proyecto puede tener múltiples gastos - si se implementa `Proyectos`)
-   `Usuarios` (1) -- (N) `Proyectos` (Un técnico puede ser asignado a muchos proyectos - si se implementa `Proyectos`)

## 4. Flujo de Cotizaciones (Simplificado)

1.  **Creación:**
    *   Un `Usuario` (rol 'user' o 'admin') crea una nueva `Cotizacion`.
    *   Se asocia a un `Cliente` existente o se crea uno nuevo.
    *   Se añaden `ItemsCotizacion`.
    *   El sistema calcula subtotales, IVA y total.
    *   Estado inicial: 'Creada'.
2.  **Envío:**
    *   El `Usuario` cambia el estado a 'Enviada'.
    *   Se puede generar un PDF para enviar al cliente.
3.  **Aceptación/Rechazo:**
    *   Si el cliente acepta, el `Usuario` cambia el estado a 'Aceptada'.
        *   Se registra el primer pago en `PagosCliente` (ej. 50-60% anticipo).
        *   Opcional: Se crea una entrada en la tabla `Proyectos` (si existe), vinculada a la `Cotizacion`.
        *   Se actualizan los datos del presupuesto estimado en `Proyectos`.
    *   Si el cliente rechaza, el estado puede cambiar a 'Rechazada'.
4.  **Ejecución:**
    *   El estado de la `Cotizacion` (o `Proyecto`) cambia a 'En Ejecución'.
    *   El `Usuario` (rol 'tecnico' o 'admin') registra `GastosProyecto` (materiales, mano de obra).
    *   Se pueden registrar pagos adicionales del cliente en `PagosCliente` (según estados de avance o cuotas).
5.  **Entrega:**
    *   Una vez finalizado el trabajo, el estado cambia a 'Entregada'.
    *   Se registra el pago final del cliente (si aplica).
6.  **Reporte Final:**
    *   El sistema genera un PDF con toda la información del proyecto/cotización, incluyendo:
        *   Datos de la `Cotizacion` e `ItemsCotizacion`.
        *   Historial de `PagosCliente`.
        *   Resumen de `GastosProyecto` (comparativa estimado vs. real - visibilidad según rol).

## 5. Consideraciones Adicionales

-   **Seguridad:** Implementar hashing para contraseñas.
-   **Auditoría:** Considerar tablas de log para cambios importantes (ej. cambios de estado en cotizaciones).
-   **Notificaciones:** El sistema podría enviar notificaciones por email en ciertos eventos (ej. cotización aceptada).
-   **Productos/Servicios Predefinidos:** Una tabla `ProductosServicios` podría facilitar la creación de ítems en las cotizaciones.

Este diseño proporciona una base sólida para el desarrollo del sistema. Se refinará durante la implementación.
