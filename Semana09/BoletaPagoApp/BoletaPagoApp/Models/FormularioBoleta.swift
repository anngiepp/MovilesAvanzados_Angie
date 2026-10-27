import Foundation

struct FormularioBoleta: Equatable {
    var sueldo = "2500"
    var dias = "30"
    var hijos = false
    var sistema = SistemaPension.onp
    var afp = "AFP Ejemplo"
    var horas25 = "0"
    var horas35 = "0"
    var adelanto = "0"

    static func numero(_ texto: String, campo: String) throws -> Decimal {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        // No separadores de miles, exponentes ni texto parcialmente numérico.
        guard limpio.range(of: #"^\d{1,12}(\.\d{1,6})?$"#, options: .regularExpression) != nil,
              let valor = Decimal(string: limpio, locale: Locale(identifier: "en_US_POSIX")) else {
            throw ErrorBoleta.dato("\(campo): ingresa un número no negativo, sin separadores de miles (hasta 12 enteros y 6 decimales).")
        }
        return valor
    }

    func datos() throws -> DatosBoleta {
        guard let numeroDias = Int(dias.trimmingCharacters(in: .whitespacesAndNewlines)), (1...30).contains(numeroDias) else {
            throw ErrorBoleta.dato("Los días laborados deben ser un entero entre 1 y 30.")
        }
        return try DatosBoleta(sueldo: Self.numero(sueldo, campo: "Sueldo básico"), dias: numeroDias, tieneHijos: hijos,
            sistema: sistema, afp: afp, horas25: Self.numero(horas25, campo: "Horas al 25%"),
            horas35: Self.numero(horas35, campo: "Horas al 35%"), adelanto: Self.numero(adelanto, campo: "Adelantos"))
    }
}
