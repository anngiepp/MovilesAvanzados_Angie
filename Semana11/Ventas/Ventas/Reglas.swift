import Foundation
import CoreData

let tasaIGV = 0.18
let descuentoVIP = 0.10

struct Calculo {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double
}

func redondear(_ valor: Double) -> Double {
    (valor * 100).rounded() / 100
}

// Regular < 1000, Frecuente desde 1000, VIP desde 5000
func categoria(totalComprado: Double) -> String {
    if totalComprado >= 5000 { return "VIP" }
    if totalComprado >= 1000 { return "Frecuente" }
    return "Regular"
}

// Solo cuentan las ventas que no están anuladas
func totalComprado(_ cliente: Cliente) -> Double {
    let ventas = cliente.ventas as? Set<Venta> ?? []
    return ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total }
}

func categoria(de cliente: Cliente) -> String {
    categoria(totalComprado: totalComprado(cliente))
}

func calcularVenta(cantidad: Int, precio: Double, categoria: String) -> Calculo {
    let subtotal = redondear(Double(cantidad) * precio)
    let descuento = categoria == "VIP" ? redondear(subtotal * descuentoVIP) : 0
    let igv = redondear((subtotal - descuento) * tasaIGV)
    let total = redondear(subtotal - descuento + igv)
    return Calculo(subtotal: subtotal, descuento: descuento, igv: igv, total: total)
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

func textoFecha(_ fecha: Date?, _ patron: String = "dd/MM") -> String {
    guard let fecha = fecha else { return "" }
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_PE")
    formato.dateFormat = patron
    return formato.string(from: fecha)
}

func primerNombre(_ nombre: String?) -> String {
    String((nombre ?? "").split(separator: " ").first ?? "")
}

// MARK: - Fechas para los filtros

func inicioDelDia(_ fecha: Date = Date()) -> Date {
    Calendar.current.startOfDay(for: fecha)
}

func inicioDelMes(_ fecha: Date = Date()) -> Date {
    let cal = Calendar.current
    return cal.date(from: cal.dateComponents([.year, .month], from: fecha)) ?? fecha
}

// 0 = Todas, 1 = Hoy, 2 = Mes
func predicadoPeriodo(_ indice: Int) -> NSPredicate? {
    switch indice {
    case 1: return NSPredicate(format: "fecha >= %@", inicioDelDia() as NSDate)
    case 2: return NSPredicate(format: "fecha >= %@", inicioDelMes() as NSDate)
    default: return nil
    }
}

// Ventas no anuladas entre dos fechas (para indicadores y resumen)
func ventasValidas(desde: Date, hasta: Date, vendedor: Usuario? = nil) -> [Venta] {
    let req: NSFetchRequest<Venta> = Venta.fetchRequest()
    var filtros = [
        NSPredicate(format: "anulada == NO"),
        NSPredicate(format: "fecha >= %@ AND fecha < %@", desde as NSDate, hasta as NSDate)
    ]
    if let vendedor = vendedor {
        filtros.append(NSPredicate(format: "vendedor == %@", vendedor))
    }
    req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
    return (try? BD.contexto.fetch(req)) ?? []
}

func sumaTotal(_ ventas: [Venta]) -> Double {
    ventas.reduce(0) { $0 + $1.total }
}
