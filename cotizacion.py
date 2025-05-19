from enum import Enum as PyEnum
from sqlalchemy.sql import func
from src.models.user import db # Assuming db is initialized in a central models.py or user.py
# Ensure other related models are imported if direct relationships are defined here
# from src.models.cliente import Cliente
# from src.models.user import User

class EstadoCotizacionEnum(PyEnum):
    CREADA = "Creada"
    ENVIADA = "Enviada"
    ACEPTADA = "Aceptada"
    EN_EJECUCION = "En Ejecucion"
    ENTREGADA = "Entregada"
    RECHAZADA = "Rechazada"
    MODIFICADA = "Modificada" # For new versions or updates
    CANCELADA = "Cancelada"

class Cotizacion(db.Model):
    __tablename__ = "cotizaciones"

    id_cotizacion = db.Column(db.Integer, primary_key=True, autoincrement=True)
    numero_cotizacion = db.Column(db.String(50), nullable=False, unique=True)
    id_cliente = db.Column(db.Integer, db.ForeignKey("clientes.id_cliente"), nullable=False)
    id_usuario_creador = db.Column(db.Integer, db.ForeignKey("usuarios.id_usuario"), nullable=False)
    
    fecha_emision = db.Column(db.Date, nullable=False, default=func.current_date())
    fecha_validez = db.Column(db.Date)
    titulo_asunto = db.Column(db.String(255))
    
    estado = db.Column(db.Enum(EstadoCotizacionEnum), nullable=False, default=EstadoCotizacionEnum.CREADA)
    
    subtotal_neto = db.Column(db.Numeric(15,2), default=0.00)
    descuento_general_porcentaje = db.Column(db.Numeric(5,2), default=0.00)
    monto_descuento_general = db.Column(db.Numeric(15,2), default=0.00)
    monto_neto_final = db.Column(db.Numeric(15,2), default=0.00) # subtotal_neto - monto_descuento_general
    monto_iva = db.Column(db.Numeric(15,2), default=0.00)
    monto_total_cotizacion = db.Column(db.Numeric(15,2), default=0.00) # monto_neto_final + monto_iva
    
    forma_pago_descripcion = db.Column(db.Text)
    tiempo_entrega_estimado = db.Column(db.String(255))
    validez_oferta_descripcion = db.Column(db.Text)
    notas_adicionales = db.Column(db.Text)
    
    fecha_creacion_registro = db.Column(db.TIMESTAMP, server_default=func.now())
    fecha_ultima_modificacion = db.Column(db.TIMESTAMP, server_default=func.now(), onupdate=func.now())

    # Relationships
    cliente = db.relationship("Cliente", backref=db.backref("cotizaciones", lazy=True))
    usuario_creador = db.relationship("User", backref=db.backref("cotizaciones_creadas", lazy=True))
    items = db.relationship("ItemCotizacion", backref="cotizacion", lazy="dynamic", cascade="all, delete-orphan")
    pagos = db.relationship("PagoCliente", backref="cotizacion", lazy="dynamic", cascade="all, delete-orphan")
    # proyecto = db.relationship("Proyecto", backref="cotizacion_origen", uselist=False, cascade="all, delete-orphan") # If one-to-one

    def __repr__(self):
        return f'<Cotizacion {self.numero_cotizacion}>'

