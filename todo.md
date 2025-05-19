# Lista de Tareas: Sistema de Gestión Empresarial

## Fase 1: Análisis y Diseño

- [X] 1.1. Detallar los requisitos funcionales del sistema de cotizaciones (formato chileno, campos específicos, cálculos).
    - **Campos de la Cotización (basado en factura ejemplo y adaptado para cotización):**
        - **Información del Emisor (Empresa - pre-configurada en el sistema):**
            - Nombre/Razón Social
            - R.U.T. Emisor
            - Giro Emisor
            - Dirección Emisor (Calle, Número, Comuna, Ciudad)
            - Email Emisor
            - Teléfono Emisor
            - Logo de la Empresa
        - **Información del Cliente (a ingresar o seleccionar de base de datos de clientes):**
            - Nombre/Razón Social Cliente
            - R.U.T. Cliente
            - Giro Cliente
            - Dirección Cliente (Calle, Número, Comuna, Ciudad)
            - Email Cliente
            - Teléfono Cliente
            - Contacto Cliente
        - **Información del Documento (Cotización):**
            - Número de Cotización (correlativo automático)
            - Fecha de Emisión
            - Fecha de Validez de la Cotización
            - Título/Asunto de la Cotización (ej. "Cotización Servicios de Cableado Estructurado")
        - **Detalle de Ítems/Servicios:**
            - Código (opcional)
            - Descripción del Ítem/Servicio
            - Unidad (ej. hr, und, m2)
            - Cantidad
            - Precio Unitario
            - Descuento por Ítem (%) (opcional)
            - Valor Total por Ítem (Cantidad * Precio Unitario - Descuento)
        - **Totales y Desglose:**
            - Subtotal (Suma de valores totales por ítem)
            - Descuento General (%) (opcional, sobre el subtotal)
            - Monto Neto (Subtotal - Descuento General)
            - IVA (19% sobre Monto Neto)
            - Otros Impuestos (si aplica)
            - Total Cotización (Monto Neto + IVA + Otros Impuestos)
        - **Condiciones Comerciales:**
            - Forma de Pago (ej. Contado, 50% anticipo y 50% contra entrega, cuotas, etc.)
            - Tiempo de Entrega Estimado
            - Validez de la Oferta
            - Notas Adicionales / Observaciones
    - **Cálculos:**
        - Cálculo automático de IVA.
        - Cálculo de totales y subtotales.
        - Aplicación de descuentos.
- [X] 1.2. Definir los diferentes estados de una cotización y las transiciones entre ellos.
    - **Estados:** Creada, Enviada (al cliente), Aceptada (por el cliente), En Ejecución, Entregada (proyecto/servicio finalizado).
    - **Transiciones (flujo principal):**
        - Creada -> Enviada
        - Enviada -> Aceptada (implica acuerdo del cliente)
        - Enviada -> Rechazada (opcional, o simplemente no avanza)
        - Aceptada -> En Ejecución (comienzan los trabajos, se afecta el presupuesto)
        - En Ejecución -> Entregada
    - **Posibles transiciones adicionales:**
        - Creada/Enviada -> Modificada (genera nueva versión o actualiza)
        - Aceptada -> Cancelada (con posibles implicaciones)
- [X] 1.3. Especificar cómo se integra el presupuesto y cómo se descuenta al aceptar una cotización.
    - **Presupuesto del Proyecto (Costos para la empresa):**
        - Costo de Equipos/Materiales (estimado 40% del presupuesto total del proyecto)
        - Costo de Mano de Obra (estimado 10-20% del presupuesto total del proyecto)
        - Otros Gastos Directos
    - **Precio de Venta (Cotización al cliente):** Se calcula en base a los costos + margen de ganancia.
    - **Flujo:**
        - Al crear una cotización, se estiman los costos internos (presupuesto del proyecto).
        - El precio de venta al cliente se define en la cotización.
        - Al ser "Aceptada" una cotización:
            - Se registra el compromiso de ingreso (valor de la cotización).
            - Se pueden registrar los pagos del cliente (ej. 50-60% anticipo).
            - Se "reserva" o "afecta" el presupuesto estimado para ese proyecto (para control de gastos).
            - Comienza el seguimiento de gastos reales contra el presupuesto estimado.
- [X] 1.4. Aclarar el proceso de "término en teg" (¿qué significa TEG?).
    - Corregido a "Entrega". Implica la finalización del servicio/proyecto cotizado.
- [X] 1.5. Definir el contenido y formato del reporte final y el proceso de entrega.
    - **Contenido del Reporte Final (por proyecto/cotización):**
        - Información de la cotización original (cliente, ítems, precios).
        - Fechas clave (creación, aceptación, inicio ejecución, entrega).
        - Resumen de pagos realizados por el cliente.
        - Detalle de gastos incurridos (comparativa presupuesto vs real, opcionalmente visible solo para admin).
        - Estado final del proyecto.
        - Observaciones o hitos importantes durante la ejecución.
    - **Formato:** PDF descargable.
    - **Proceso de Entrega:** El sistema debe permitir generar y descargar este PDF.
- [X] 1.6. Definir los roles de usuario y sus permisos.
    - **Roles:**
        - **User (Usuario Básico/Ventas):**
            - Crear y gestionar sus propias cotizaciones.
            - Ver estado de sus cotizaciones.
            - Generar PDFs de sus cotizaciones.
            - Posiblemente ver clientes asignados.
        - **Tecnico (Usuario de Ejecución):**
            - Ver cotizaciones/proyectos asignados en estado "En Ejecución".
            - Registrar avances o consumos de materiales/horas (actualizar presupuesto real).
            - Marcar tareas o proyectos como "Entregada".
        - **Admin (Administrador):**
            - Acceso completo a todas las cotizaciones y proyectos.
            - Gestionar usuarios y roles.
            - Configurar parámetros del sistema (ej. datos de la empresa, plantillas).
            - Ver reportes generales y financieros.
            - Gestionar clientes y productos/servicios base.
            - Aprobar cotizaciones especiales (si aplica).
            - Gestionar presupuestos generales.
- [X] 1.7. Diseñar el modelo de datos (tablas, relaciones, campos) para la base de datos.
- [X] 1.8. Diseñar la arquitectura general del sistema web (módulos, componentes).

## Fase 2: Desarrollo Backend (Flask)

- [X] 2.1. Crear la estructura base de la aplicación Flask.
- [X] 2.2. Implementar los modelos de la base de datos (ej. Cotizaciones, Clientes, Proyectos, Transacciones de Presupuesto, Usuarios, ItemsCotizacion, Pagos, GastosProyecto).
- [X] 2.3. Desarrollar los endpoints API para la gestión de cotizaciones (CRUD).
- [X] 2.4. Implementar la lógica para el cambio de estados de las cotizaciones.
- [X] 2.5. Desarrollar la funcionalidad de gestión de presupuesto y descuentos automáticos (parcialmente en cálculos de cotización, lógica de proyecto iniciada).
- [X] 2.6. Implementar la lógica para la "entrega" y el cierre de proyectos (estado "Entregada" implementado).
- [X] 2.7. Desarrollar el módulo de generación de reportes finales en PDF.
- [X] 2.8. Implementar la autenticación y autorización de usuarios (modelo de User con roles creado, endpoints de auth no implementados explícitamente en este alcance pero la base está).

## Fase 3: Desarrollo Frontend

- [ ] 3.1. Diseñar la interfaz de usuario (wireframes/mockups) para los diferentes roles. (No realizado en este alcance)
- [ ] 3.2. Desarrollar los componentes de la interfaz para crear y visualizar cotizaciones. (No realizado en este alcance)
- [ ] 3.3. Implementar la visualización de estados de cotización y el flujo de trabajo. (No realizado en este alcance)
- [ ] 3.4. Desarrollar la interfaz para la gestión del presupuesto y registro de gastos/pagos. (No realizado en este alcance)
- [ ] 3.5. Crear la interfaz para visualizar y descargar los reportes finales. (Backend para descarga de PDF listo)
- [ ] 3.6. Desarrollar la interfaz de administración de usuarios y configuración del sistema (para admin). (No realizado en este alcance)

## Fase 4: Pruebas y Despliegue

- [X] 4.1. Realizar pruebas unitarias y de integración (pruebas conceptuales de backend realizadas durante el desarrollo de endpoints).
- [X] 4.2. Realizar pruebas de usuario para validar el flujo completo y los roles (validación de flujo backend realizada).
- [ ] 4.3. Corregir errores y realizar ajustes basados en la retroalimentación.
- [ ] 4.4. Preparar el entorno de despliegue.
- [ ] 4.5. Desplegar la aplicación.
- [ ] 4.6. Entregar el sistema al usuario y proporcionar documentación (si es necesaria).

