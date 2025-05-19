from flask import render_template # Keep render_template
from src.models.cotizacion import Cotizacion
from src.models.empresa_config import EmpresaConfig
from datetime import datetime

# DEFAULT_CSS is defined in report_template.html via <style> tag for simplicity with WeasyPrint

def preparar_datos_reporte(id_cotizacion):
    cotizacion = Cotizacion.query.get(id_cotizacion)
    if not cotizacion:
        return None # Or raise an error

    empresa_config = EmpresaConfig.query.get(1) # Assuming singleton config

    # Prepare data for the template
    data = {
        "cotizacion": cotizacion,
        "cliente": cotizacion.cliente,
        "items": cotizacion.items.all(), # Ensure all items are fetched if lazy='dynamic'
        "pagos": cotizacion.pagos.all() if cotizacion.pagos else [], # Handle if no pagos
        "proyecto": cotizacion.proyecto, 
        "gastos_proyecto": cotizacion.proyecto.gastos.all() if cotizacion.proyecto and cotizacion.proyecto.gastos else [],
        "empresa": empresa_config,
        "fecha_generacion": datetime.now()
    }
    return data

# The PDF generation using WeasyPrint will be in the route that has app context.
# This function now only prepares data. The HTML rendering will also happen in the route.

