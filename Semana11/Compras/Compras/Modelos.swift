import Foundation
import SwiftData

// Las 4 clases del caso. Las relaciones To Many tienen .deny:
// no se puede borrar un usuario, proveedor o producto que ya tenga compras.

@Model
final class Usuario {
    var nombre: String
    var usuario: String      // se guarda en minúsculas para que sea único sin importar mayúsculas
    var clave: String
    var rol: String          // "Comprador" o "Supervisor"

    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario.lowercased()
        self.clave = clave
        self.rol = rol
    }
}

@Model
final class Proveedor {
    var nombre: String
    var ruc: String

    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }
}

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double

    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }
}

@Model
final class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double
    var total: Double
    var alCredito: Bool
    var vence: Date
    var estado: String       // "Pendiente", "Aprobada" o "Rechazada"
    var pagada: Bool
    var motivoRechazo: String?

    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date, cantidad: Int, costoUnitario: Double, igv: Double, total: Double, alCredito: Bool) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        // Crédito: vence a los 30 días. Contado: queda pagada al toque.
        self.vence = alCredito ? Calendar.current.date(byAdding: .day, value: diasCredito, to: fecha)! : fecha
        self.estado = "Aprobada"
        self.pagada = !alCredito
        self.motivoRechazo = nil
    }
}
