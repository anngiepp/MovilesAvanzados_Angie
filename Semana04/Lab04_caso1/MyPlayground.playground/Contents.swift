// ===== CASO 1.5: HERENCIA Y POLIMORFISMO — LA CADENA DE SUCURSALES =====

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// --- Ejemplo (ya resuelto): la base define el FLUJO; las hijas cambiarán las REGLAS ---
class Sucursal {
    let nombre: String
    let ciudad: String
    
    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }
    
    func descuento() -> Double {
        return 0.05
    }
    
    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }
    
    // REGLA 2: este método NO se sobreescribe en las subclases
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// --- TODO 14: SucursalLima ---
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }
    
    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500.0 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// --- TODO 15: SucursalProvincia ---
class SucursalProvincia: Sucursal {
    // NO sobreescribimos descuento() (hereda el 5% de la base)
    override func costoEnvio(monto: Double) -> Double {
        let calculado = monto * 0.08
        if calculado < 50.0 {
            return 50.0
        } else {
            return calculado
        }
    }
}

// --- TODO 16: SucursalOutlet ---
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }
    
    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// --- TODO 17: El recorrido polimórfico (REGLA 4) ---
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// ===== FIX: Este código tiene 2 errores =====

class SucursalMall: Sucursal {
    // FIX 7: Se agregó la palabra clave 'override'.
    // Swift la exige para confirmar explícitamente que la subclase está sobreescribiendo un método de la superclase.
    override func descuento() -> Double {
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int
    
    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        // FIX 8: Se agregó 'super.init(...)'.
        // Swift exige llamar al inicializador de la superclase para inicializar sus propiedades (nombre y ciudad).
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// Ejemplo ejecutable de comprobación para la consola:
let express = SucursalExpress(nombre: "Express Surco", ciudad: "Lima", radioKm: 5)
print("Fixes verificados -> Sucursal: \(express.nombre), Radio: \(express.radioKm)km")

// ===== PREDICT: ¿Qué imprime? =====

let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")

// PREDICT 6: Imprime 0.1
// Justificación: Aunque la variable es de tipo Sucursal, el objeto instanciado en memoria es de tipo SucursalLima.
// Swift resuelve en tiempo de ejecución cuál método llamar (polimorfismo dinámico), ejecutando el descuento() de SucursalLima.
print(misteriosa.descuento())

let monto = 2000.0 * (1 - misteriosa.descuento()) // S/ 1800.0

// PREDICT 7: Imprime 0.0
// Justificación: El monto con descuento es S/ 1800.0. Como 1800.0 >= 1500.0, la regla sobreescrita
// de costoEnvio en SucursalLima devuelve 0.0 (envío gratis).
print(misteriosa.costoEnvio(monto: monto))


// ===== TODO 18: La prueba del polimorfismo (REGLA 6) =====

// 1. Definimos la nueva subclase SucursalOnline
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
// Respuesta en comentario: Se necesitaron únicamente 5 líneas de código para implementar SucursalOnline.

// 2. La agregamos al arreglo y realizamos el recorrido sin modificar cotizar ni los for-in
let sucursalesActualizadas: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tienda Online", ciudad: "Web")
]

print("\n===== PRUEBA TODO 18: Con SucursalOnline =====")
print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursalesActualizadas {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursalesActualizadas {
    sucursal.cotizar(item: licuadora)
}
