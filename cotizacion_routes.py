from flask import Blueprint, request, jsonify, send_file, render_template # Added send_file, render_template
from src.models.user import db
from src.models.cotizacion import Cotizacion, EstadoCotizacionEnum
from src.models.cliente import Cliente
from src.models.item_cotizacion import ItemCotizacion
from src.models.empresa_config import EmpresaConfig
from src.models.user import User
from src.models.proyecto import Proyecto, EstadoProyectoEnum # Import Proyecto and its Enum
from src.models.pago_cliente import PagoCliente # Import PagoCliente
from src.models.gasto_proyecto import GastoProyecto, TipoGastoEnum # Import GastoProyecto and its Enum
from datetime import datetime
from decimal import Decimal
from src.utils.report_generator import preparar_datos_reporte # Import report data prep function
from weasyprint import HTML, CSS # Import WeasyPrint
import io # For sending file from memory

cotizacion_bp = Blueprint("cotizacion_bp", __name__)

def calculate_totals(cotizacion):
    """Helper function to calculate totals for a cotizacion."""
    subtotal_neto = Decimal("0.00")
    # Ensure items are loaded if accessed this way, or use cotizacion.items.all() if it's a dynamic loader
    for item in cotizacion.items: # Assuming items are already loaded or it's not dynamic here
        subtotal_neto += item.valor_total_item
    
    cotizacion.subtotal_neto = subtotal_neto
    
    if cotizacion.descuento_general_porcentaje is not None and cotizacion.descuento_general_porcentaje > 0:
        cotizacion.monto_descuento_general = subtotal_neto * (cotizacion.descuento_general_porcentaje / Decimal("100.0"))
    else:
        cotizacion.monto_descuento_general = Decimal("0.00")
        cotizacion.descuento_general_porcentaje = Decimal("0.00")

    cotizacion.monto_neto_final = cotizacion.subtotal_neto - cotizacion.monto_descuento_general
    
    config = EmpresaConfig.query.get(1)
    iva_rate = config.iva_porcentaje if config and config.iva_porcentaje is not None else Decimal("19.00")
    
    cotizacion.monto_iva = cotizacion.monto_neto_final * (iva_rate / Decimal("100.0"))
    cotizacion.monto_total_cotizacion = cotizacion.monto_neto_final + cotizacion.monto_iva

@cotizacion_bp.route("/cotizaciones", methods=["POST"])
def create_cotizacion():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    required_fields = ["id_cliente", "id_usuario_creador", "items"]
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing field: {field}"}), 400
    
    if not isinstance(data["items"], list) or not data["items"]:
        return jsonify({"error": "Items must be a non-empty list"}), 400

    cliente = Cliente.query.get(data["id_cliente"])
    if not cliente:
        return jsonify({"error": "Cliente not found"}), 404
    
    usuario_creador = User.query.get(data["id_usuario_creador"])
    if not usuario_creador:
        return jsonify({"error": "Usuario creador not found"}), 404

    try:
        last_cotizacion = Cotizacion.query.order_by(Cotizacion.id_cotizacion.desc()).first()
        next_id = (last_cotizacion.id_cotizacion + 1) if last_cotizacion else 1
        numero_cotizacion = f"COT-{datetime.now().year}-{next_id:04d}"

        new_cotizacion = Cotizacion(
            numero_cotizacion=numero_cotizacion,
            id_cliente=data["id_cliente"],
            id_usuario_creador=data["id_usuario_creador"],
            fecha_emision=datetime.strptime(data.get("fecha_emision"), "%Y-%m-%d").date() if data.get("fecha_emision") else datetime.utcnow().date(),
            fecha_validez=datetime.strptime(data.get("fecha_validez"), "%Y-%m-%d").date() if data.get("fecha_validez") else None,
            titulo_asunto=data.get("titulo_asunto"),
            estado=EstadoCotizacionEnum.CREADA,
            descuento_general_porcentaje=Decimal(data.get("descuento_general_porcentaje", "0.00")),
            forma_pago_descripcion=data.get("forma_pago_descripcion"),
            tiempo_entrega_estimado=data.get("tiempo_entrega_estimado"),
            validez_oferta_descripcion=data.get("validez_oferta_descripcion"),
            notas_adicionales=data.get("notas_adicionales")
        )

        db.session.add(new_cotizacion)
        db.session.flush()

        for item_data in data["items"]:
            if not all(k in item_data for k in ["descripcion_item", "cantidad", "precio_unitario"]):
                 db.session.rollback()
                 return jsonify({"error": "Missing fields in item_data"}), 400
            
            new_item = ItemCotizacion(
                id_cotizacion=new_cotizacion.id_cotizacion,
                codigo_item=item_data.get("codigo_item"),
                descripcion_item=item_data["descripcion_item"],
                unidad_medida=item_data.get("unidad_medida"),
                cantidad=Decimal(item_data["cantidad"]),
                precio_unitario=Decimal(item_data["precio_unitario"]),
                descuento_item_porcentaje=Decimal(item_data.get("descuento_item_porcentaje", "0.00"))
            )
            # new_cotizacion.items.append(new_item) # Alternative way if relationship is configured for it
            db.session.add(new_item)
        
        db.session.flush() # Ensure items are flushed to be accessible for calculate_totals
        calculate_totals(new_cotizacion)

        db.session.commit()
        return jsonify({"message": "Cotizacion created successfully", "id_cotizacion": new_cotizacion.id_cotizacion, "numero_cotizacion": new_cotizacion.numero_cotizacion}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@cotizacion_bp.route("/cotizaciones/<int:id_cotizacion>", methods=["GET"])
def get_cotizacion(id_cotizacion):
    cotizacion = Cotizacion.query.get_or_404(id_cotizacion)
    items_list = cotizacion.items.all() # Make sure to fetch all if it's dynamic
    items_data = [
        {
            "id_item_cotizacion": item.id_item_cotizacion,
            "codigo_item": item.codigo_item,
            "descripcion_item": item.descripcion_item,
            "unidad_medida": item.unidad_medida,
            "cantidad": float(item.cantidad),
            "precio_unitario": float(item.precio_unitario),
            "descuento_item_porcentaje": float(item.descuento_item_porcentaje),
            "valor_total_item": float(item.valor_total_item)
        } for item in items_list
    ]
    return jsonify({
        "id_cotizacion": cotizacion.id_cotizacion,
        "numero_cotizacion": cotizacion.numero_cotizacion,
        "id_cliente": cotizacion.id_cliente,
        "cliente_nombre": cotizacion.cliente.nombre_razon_social if cotizacion.cliente else None,
        "id_usuario_creador": cotizacion.id_usuario_creador,
        "usuario_creador_nombre": cotizacion.usuario_creador.nombre_usuario if cotizacion.usuario_creador else None,
        "fecha_emision": cotizacion.fecha_emision.isoformat() if cotizacion.fecha_emision else None,
        "fecha_validez": cotizacion.fecha_validez.isoformat() if cotizacion.fecha_validez else None,
        "titulo_asunto": cotizacion.titulo_asunto,
        "estado": cotizacion.estado.value,
        "subtotal_neto": float(cotizacion.subtotal_neto),
        "descuento_general_porcentaje": float(cotizacion.descuento_general_porcentaje),
        "monto_descuento_general": float(cotizacion.monto_descuento_general),
        "monto_neto_final": float(cotizacion.monto_neto_final),
        "monto_iva": float(cotizacion.monto_iva),
        "monto_total_cotizacion": float(cotizacion.monto_total_cotizacion),
        "forma_pago_descripcion": cotizacion.forma_pago_descripcion,
        "tiempo_entrega_estimado": cotizacion.tiempo_entrega_estimado,
        "validez_oferta_descripcion": cotizacion.validez_oferta_descripcion,
        "notas_adicionales": cotizacion.notas_adicionales,
        "fecha_creacion_registro": cotizacion.fecha_creacion_registro.isoformat(),
        "fecha_ultima_modificacion": cotizacion.fecha_ultima_modificacion.isoformat(),
        "items": items_data
    })

@cotizacion_bp.route("/cotizaciones/<int:id_cotizacion>/estado", methods=["PUT"])
def update_cotizacion_estado(id_cotizacion):
    cotizacion = Cotizacion.query.get_or_404(id_cotizacion)
    data = request.get_json()
    if not data or "estado" not in data:
        return jsonify({"error": "Missing 'estado' in request body"}), 400

    try:
        nuevo_estado_str = data["estado"]
        nuevo_estado = EstadoCotizacionEnum[nuevo_estado_str.upper().replace(" ", "_")]
    except KeyError:
        valid_states = [e.value for e in EstadoCotizacionEnum]
        return jsonify({"error": f"Invalid estado. Must be one of: {valid_states}"}), 400

    # Basic state transition validation (can be more complex)
    if cotizacion.estado == EstadoCotizacionEnum.ACEPTADA and nuevo_estado == EstadoCotizacionEnum.CREADA:
        return jsonify({"error": "Cannot revert ACEPTADA cotizacion to CREADA"}), 400
    # Add more rules as needed

    cotizacion.estado = nuevo_estado
    
    # If cotizacion is accepted, create a Proyecto if it doesn't exist
    if nuevo_estado == EstadoCotizacionEnum.ACEPTADA and not cotizacion.proyecto:
        proyecto_nombre = f"Proyecto para Cotización {cotizacion.numero_cotizacion}"
        if cotizacion.titulo_asunto:
            proyecto_nombre = f"Proyecto: {cotizacion.titulo_asunto[:100]} ({cotizacion.numero_cotizacion})"
        
        nuevo_proyecto = Proyecto(
            id_cotizacion_origen=cotizacion.id_cotizacion,
            nombre_proyecto=proyecto_nombre,
            estado_proyecto=EstadoProyectoEnum.PENDIENTE,
            # Copy estimated costs from cotizacion if logic exists, or set defaults
            # presupuesto_costo_equipos_estimado = ..., 
            # presupuesto_costo_mano_obra_estimado = ...
        )
        db.session.add(nuevo_proyecto)

    try:
        db.session.commit()
        return jsonify({"message": f"Cotizacion {id_cotizacion} estado updated to {nuevo_estado.value}"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@cotizacion_bp.route("/cotizaciones/<int:id_cotizacion>/reporte", methods=["GET"])
def generar_reporte_pdf_route(id_cotizacion):
    report_data = preparar_datos_reporte(id_cotizacion)
    if not report_data:
        return jsonify({"error": "Cotizacion not found or error preparing data"}), 404

    try:
        html_string = render_template("report_template.html", **report_data)
        # The default CSS is now inside report_template.html <style> tags
        pdf_bytes = HTML(string=html_string).write_pdf()
        
        pdf_filename = f"Reporte_Cotizacion_{report_data['cotizacion'].numero_cotizacion}.pdf"
        
        return send_file(
            io.BytesIO(pdf_bytes),
            mimetype="application/pdf",
            as_attachment=True,
            download_name=pdf_filename
        )
    except Exception as e:
        # Log the exception e for debugging
        print(f"Error generating PDF: {e}")
        return jsonify({"error": "Could not generate PDF report", "details": str(e)}), 500

# TODO: Add routes for:
# - Listing all cotizaciones (GET /cotizaciones) with filtering/pagination
# - Updating a full cotizacion (PUT /cotizaciones/<id_cotizacion>)
# - Deleting a cotizacion (DELETE /cotizaciones/<id_cotizacion>) (soft delete recommended)
# - Routes for Pagos (POST, GET for a cotizacion)
# - Routes for Proyectos (GET, PUT for updates like tecnico asignado, estado, costos reales)
# - Routes for GastosProyecto (POST, GET for a proyecto)
# - Routes for Clientes (CRUD)
# - Routes for EmpresaConfig (GET, PUT - though likely initialized once)

