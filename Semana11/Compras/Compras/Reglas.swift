import Foundation
import Observation

let tasaIGV = 0.18
let limiteAprobacion = 5000.0
let diasCredito = 30

// Usuario conectado mientras la app está abierta
@Observable
class Sesion {
    var usuario: Usuario?

    var esSupervisor: Bool {
        usuario?.rol == "Supervisor"
    }
}

struct Calculo {
    let subtotal: Double
    let igv: Double
    let total: Double
}

func redondear(_ valor: Double) -> Double {
    (valor * 100).rounded() / 100
}

// IGV 18 % sobre el subtotal; es crédito fiscal
func calcularCompra(cantidad: Int, costoUnitario: Double) -> Calculo {
    let subtotal = redondear(Double(cantidad) * costoUnitario)
    let igv = redondear(subtotal * tasaIGV)
    return Calculo(subtotal: subtotal, igv: igv, total: redondear(subtotal + igv))
}

// Costo promedio ponderado
func nuevoCostoPromedio(stock: Int, costoPromedio: Double, cantidad: Int, costoUnitario: Double) -> Double {
    let unidades = stock + cantidad
    guard unidades > 0 else { return costoUnitario }
    let valor = Double(stock) * costoPromedio + Double(cantidad) * costoUnitario
    return redondear(valor / Double(unidades))
}

// Efecto de una compra aprobada: sube el stock y cambia el costo promedio
func aplicarCompra(_ compra: Compra) {
    guard let producto = compra.producto else { return }
    producto.costoPromedio = nuevoCostoPromedio(stock: producto.stock, costoPromedio: producto.costoPromedio,
                                                cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)
    producto.stock += compra.cantidad
}

extension Compra {
    var subtotal: Double { redondear(total - igv) }

    // Cuenta por pagar: aprobada, al crédito y sin pagar
    var porPagar: Bool { estado == "Aprobada" && alCredito && !pagada }

    var vencida: Bool { porPagar && vence < Date() }
}

extension Proveedor {
    var totalComprado: Double {
        compras.filter { $0.estado == "Aprobada" }.reduce(0) { $0 + $1.total }
    }

    var cantidadPorPagar: Int {
        compras.filter { $0.porPagar }.count
    }
}

// MARK: - Formatos

func soles(_ valor: Double) -> String {
    let formato = NumberFormatter()
    formato.numberStyle = .decimal
    formato.minimumFractionDigits = 2
    formato.maximumFractionDigits = 2
    formato.locale = Locale(identifier: "en_US")
    return "S/ " + (formato.string(from: NSNumber(value: valor)) ?? "0.00")
}

func textoFecha(_ fecha: Date, _ patron: String = "dd/MM") -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_PE")
    formato.dateFormat = patron
    return formato.string(from: fecha)
}

func iniciales(_ texto: String) -> String {
    let partes = texto.split(separator: " ").prefix(2)
    return partes.compactMap { $0.first }.map { String($0) }.joined().uppercased()
}

func primerNombre(_ texto: String) -> String {
    String(texto.split(separator: " ").first ?? "")
}

func inicioDelMes(_ fecha: Date = Date()) -> Date {
    let cal = Calendar.current
    return cal.date(from: cal.dateComponents([.year, .month], from: fecha)) ?? fecha
}
