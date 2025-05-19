from enum import Enum as PyEnum
from sqlalchemy.sql import func
from src.models.user import db # Assuming db is initialized in a central models.py or user.py
# from src.models.cotizacion import Cotizacion # For ForeignKey
# from src.models.user import User # For ForeignKey

class EstadoProyectoEnum(PyEnum):
    PENDIENTE = "Pendiente"
    EN_PROGRESO = "En Progreso"
    COMPLETADO = "Completado"
    SUSPENDIDO = "Suspendido"
    CANCELADO = "Cancelado"

class Proyecto(db.Model):
    __tablename__ = "proyectos"

    id_proyecto = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_cotizacion_origen = db.Column(db.Integer, db.ForeignKey("cotizaciones.id_cotizacion"), nullable=False, unique=True)
    nombre_proyecto = db.Column(db.String(255))
    
    fecha_inicio_planificada = db.Column(db.Date)
    fecha_fin_planificada = db.Column(db.Date)
    fecha_inicio_real = db.Column(db.Date)
    fecha_fin_real = db.Column(db.Date)
    
    id_tecnico_asignado = db.Column(db.Integer, db.ForeignKey("usuarios.id_usuario"), nullable=True) # A project might not have a technician assigned initially
    
    estado_proyecto = db.Column(db.Enum(EstadoProyectoEnum), nullable=False, default=EstadoProyectoEnum.PENDIENTE)
    
    presupuesto_costo_equipos_estimado = db.Column(db.Numeric(15,2), default=0.00)
    presupuesto_costo_mano_obra_estimado = db.Column(db.Numeric(15,2), default=0.00)
    presupuesto_otros_gastos_estimado = db.Column(db.Numeric(15,2), default=0.00)
    
    costo_equipos_real = db.Column(db.Numeric(15,2), default=0.00)
    costo_mano_obra_real = db.Column(db.Numeric(15,2), default=0.00)
    costo_otros_gastos_real = db.Column(db.Numeric(15,2), default=0.00)

    fecha_creacion_registro = db.Column(db.TIMESTAMP, server_default=func.now())
    fecha_ultima_modificacion = db.Column(db.TIMESTAMP, server_default=func.now(), onupdate=func.now())

    # Relationships
    cotizacion_origen = db.relationship("Cotizacion", backref=db.backref("proyecto", uselist=False, cascade="all, delete-orphan"))
    tecnico_asignado = db.relationship("User", backref=db.backref("proyectos_asignados", lazy=True), foreign_keys=[id_tecnico_asignado])
    gastos = db.relationship("GastoProyecto", backref="proyecto", lazy="dynamic", cascade="all, delete-orphan")

    @property
    def presupuesto_total_estimado(self):
        return (self.presupuesto_costo_equipos_estimado or 0) + \
               (self.presupuesto_costo_mano_obra_estimado or 0) + \
               (self.presupuesto_otros_gastos_estimado or 0)

    @property
    def costo_total_real(self):
        return (self.costo_equipos_real or 0) + \
               (self.costo_mano_obra_real or 0) + \
               (self.costo_otros_gastos_real or 0)

    def __repr__(self):
        return f'<Proyecto {self.nombre_proyecto or self.id_proyecto}>'

