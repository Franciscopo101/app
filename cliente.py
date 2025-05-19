from src.models.user import db # Import db from a central place if not already done
from sqlalchemy.sql import func

class Cliente(db.Model):
    __tablename__ = "clientes"

    id_cliente = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nombre_razon_social = db.Column(db.String(255), nullable=False)
    rut_cliente = db.Column(db.String(20), nullable=False, unique=True)
    giro_cliente = db.Column(db.String(255))
    direccion_calle_numero = db.Column(db.String(255))
    comuna = db.Column(db.String(100))
    ciudad = db.Column(db.String(100))
    email_cliente = db.Column(db.String(255))
    telefono_cliente = db.Column(db.String(50))
    nombre_contacto = db.Column(db.String(100))
    fecha_registro = db.Column(db.TIMESTAMP, server_default=func.now())

    # Relationship: A client can have multiple quotations
    # cotizaciones = db.relationship("Cotizacion", backref="cliente_ref", lazy=True)

    def __repr__(self):
        return f'<Cliente {self.nombre_razon_social}>'

