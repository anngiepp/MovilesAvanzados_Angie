import Foundation

struct TasasAFP {
    let fondo: Decimal
    let comision: Decimal
    let seguro: Decimal
}

enum Parametros {
    // Fuentes y fechas completas en docs/fuentes.md. Corte: 27/10/2026.
    static let rmv = Decimal(1230)
    static let asignacion = Decimal(string: "0.10")!
    static let onp = Decimal(string: "0.13")!
    static let essalud = Decimal(string: "0.09")!
    static let diasMes = Decimal(30)
    static let horasDia = Decimal(8)
    static let recargo25 = Decimal(string: "0.25")!
    static let recargo35 = Decimal(string: "0.35")!
    // Las AFP reales usan comisión sobre flujo, NO comisión anual sobre saldo.
    // Se aplica el modelo simplificado del curso: seguro sobre toda la remuneración.
    static let afps: [String: TasasAFP] = [
        "AFP Ejemplo": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.016")!, seguro: Decimal(string: "0.0135")!),
        "Habitat (flujo)": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0147")!, seguro: Decimal(string: "0.0137")!),
        "Integra (flujo)": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0155")!, seguro: Decimal(string: "0.0137")!),
        "Prima (flujo)": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.016")!, seguro: Decimal(string: "0.0137")!),
        "Profuturo (flujo)": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0169")!, seguro: Decimal(string: "0.0137")!)
    ]
}
