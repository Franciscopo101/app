from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import func
from enum import Enum as PyEnum

db = SQLAlchemy()

class RolesEnum(PyEnum):
    USER = "user"
    ADMIN = "admin"
    TECNICO = "tecnico"

class User(db.Model):
    __tablename__ = "usuarios"

    id_usuario = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nombre_usuario = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)
    rol = db.Column(db.Enum(RolesEnum), nullable=False, default=RolesEnum.USER)
    fecha_creacion = db.Column(db.TIMESTAMP, server_default=func.now())
    activo = db.Column(db.Boolean, default=True)

    # Relationships (to be defined later if needed, e.g., cotizaciones_creadas)
    # cotizaciones_creadas = db.relationship('Cotizacion', backref='creador', lazy=True, foreign_keys='Cotizacion.id_usuario_creador')
    # proyectos_asignados = db.relationship('Proyecto', backref='tecnico_asignado_ref', lazy=True, foreign_keys='Proyecto.id_tecnico_asignado')


    def __repr__(self):
        return f'<User {self.nombre_usuario}>'

