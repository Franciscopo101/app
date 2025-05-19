from src.models.user import db # Assuming db is initialized in a central models.py or user.py

class ItemCotizacion(db.Model):
    __tablename__ = "items_cotizacion"

    id_item_cotizacion = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_cotizacion = db.Column(db.Integer, db.ForeignKey("cotizaciones.id_cotizacion"), nullable=False)
    
    codigo_item = db.Column(db.String(50))
    descripcion_item = db.Column(db.Text, nullable=False)
    unidad_medida = db.Column(db.String(50))
    cantidad = db.Column(db.Numeric(10,2), nullable=False)
    precio_unitario = db.Column(db.Numeric(15,2), nullable=False)
    descuento_item_porcentaje = db.Column(db.Numeric(5,2), default=0.00)
    # valor_total_item will be a calculated property or handled in logic, not stored if it's purely derived
    # valor_total_item = db.Column(db.Numeric(15,2), nullable=False) 

    # Relationship (backref is defined in Cotizacion model)
    # cotizacion = db.relationship("Cotizacion", backref=db.backref("items", lazy="dynamic"))

    @property
    def valor_total_item(self):
        """Calculates the total value for this item after discount."""
        if self.cantidad is not None and self.precio_unitario is not None:
            total_bruto = self.cantidad * self.precio_unitario
            if self.descuento_item_porcentaje is not None:
                descuento = total_bruto * (self.descuento_item_porcentaje / 100)
                return total_bruto - descuento
            return total_bruto
        return 0

    def __repr__(self):
        return f 

