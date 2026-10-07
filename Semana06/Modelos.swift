import UIKit

// 1. Modelo de Producto
class Producto {
    let nombre: String
    let precio: Double
    var stock: Int
    
    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

// 2. Línea del Carrito
class ItemCarrito {
    let producto: Producto
    var cantidad: Int
    
    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }
    
    func subtotal() -> Double {
        return producto.precio * Double(cantidad)
    }
}

// 3. Modelo del Cliente
class ClienteModel {
    let apellidos: String
    let nombres: String
    let dni: String
    
    init(apellidos: String, nombres: String, dni: String) {
        self.apellidos = apellidos
        self.nombres = nombres
        self.dni = dni
    }
    
    var nombreCompleto: String {
        return "\(nombres) \(apellidos)"
    }
}

// 4. Modelo del Carrito (Referencia compartida)
class CarritoModel {
    var items: [ItemCarrito] = []
    
    // TODO A1: Agregar producto validando stock disponible
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        let itemExistente = items.first(where: { $0.producto.nombre == producto.nombre })
        let cantidadActual = itemExistente?.cantidad ?? 0
        
        // Validación de stock (lo acumulado + lo nuevo)
        if (cantidadActual + cantidad) > producto.stock {
            return false
        }
        
        if let item = itemExistente {
            item.cantidad += cantidad
        } else {
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }
    
    // TODO A2: Subtotal general
    func subtotal() -> Double {
        return items.reduce(0) { $0 + $1.subtotal() }
    }
    
    // TODO A3: Porcentaje de descuento por tramos
    func porcentajeDescuento() -> Double {
        let sub = subtotal()
        if sub >= 5000 { return 0.15 }
        if sub >= 2000 { return 0.10 }
        if sub >= 500  { return 0.05 }
        return 0.0
    }
    
    // Montos derivados para la boleta y carrito
    var montoDescuento: Double {
        return subtotal() * porcentajeDescuento()
    }
    
    var subtotalConDescuento: Double {
        return subtotal() - montoDescuento
    }
    
    var igv: Double {
        return subtotalConDescuento * 0.18
    }
    
    var total: Double {
        return subtotalConDescuento + igv
    }
    
    // Categoría de cliente según el subtotal
    var categoriaCliente: String {
        switch Int(subtotal()) {
        case 0..<500:     return "Regular"
        case 500..<2000:  return "Frecuente"
        case 2000..<5000: return "VIP"
        default:          return "Premium"
        }
    }
    
    // TODO A4: Cantidad total de unidades físicas
    func cantidadTotal() -> Int {
        return items.reduce(0) { $0 + $1.cantidad }
    }
    
    // TODO A5: Vaciar carrito al finalizar
    func vaciar() {
        items.removeAll()
    }
}
