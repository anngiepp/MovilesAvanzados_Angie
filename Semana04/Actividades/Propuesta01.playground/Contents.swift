import Foundation

// ===== ACTIVIDAD PROPUESTA 01: FACTURA DE CURSOS =====

struct Curso {
    let nombre: String
    let cantidad: Int
    let precioUnitario: Double
}

class FacturaTecsup {
    let estudiante: String
    let dni: String
    let esAlumnoTecsup: Bool
    var cursos: [Curso] = []
    
    init(estudiante: String, dni: String, esAlumnoTecsup: Bool) {
        self.estudiante = estudiante
        self.dni = dni
        self.esAlumnoTecsup = esAlumnoTecsup
    }
    
    func agregar(curso: Curso) {
        cursos.append(curso)
    }
    
    func calcularTotalCursos() -> Int {
        var total = 0
        for c in cursos {
            total += c.cantidad
        }
        return total
    }
    
    func generarFactura() {
        print("🎓 FACTURA DE CURSOS")
        print("Estudiante: \(estudiante)")
        print("DNI: \(dni)")
        print("Alumno de Tecsup: \(esAlumnoTecsup ? "SI" : "NO")")
        print("-----------------------------------")
        
        var subtotal: Double = 0.0
        
        for c in cursos {
            let totalCurso = Double(c.cantidad) * c.precioUnitario
            subtotal += totalCurso
            print("\(c.nombre) x\(c.cantidad)  - S/ \(totalCurso)")
        }
        
        print("-----------------------------------")
        
        let igv = subtotal * 0.18
        let totalConIGV = subtotal + igv
        let totalItems = calcularTotalCursos()
        
        // Regla 1: 10% de descuento si lleva 3 o más cursos
        var descCantidad: Double = 0.0
        if totalItems >= 3 {
            descCantidad = totalConIGV * 0.10
        }
        
        // Regla 2: 400 soles de descuento si es alumno Tecsup Y lleva 3 o más cursos
        var descTecsup: Double = 0.0
        if esAlumnoTecsup && totalItems >= 3 {
            descTecsup = 400.0
        }
        
        let totalFinal = totalConIGV - descCantidad - descTecsup
        
        print("Subtotal: S/ \(subtotal)")
        print("IGV (18%): S/ \(igv)")
        print("Total con IGV: S/ \(totalConIGV)")
        if descCantidad > 0 {
            print("Descuento 10% por cantidad: -S/ \(descCantidad) ✅")
        }
        if descTecsup > 0 {
            print("Descuento especial Tecsup: -S/ \(descTecsup) ✅")
        }
        print("\n💰 TOTAL FINAL A PAGAR: S/ \(totalFinal)")
    }
}

// ===== EJECUCIÓN =====

let factura = FacturaTecsup(estudiante: "Juan León", dni: "78965412", esAlumnoTecsup: true)

factura.agregar(curso: Curso(nombre: "Swift Avanzado", cantidad: 1, precioUnitario: 450.0))
factura.agregar(curso: Curso(nombre: "IA con Python", cantidad: 2, precioUnitario: 650.0))
factura.agregar(curso: Curso(nombre: "Diseño UX/UI", cantidad: 1, precioUnitario: 500.0))

factura.generarFactura()
