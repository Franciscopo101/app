from enum import Enum as PyEnum
from sqlalchemy.sql import func
from src.models.user import db # Assuming db is initialized in a central models.py or user.py
# from src.models.proyecto import Proyecto # For ForeignKey

class TipoGastoEnum(PyEnum):
    EQUIPOS_MATERIALES = "Equipos/Materiales"
    MANO_DE_OBRA = "Mano de Obra"
    OTROS = "Otros"

class GastoProyecto(db.Model):
    __tablename__ = "gastos_proyecto"

    id_gasto = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_proyecto = db.Column(db.Integer, db.ForeignKey("proyectos.id_proyecto"), nullable=False)
    
    fecha_gasto = db.Column(db.Date, nullable=False, default=func.current_date())
    descripcion_gasto = db.Column(db.Text, nullable=False)
    tipo_gasto = db.Column(db.Enum(TipoGastoEnum), nullable=False)
    monto_gasto = db.Column(db.Numeric(15,2), nullable=False)
    
    # id_proveedor = db.Column(db.Integer, db.ForeignKey("proveedores.id_proveedor"), nullable=True) # Optional, if a Proveedores table exists
    documento_respaldo_url = db.Column(db.String(255)) # e.g., path to scanned invoice
    fecha_registro = db.Column(db.TIMESTAMP, server_default=func.now())

    # Relationship (backref is defined in Proyecto model)
    # proyecto = db.relationship("Proyecto", backref=db.backref("gastos", lazy="dynamic"))

    def __repr__(self):
        return f'<GastoProyecto {self.id_gasto} - Proy: {self.id_proyecto} - Monto: {self.monto_gasto}>'

