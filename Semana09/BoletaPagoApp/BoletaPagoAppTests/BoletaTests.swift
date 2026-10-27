import XCTest
@testable import BoletaCore

final class BoletaTests: XCTestCase {
    func testCaso3() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 3000, dias: 30, tieneHijos: true, sistema: .afp, horas25: 4, horas35: 4, adelanto: 200))
        XCTAssertEqual(r.remuneraciones.map(\.monto), ["3000", "123", "62.50", "67.50"].map { Decimal(string: $0)! })
        XCTAssertEqual(r.descuentos.map(\.monto), ["0", "325.30", "52.05", "43.92", "200"].map { Decimal(string: $0)! })
        XCTAssertEqual(r.totalRemuneraciones, 3253)
        XCTAssertEqual(r.totalDescuentos, Decimal(string: "621.27"))
        XCTAssertEqual(r.neto, Decimal(string: "2631.73"))
        XCTAssertEqual(r.aportaciones[0].monto, Decimal(string: "292.77"))
    }
    func testCaso4() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 4200, dias: 24, tieneHijos: true, sistema: .afp, horas25: 2, horas35: 2, adelanto: 100))
        XCTAssertEqual(r.remuneraciones.map(\.monto), ["3360", "123", "43.75", "47.25"].map { Decimal(string: $0)! })
        XCTAssertEqual(r.descuentos.map(\.monto), ["0", "357.40", "57.18", "48.25", "100"].map { Decimal(string: $0)! })
        XCTAssertEqual(r.totalRemuneraciones, 3574)
        XCTAssertEqual(r.totalDescuentos, Decimal(string: "562.83"))
        XCTAssertEqual(r.neto, Decimal(string: "3011.17"))
        XCTAssertEqual(r.aportaciones[0].monto, Decimal(string: "321.66"))
    }
    func testAFPReal() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 2000, dias: 30, tieneHijos: false, sistema: .afp, afp: "Prima (flujo)"))
        XCTAssertEqual(r.descuentos.map(\.monto), ["0", "200", "32", "27.40", "0"].map { Decimal(string: $0)! })
        XCTAssertEqual(r.neto, Decimal(string: "1740.60"))
    }
    func testHorasNoRedondeanValorHoraAntes() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 1000, dias: 30, tieneHijos: false, horas25: 4))
        XCTAssertEqual(r.remuneraciones[2].monto, Decimal(string: "20.83"))
    }
    func testAFPInvalidaYValoresNegativos() {
        XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: 2000, dias: 30, tieneHijos: false, sistema: .afp, afp: "Desconocida")))
        XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: 2000, dias: 30, tieneHijos: false, horas25: -1)))
        XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: 2000, dias: 30, tieneHijos: false, horas35: -1)))
        XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: 2000, dias: 30, tieneHijos: false, adelanto: -1)))
    }
    func testEntradaDecimalCompleta() throws {
        XCTAssertEqual(try FormularioBoleta.numero(" 2500,50 ", campo: "Sueldo"), Decimal(string: "2500.50"))
        for texto in ["", "abc", "2500abc", "1,000.50", "1e3", "-2", "NaN", "2.3.4"] {
            XCTAssertThrowsError(try FormularioBoleta.numero(texto, campo: "Sueldo"))
        }
        XCTAssertThrowsError(try FormularioBoleta(dias: "27.5").datos())
    }
    func testNetoNegativoNoSeOculta() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 100, dias: 30, tieneHijos: false, adelanto: 200))
        XCTAssertEqual(r.neto, -113)
    }
    func testCaso1() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 2500, dias: 30, tieneHijos: false))
        XCTAssertEqual(r.remuneraciones.map(\.monto), [2500, 0, 0, 0])
        XCTAssertEqual(r.descuentos.map(\.monto), [325, 0, 0, 0, 0])
        XCTAssertEqual(r.neto, 2175)
        XCTAssertEqual(r.aportaciones[0].monto, 225)
    }
    func testCaso2() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 1800, dias: 27, tieneHijos: true))
        XCTAssertEqual(r.remuneraciones.map(\.monto), [1620, 123, 0, 0])
        XCTAssertEqual(r.totalRemuneraciones, 1743)
        XCTAssertEqual(r.totalDescuentos, Decimal(string: "226.59"))
        XCTAssertEqual(r.neto, Decimal(string: "1516.41"))
        XCTAssertEqual(r.aportaciones[0].monto, Decimal(string: "156.87"))
    }
    func testAsignacionNoSeProrratea() throws {
        let r = try Boleta().calcular(DatosBoleta(sueldo: 1800, dias: 1, tieneHijos: true))
        XCTAssertEqual(r.remuneraciones[1].monto, 123)
    }
    func testRechazaSueldoYDiasInvalidos() {
        for sueldo in [Decimal(0), -1, .nan] {
            XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: sueldo, dias: 30, tieneHijos: false)))
        }
        for dias in [0, 31, -1] {
            XCTAssertThrowsError(try Boleta().calcular(DatosBoleta(sueldo: 2500, dias: dias, tieneHijos: false)))
        }
    }
    func testRedondeoMedioCentavo() {
        XCTAssertEqual(Decimal(string: "52.045")!.centavos, Decimal(string: "52.05"))
        XCTAssertEqual(Decimal(string: "-52.045")!.centavos, Decimal(string: "-52.05"))
    }
}
