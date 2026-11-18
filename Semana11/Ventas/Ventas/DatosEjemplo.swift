import Foundation
import CoreData

// Carga productos, clientes, dos vendedores y algunas ventas la primera vez
// para que el resumen tenga datos y Comercial Andina ya sea VIP.
enum DatosEjemplo {

    static func cargarSiHaceFalta() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        let cantidad = (try? BD.contexto.count(for: req)) ?? 0
        if cantidad > 0 { return }

        _ = producto("Laptop Pro 14", "Laptops", 200.00, 40)
        let monitor = producto("Monitor 24\"", "Monitores", 450.00, 9)
        let mouse = producto("Mouse inalámbrico", "Accesorios", 35.00, 120)
        let teclado = producto("Teclado mecánico", "Accesorios", 129.90, 4)

        let andina = cliente("Comercial Andina SAC", "RUC 20000000001")
        let maria = cliente("María Quispe", "DNI 00000001")
        let luis = cliente("Luis Rojas", "DNI 00000002")
        _ = cliente("Tienda Sol EIRL", "RUC 20000000044")

        let carlos = usuario("Carlos Ruiz", "angie1", "Vendedor")
        let ana = usuario("Ana Díaz", "angie2", "Vendedor")

        venta(carlos, andina, monitor, 4, diasAtras: 6)
        venta(ana, maria, monitor, 3, diasAtras: 5)
        venta(ana, andina, monitor, 4, diasAtras: 4)
        venta(carlos, luis, mouse, 7, diasAtras: 3)
        venta(carlos, andina, monitor, 4, diasAtras: 2)
        venta(ana, luis, teclado, 1, diasAtras: 1)
        let anulada = venta(ana, maria, monitor, 1, diasAtras: 1)
        anulada.anulada = true
        anulada.motivoAnulacion = "Producto defectuoso"

        BD.guardar()
    }

    static func producto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
        let p = Producto(context: BD.contexto)
        p.nombre = nombre
        p.categoria = categoria
        p.precio = precio
        p.stock = stock
        return p
    }

    static func cliente(_ nombre: String, _ documento: String) -> Cliente {
        let c = Cliente(context: BD.contexto)
        c.nombre = nombre
        c.documento = documento
        return c
    }

    static func usuario(_ nombre: String, _ usuario: String, _ rol: String) -> Usuario {
        let u = Usuario(context: BD.contexto)
        u.nombre = nombre
        u.usuario = usuario
        u.clave = "123456"
        u.rol = rol
        return u
    }

    // No baja el stock: los stocks de arriba ya son los actuales
    @discardableResult
    static func venta(_ vendedor: Usuario, _ cliente: Cliente, _ producto: Producto, _ cantidad: Int, diasAtras: Int) -> Venta {
        let calculo = calcularVenta(cantidad: cantidad, precio: producto.precio, categoria: categoria(de: cliente))
        let v = Venta(context: BD.contexto)
        v.fecha = Calendar.current.date(byAdding: .day, value: -diasAtras, to: Date())
        v.cantidad = Int64(cantidad)
        v.precioUnitario = producto.precio
        v.descuento = calculo.descuento
        v.igv = calculo.igv
        v.total = calculo.total
        v.anulada = false
        v.vendedor = vendedor
        v.cliente = cliente
        v.producto = producto
        return v
    }
}
