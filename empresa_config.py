from src.models.user import db # Assuming db is initialized in user.py or a central models.py
from sqlalchemy.sql import func

class EmpresaConfig(db.Model):
    __tablename__ = "empresa_config"

    id_config = db.Column(db.Integer, primary_key=True, default=1)
    nombre_empresa = db.Column(db.String(255), nullable=False)
    rut_empresa = db.Column(db.String(20), nullable=False)
    giro_empresa = db.Column(db.String(255))
    direccion_empresa = db.Column(db.String(255))
    email_empresa = db.Column(db.String(255))
    telefono_empresa = db.Column(db.String(50))
    logo_url = db.Column(db.String(255)) # Path to logo or base64 string
    iva_porcentaje = db.Column(db.Numeric(5,2), default=19.00, nullable=False)
    # Ensure only one row can exist if this is a singleton configuration
    # __table_args__ = (db.CheckConstraint("id_config = 1", name="ck_singleton_empresaconfig"),)

    def __repr__(self):
        return f'<EmpresaConfig {self.nombre_empresa}>'

