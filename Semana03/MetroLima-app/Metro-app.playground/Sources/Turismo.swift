import Foundation

// =================================
// ESTRUCTURAS Y FAVORITOS
// =================================

public struct LugarTuristico {
    public let nombre: String
    public let categoria: String
    public let descripcion: String
    
    public init(nombre: String, categoria: String, descripcion: String) {
        self.nombre = nombre
        self.categoria = categoria
        self.descripcion = descripcion
    }
}

@MainActor public var estacionesFavoritas: Set<String> = []

@MainActor
public func agregarFavorito(estacionNombre: String) {
    if let estacion = buscarEstacionInteligente(estacionNombre) {
        estacionesFavoritas.insert(estacion.nombre)
        print("\n ¡Estación '\(estacion.nombre)' agregada a tus favoritos!")
    } else {
        print("\n No se encontró la estación para agregar a favoritos.")
    }
}

@MainActor
public func mostrarFavoritos() {
    print("""
    
    ╔══════════════════════════════════════════╗
    ║         MIS ESTACIONES FAVORITAS       ║
    ╚══════════════════════════════════════════╝
    """)
    if estacionesFavoritas.isEmpty {
        print("Aún no has guardado estaciones favoritas.")
    } else {
        for (index, nombre) in estacionesFavoritas.sorted().enumerated() {
            if let e = estacionesMetro[nombre] {
                print("\(index + 1). ⭐ \(e.nombre) [\(e.linea)] - \(e.distrito)")
            } else {
                print("\(index + 1). ⭐ \(nombre)")
            }
        }
    }
    print("════════════════════════════════════════════\n")
}

// =================================
// GUÍA TURÍSTICA DEDICADA
// =================================

@MainActor public let guiaTuristicaMetro: [String: [LugarTuristico]] = [
    "Gamarra": [
        LugarTuristico(nombre: "Emporio Comercial Gamarra", categoria: " Compras", descripcion: "El centro textil y comercial más grande del Perú."),
        LugarTuristico(nombre: "Parque Cánepa", categoria: " Espacio Público", descripcion: "Corazón comercial de La Victoria.")
    ],
    "Grau": [
        LugarTuristico(nombre: "Hospital Dos de Mayo", categoria: " Salud/Patrimonio", descripcion: "Monumento histórico y centro hospitalario emblemático."),
        LugarTuristico(nombre: "Barrios Altos", categoria: " Historia", descripcion: "Zona tradicional con casonas e iglesias coloniales.")
    ],
    "Estación Central": [
        LugarTuristico(nombre: "Centro Histórico de Lima", categoria: " Patrimonio Mundial UNESCO", descripcion: "Plaza Mayor, Catedral y Palacios de Gobierno."),
        LugarTuristico(nombre: "Parque Universitario", categoria: " Cultural", descripcion: "Espacio tradicional de congregación académica y cultural.")
    ],
    "Javier Prado": [
        LugarTuristico(nombre: "Centro Financiero de San Isidro", categoria: " Negocios", descripcion: "Zona corporativa, bancos y restaurantes ejecutivos.")
    ],
    "Angamos": [
        LugarTuristico(nombre: "Distrito Turístico de Miraflores", categoria: " Turismo", descripcion: "Acceso cercano al malecón, parques y zonas comerciales.")
    ],
    "Presbítero Maestro": [
        LugarTuristico(nombre: "Museo Cripta de los Héroes / Cementerio Presbítero Maestro", categoria: " Museo / Historia", descripcion: "Primer cementerio monumental de América Latina.")
    ]
]

@MainActor
public func explorarTurismoEstacion(_ texto: String) {
    guard let estacion = buscarEstacionInteligente(texto) else {
        print("\n No encontramos la estación solicitada.")
        return
    }
    
    print("""
    
    ╔══════════════════════════════════════════╗
    ║       🇵🇪 GUÍA TURÍSTICA Y ENTORNOS       ║
    ╚══════════════════════════════════════════╝
     Estación: \(estacion.nombre) (\(estacion.linea))
     Distrito: \(estacion.distrito)
    ════════════════════════════════════════════
    """)
    
    if let atracciones = guiaTuristicaMetro[estacion.nombre], !atracciones.isEmpty {
        print(" ATRACTIVOS DESTACADOS:")
        for atraccion in atracciones {
            print("\n  • \(atraccion.nombre) [\(atraccion.categoria)]")
            print("    \(atraccion.descripcion)")
        }
    } else if !estacion.lugaresCercanos.isEmpty {
        print(" LUGARES DE INTERÉS CERCANOS:")
        for lugar in estacion.lugaresCercanos {
            print("  • \(lugar)")
        }
    } else {
        print(" Esta estación se ubica en una zona eminentemente residencial o industrial.")
    }
    
    print("\n RECOMENDACIÓN INTELIGENTE:")
    if estacion.tipo == .intercambio {
        print(" Esta estación es un HUB de conexión (\(estacion.conexiones.joined(separator: ", "))). Utilízala para cambiar de línea y optimizar tu viaje.")
    } else {
        print(" Estación estratégica en \(estacion.distrito). Planifica tu viaje verificando los horarios de hora punta.")
    }
    print("════════════════════════════════════════════\n")
}

// =================================
// ESTADÍSTICAS AVANZADAS
// =================================

@MainActor
public func mostrarEstadisticasAvanzadas() {
    let total = estacionesMetro.count
    let operativas = estacionesMetro.values.filter { $0.estado == .operativa }.count
    let construccion = estacionesMetro.values.filter { $0.estado == .construccion }.count
    let proyecto = estacionesMetro.values.filter { $0.estado == .proyecto }.count
    let conexiones = estacionesMetro.values.filter { $0.tipo == .intercambio }.count
    
    // Contar estaciones por distrito
    var distritosConteo: [String: Int] = [:]
    for e in estacionesMetro.values {
        distritosConteo[e.distrito, default: 0] += 1
    }
    let distritoTop = distritosConteo.max(by: { $0.value < $1.value })
    
    print("""
    
    ╔══════════════════════════════════════════╗
    ║         ANALÍTICA DEL SISTEMA METRO    ║
    ╚══════════════════════════════════════════╝
     Total de estaciones registradas: \(total)
       • 🟢 Operativas:   \(operativas)
       • 🟡 En obra:      \(construccion)
       • 🔴 En proyecto:  \(proyecto)
    
     Nodos de conexión (Intercambio): \(conexiones)
    
     DATO CLAVE:
       • Distrito con mayor presencia: \(distritoTop?.key ?? "N/A") (\(distritoTop?.value ?? 0) estaciones)
       • Línea con mayor cobertura operativa: Línea 1 (26 estaciones)
       • Próxima mega-expansión: Línea 2 y Ramal Línea 4
    ════════════════════════════════════════════\n
    """)
}
