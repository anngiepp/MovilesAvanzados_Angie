import Foundation
import SwiftData

// La primera vez carga usuarios, proveedores, productos y algunas compras
enum DatosEjemplo {

    static func cargarSiHaceFalta(_ contexto: ModelContext) {
        let cantidad = (try? contexto.fetchCount(FetchDescriptor<Producto>())) ?? 0
        if cantidad > 0 { return }

        let angie1 = Usuario(nombre: "Angie Uno", usuario: "angie1", clave: "123456", rol: "Comprador")
        let angie2 = Usuario(nombre: "Angie Dos", usuario: "angie2", clave: "123456", rol: "Supervisor")
        contexto.insert(angie1)
        contexto.insert(angie2)

        let lima = Proveedor(nombre: "Distribuidora Lima SAC", ruc: "20100000011")
        let tecno = Proveedor(nombre: "TecnoImport EIRL", ruc: "20100000012")
        let sur = Proveedor(nombre: "Mayorista Sur SAC", ruc: "20100000013")
        [lima, tecno, sur].forEach { contexto.insert($0) }

        // Stock y costo promedio actuales (ya incluyen las compras de abajo)
        let laptop = Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110)
        let monitor = Producto(nombre: "Monitor 24\"", categoria: "Monitores", stock: 9, costoPromedio: 300)
        let mouse = Producto(nombre: "Mouse inalámbrico", categoria: "Accesorios", stock: 120, costoPromedio: 18.50)
        let teclado = Producto(nombre: "Teclado mecánico", categoria: "Accesorios", stock: 4, costoPromedio: 80)
        [laptop, monitor, mouse, teclado].forEach { contexto.insert($0) }

        compra(contexto, angie1, lima, laptop, 10, 120, alCredito: true, diasAtras: 5)
        compra(contexto, angie1, tecno, mouse, 100, 18.50, alCredito: true, diasAtras: 40)   // ya venció
        compra(contexto, angie1, sur, monitor, 5, 300, alCredito: true, diasAtras: 3)
        compra(contexto, angie1, tecno, teclado, 20, 80, alCredito: false, diasAtras: 8)
        let rechazada = compra(contexto, angie1, sur, monitor, 40, 450, alCredito: true, diasAtras: 2)
        rechazada.estado = "Rechazada"
        rechazada.motivoRechazo = "Precio muy alto, pedir otra cotización"

        try? contexto.save()
    }

    @discardableResult
    static func compra(_ contexto: ModelContext, _ comprador: Usuario, _ proveedor: Proveedor, _ producto: Producto,
                       _ cantidad: Int, _ costo: Double, alCredito: Bool, diasAtras: Int) -> Compra {
        let fecha = Calendar.current.date(byAdding: .day, value: -diasAtras, to: Date())!
        let calculo = calcularCompra(cantidad: cantidad, costoUnitario: costo)
        let nueva = Compra(fecha: fecha, cantidad: cantidad, costoUnitario: costo, igv: calculo.igv, total: calculo.total, alCredito: alCredito)
        contexto.insert(nueva)
        nueva.comprador = comprador
        nueva.proveedor = proveedor
        nueva.producto = producto
        return nueva
    }
}
