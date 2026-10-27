import XCTest
@testable import BoletaCore

final class BoletaTests: XCTestCase {
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
