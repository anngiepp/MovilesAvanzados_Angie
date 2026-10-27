import Foundation

final class Boleta {
    func calcular(_ datos: DatosBoleta) throws -> ResultadoBoleta {
        guard !datos.sueldo.isNaN, datos.sueldo > 0 else {
            throw ErrorBoleta.dato("El sueldo básico debe ser mayor que cero.")
        }
        guard (1...30).contains(datos.dias) else {
            throw ErrorBoleta.dato("Los días laborados deben ser un entero entre 1 y 30.")
        }
        let remuneraciones = [
            Concepto(nombre: "Sueldo computable", monto: (datos.sueldo / Parametros.diasMes * Decimal(datos.dias)).centavos),
            Concepto(nombre: "Asignación familiar", monto: datos.tieneHijos ? (Parametros.rmv * Parametros.asignacion).centavos : 0),
            Concepto(nombre: "Horas extras 25%", monto: 0),
            Concepto(nombre: "Horas extras 35%", monto: 0)
        ]
        let total = remuneraciones.reduce(Decimal(0)) { $0 + $1.monto }
        return ResultadoBoleta(remuneraciones: remuneraciones, descuentos: [
            Concepto(nombre: "ONP", monto: (total * Parametros.onp).centavos),
            Concepto(nombre: "AFP fondo", monto: 0),
            Concepto(nombre: "AFP comisión", monto: 0),
            Concepto(nombre: "AFP seguro", monto: 0),
            Concepto(nombre: "Adelantos", monto: 0)
        ], aportaciones: [Concepto(nombre: "EsSalud (9%)", monto: (total * Parametros.essalud).centavos)])
    }
}
