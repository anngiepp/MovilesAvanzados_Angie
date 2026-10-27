import Foundation

final class Boleta {
    func calcular(_ datos: DatosBoleta) throws -> ResultadoBoleta {
        guard !datos.sueldo.isNaN, datos.sueldo > 0 else {
            throw ErrorBoleta.dato("El sueldo básico debe ser mayor que cero.")
        }
        guard (1...30).contains(datos.dias) else {
            throw ErrorBoleta.dato("Los días laborados deben ser un entero entre 1 y 30.")
        }
        for (nombre, valor) in [("Horas al 25%", datos.horas25), ("Horas al 35%", datos.horas35), ("Adelantos", datos.adelanto)] {
            guard !valor.isNaN, valor >= 0 else { throw ErrorBoleta.dato("\(nombre) debe ser mayor o igual a cero.") }
        }
        let tasas: TasasAFP?
        if datos.sistema == .afp {
            guard let elegida = Parametros.afps[datos.afp] else { throw ErrorBoleta.dato("Selecciona una AFP válida.") }
            tasas = elegida
        } else { tasas = nil }
        let valorHora = datos.sueldo / Parametros.diasMes / Parametros.horasDia
        let remuneraciones = [
            Concepto(nombre: "Sueldo computable", monto: (datos.sueldo / Parametros.diasMes * Decimal(datos.dias)).centavos),
            Concepto(nombre: "Asignación familiar", monto: datos.tieneHijos ? (Parametros.rmv * Parametros.asignacion).centavos : 0),
            Concepto(nombre: "Horas extras 25%", monto: (valorHora * (1 + Parametros.recargo25) * datos.horas25).centavos),
            Concepto(nombre: "Horas extras 35%", monto: (valorHora * (1 + Parametros.recargo35) * datos.horas35).centavos)
        ]
        let total = remuneraciones.reduce(Decimal(0)) { $0 + $1.monto }
        return ResultadoBoleta(remuneraciones: remuneraciones, descuentos: [
            Concepto(nombre: "ONP", monto: datos.sistema == .onp ? (total * Parametros.onp).centavos : 0),
            Concepto(nombre: "AFP fondo", monto: (total * (tasas?.fondo ?? 0)).centavos),
            Concepto(nombre: "AFP comisión", monto: (total * (tasas?.comision ?? 0)).centavos),
            Concepto(nombre: "AFP seguro", monto: (total * (tasas?.seguro ?? 0)).centavos),
            Concepto(nombre: "Adelantos", monto: datos.adelanto.centavos)
        ], aportaciones: [Concepto(nombre: "EsSalud (9%)", monto: (total * Parametros.essalud).centavos)])
    }
}
