from sqlalchemy.sql import func
from src.models.user import db # Assuming db is initialized in a central models.py or user.py

class PagoCliente(db.Model):
    __tablename__ = "pagos_cliente"

    id_pago = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_cotizacion = db.Column(db.Integer, db.ForeignKey("cotizaciones.id_cotizacion"), nullable=False)
    
    fecha_pago = db.Column(db.Date, nullable=False, default=func.current_date())
    monto_pagado = db.Column(db.Numeric(15,2), nullable=False)
    metodo_pago = db.Column(db.String(100)) # e.g., Transferencia, Efectivo, Cheque
    referencia_pago = db.Column(db.String(255)) # e.g., Transaction ID, Cheque No.
    notas = db.Column(db.Text)
    fecha_registro = db.Column(db.TIMESTAMP, server_default=func.now())

    # Relationship (backref is defined in Cotizacion model)
    # cotizacion = db.relationship("Cotizacion", backref=db.backref("pagos", lazy="dynamic"))

    def __repr__(self):
        return f'<PagoCliente {self.id_pago} - Cot: {self.id_cotizacion} - Monto: {self.monto_pagado}>'

