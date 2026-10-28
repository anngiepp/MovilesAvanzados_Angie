import Foundation

enum SistemaPension: String { case onp = "ONP", afp = "AFP" }

struct DatosBoleta {
    var sueldo: Decimal
    var dias: Int
    var tieneHijos: Bool
    var sistema: SistemaPension = .onp
    var afp: String = "AFP Ejemplo"
    var horas25: Decimal = 0
    var horas35: Decimal = 0
    var adelanto: Decimal = 0
}

struct Concepto {
    let nombre: String
    let monto: Decimal
}

struct ResultadoBoleta {
    let remuneraciones: [Concepto]
    let descuentos: [Concepto]
    let aportaciones: [Concepto]
    var totalRemuneraciones: Decimal { remuneraciones.reduce(0) { $0 + $1.monto } }
    var totalDescuentos: Decimal { descuentos.reduce(0) { $0 + $1.monto } }
    var neto: Decimal { totalRemuneraciones - totalDescuentos }
}

enum ErrorBoleta: LocalizedError {
    case dato(String)
    var errorDescription: String? {
        switch self { case .dato(let mensaje): return mensaje }
    }
}

extension Decimal {
    // .plain equivale a ROUND de Excel: empate de medio centavo alejándose de cero.
    var centavos: Decimal {
        var original = self
        var resultado = Decimal()
        NSDecimalRound(&resultado, &original, 2, .plain)
        return resultado
    }
    var soles: String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US")
        formato.numberStyle = .decimal
        formato.usesGroupingSeparator = true
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return "S/ " + (formato.string(from: NSDecimalNumber(decimal: self)) ?? "0.00")
    }
}
