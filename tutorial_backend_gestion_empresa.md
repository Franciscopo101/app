# Tutorial: Instalación, Configuración y Pruebas del Backend del Sistema de Gestión Empresarial

Este tutorial le guiará a través de los pasos para instalar, configurar y probar el backend de la aplicación Flask para el sistema de gestión empresarial.

## 1. Requisitos Previos

Antes de comenzar, asegúrese de tener instalado lo siguiente en su sistema:

*   **Python 3.9+:** Puede descargarlo desde [python.org](https://www.python.org/).
*   **pip:** Generalmente se instala con Python. Asegúrese de que esté actualizado (`python -m pip install --upgrade pip`).
*   **MySQL Server:** Necesitará una instancia de MySQL en ejecución. Puede descargarlo desde [mysql.com](https://www.mysql.com/downloads/).
*   **Git (Opcional):** Si desea clonar el repositorio (no aplicable aquí ya que se entregó un .tar.gz).
*   **Herramienta para probar APIs (Recomendado):** Como [Postman](https://www.postman.com/downloads/) o `curl` (disponible en la mayoría de los sistemas Unix-like y en Windows a través de Git Bash o WSL).

## 2. Obtención y Descompresión del Código Fuente

1.  Usted recibió el archivo `gestion_empresa_app_backend.tar.gz`.
2.  Guarde este archivo en un directorio de su elección.
3.  Abra una terminal o línea de comandos.
4.  Navegue al directorio donde guardó el archivo.
5.  Descomprima el archivo usando el siguiente comando:
    ```bash
    tar -xzvf gestion_empresa_app_backend.tar.gz
    ```
    Esto creará un directorio llamado `gestion_empresa_app` con todo el código fuente.
6.  Navegue dentro del directorio de la aplicación:
    ```bash
    cd gestion_empresa_app
    ```

## 3. Configuración del Entorno Virtual y Dependencias

Es una buena práctica usar un entorno virtual para aislar las dependencias del proyecto.

1.  **Crear el entorno virtual:**
    El proyecto ya incluye un entorno virtual `venv` creado con el comando `python3 -m venv venv` (o similar). Si por alguna razón necesita recrearlo:
    ```bash
    # python3 -m venv venv # (Si no existiera o quisiera recrearlo)
    ```
2.  **Activar el entorno virtual:**
    *   En Linux o macOS:
        ```bash
        source venv/bin/activate
        ```
    *   En Windows (Git Bash o cmd/PowerShell):
        ```bash
        venv\Scripts\activate
        ```
    Debería ver el nombre del entorno virtual (por ejemplo, `(venv)`) al principio de la línea de comandos.

3.  **Instalar las dependencias:**
    Las dependencias están listadas en `requirements.txt` y ya deberían estar instaladas dentro del `venv` proporcionado. Si necesita reinstalarlas o verificar:
    ```bash
    pip install -r requirements.txt
    ```

## 4. Configuración de la Base de Datos MySQL

La aplicación necesita conectarse a una base de datos MySQL.

1.  **Asegúrese de que MySQL Server esté en ejecución.**
2.  **Crear la base de datos:**
    Necesitará crear una base de datos para la aplicación. El nombre por defecto es `gestion_empresa_db`. Puede crearla usando un cliente MySQL (como MySQL Workbench, DBeaver, o la línea de comandos `mysql`):
    ```sql
    CREATE DATABASE gestion_empresa_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    ```
3.  **Usuario de la Base de Datos (Opcional pero recomendado):**
    Es recomendable tener un usuario específico para la aplicación en lugar de usar `root`. Si crea uno:
    ```sql
    CREATE USER 'nombre_usuario_app'@'localhost' IDENTIFIED BY 'su_contraseña_segura';
    GRANT ALL PRIVILEGES ON gestion_empresa_db.* TO 'nombre_usuario_app'@'localhost';
    FLUSH PRIVILEGES;
    ```
    Reemplace `nombre_usuario_app` y `su_contraseña_segura`.

4.  **Configurar la Conexión en la Aplicación:**
    La aplicación obtiene la configuración de la base de datos desde el archivo `src/main.py` o mediante variables de entorno.

    *   **Opción A: Modificar `src/main.py` (menos recomendado para producción):**
        Abra el archivo `/home/ubuntu/gestion_empresa_app/src/main.py` (o la ruta equivalente en su sistema).
        Busque la línea:
        ```python
        app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{os.getenv('DB_USERNAME', 'root')}:{os.getenv('DB_PASSWORD', 'password')}@{os.getenv('DB_HOST', 'localhost')}:{os.getenv('DB_PORT', '3306')}/{os.getenv('DB_NAME', 'gestion_empresa_db')}"
        ```
        Puede cambiar los valores por defecto (`'root'`, `'password'`, `'localhost'`, `'3306'`, `'gestion_empresa_db'`) directamente si no va a usar variables de entorno.

    *   **Opción B: Usar Variables de Entorno (Recomendado):**
        Antes de ejecutar la aplicación, configure las siguientes variables de entorno en su terminal (los valores son ejemplos):
        ```bash
        export DB_USERNAME='root' # o su usuario de app
        export DB_PASSWORD='password' # o su contraseña segura
        export DB_HOST='localhost'
        export DB_PORT='3306'
        export DB_NAME='gestion_empresa_db'
        ```
        En Windows (cmd):
        ```cmd
        set DB_USERNAME=root
        set DB_PASSWORD=password
        REM ... y así sucesivamente
        ```

## 5. Ejecución de la Aplicación Backend

Una vez que el entorno virtual está activado y la base de datos configurada:

1.  Asegúrese de estar en el directorio raíz del proyecto (`gestion_empresa_app`).
2.  Ejecute la aplicación Flask:
    ```bash
    python3 src/main.py
    ```
    Debería ver una salida similar a esta, indicando que el servidor de desarrollo está en ejecución:
    ```
     * Serving Flask app 'main' (lazy loading)
     * Environment: development
     * Debug mode: on
     * Running on http://0.0.0.0:5000 (Press CTRL+C to quit)
     * Restarting with stat
     * Debugger is active!
     * Debugger PIN: ...
    ```
    La aplicación creará automáticamente las tablas en la base de datos `gestion_empresa_db` si no existen.
    El backend estará escuchando en `http://localhost:5000`.

## 6. Pruebas de los Endpoints de la API

Puede usar `curl` o Postman para probar los endpoints. Todos los endpoints de la API están bajo el prefijo `/api`.

**Datos Iniciales Necesarios:**

*   **Configuración de Empresa:** La aplicación espera una fila en `empresa_config`. Puede insertarla manualmente en MySQL o crear un endpoint para ello (no incluido en el alcance actual). Para pruebas, inserte una fila:
    ```sql
    INSERT INTO empresa_config (id_config, nombre_empresa, rut_empresa, iva_porcentaje) VALUES (1, 'Mi Empresa Ejemplo', '76.000.000-K', 19.00);
    ```
*   **Usuario:** Necesitará un `id_usuario_creador`. Puede insertar un usuario manualmente o crear un endpoint de registro (no incluido en el alcance actual). Para pruebas:
    ```sql
    INSERT INTO usuarios (nombre_usuario, email, password_hash, rol) VALUES ('Usuario Prueba', 'test@example.com', 'hashed_password', 'USER');
    -- Anote el id_usuario generado.
    ```
*   **Cliente:** Necesitará un `id_cliente`. Puede insertar un cliente manualmente o crear un endpoint CRUD (no incluido en el alcance actual). Para pruebas:
    ```sql
    INSERT INTO clientes (nombre_razon_social, rut_cliente) VALUES ('Cliente de Prueba SA', '77.111.222-3');
    -- Anote el id_cliente generado.
    ```

**Ejemplos de Pruebas (reemplace `ID_USUARIO_CREADOR` y `ID_CLIENTE` con los IDs reales de su base de datos):**

### 6.1. Crear una Cotización

*   **Endpoint:** `POST /api/cotizaciones`
*   **Método:** `POST`
*   **Headers:** `Content-Type: application/json`
*   **Body (JSON):**
    ```json
    {
        "id_cliente": 1, // Reemplace con su ID_CLIENTE
        "id_usuario_creador": 1, // Reemplace con su ID_USUARIO_CREADOR
        "fecha_emision": "2025-05-15",
        "fecha_validez": "2025-06-15",
        "titulo_asunto": "Servicio de Desarrollo Web Básico",
        "descuento_general_porcentaje": "5.00",
        "forma_pago_descripcion": "50% Anticipo, 50% Contra Entrega",
        "tiempo_entrega_estimado": "4 semanas",
        "validez_oferta_descripcion": "Oferta válida por 30 días",
        "notas_adicionales": "Incluye diseño responsivo.",
        "items": [
            {
                "descripcion_item": "Diseño y Maquetación HTML/CSS",
                "cantidad": "40",
                "precio_unitario": "25.00",
                "unidad_medida": "hr",
                "descuento_item_porcentaje": "0.00"
            },
            {
                "descripcion_item": "Desarrollo Backend Básico (CMS)",
                "cantidad": "60",
                "precio_unitario": "30.00",
                "unidad_medida": "hr"
            }
        ]
    }
    ```
*   **Respuesta Esperada (201):**
    ```json
    {
        "message": "Cotizacion created successfully",
        "id_cotizacion": N, // ID de la nueva cotización
        "numero_cotizacion": "COT-YYYY-NNNN" // Número de la nueva cotización
    }
    ```
    Anote el `id_cotizacion` y `numero_cotizacion` para las siguientes pruebas.

### 6.2. Obtener una Cotización

*   **Endpoint:** `GET /api/cotizaciones/<id_cotizacion>` (reemplace `<id_cotizacion>` con el ID obtenido)
*   **Método:** `GET`
*   **Respuesta Esperada (200):** Un JSON con los detalles completos de la cotización.

### 6.3. Actualizar Estado de una Cotización

*   **Endpoint:** `PUT /api/cotizaciones/<id_cotizacion>/estado`
*   **Método:** `PUT`
*   **Headers:** `Content-Type: application/json`
*   **Body (JSON):**
    ```json
    {
        "estado": "Enviada" // Otros estados: Aceptada, En Ejecucion, Entregada, etc.
    }
    ```
*   **Respuesta Esperada (200):**
    ```json
    {
        "message": "Cotizacion <id_cotizacion> estado updated to Enviada"
    }
    ```
    Si cambia el estado a `Aceptada`, se creará automáticamente un registro en la tabla `proyectos` asociado a esta cotización.

### 6.4. Generar Reporte PDF de una Cotización

*   **Endpoint:** `GET /api/cotizaciones/<id_cotizacion>/reporte`
*   **Método:** `GET`
*   **Acción:** Esto descargará un archivo PDF. Si usa Postman, podrá guardar la respuesta como un archivo. Si usa `curl`:
    ```bash
    curl -o reporte_cotizacion.pdf http://localhost:5000/api/cotizaciones/<id_cotizacion>/reporte
    ```
    Esto guardará el PDF como `reporte_cotizacion.pdf`.

## 7. Detener la Aplicación

Para detener el servidor de desarrollo Flask, vuelva a la terminal donde se está ejecutando y presione `CTRL+C`.

Para desactivar el entorno virtual:
```bash
deactivate
```

Este tutorial cubre los aspectos básicos para poner en marcha y probar el backend. Para funcionalidades más avanzadas o un frontend, se requeriría desarrollo adicional.

