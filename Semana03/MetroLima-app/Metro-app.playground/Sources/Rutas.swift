import Foundation

// =================================
// ESTRUCTURA PARA EL GRAFO
// =================================

public struct PasoRuta {
    public let estacion: Estacion
    public let lineaActual: String
    
    public init(estacion: Estacion, lineaActual: String) {
        self.estacion = estacion
        self.lineaActual = lineaActual
    }
}

// =================================
// IMPRESIÓN DE RUTAS
// =================================

@MainActor
public func imprimirRuta(ruta: [PasoRuta], origen: Estacion, destino: Estacion) {
    let paradas = ruta.count - 1
    let tiempoEstimado = (paradas * 2) + 5
    
    print("""
    
    ═════════════════════════════════════════
              PLANIFICADOR DE RUTA
    ═════════════════════════════════════════
     Origen:  \(origen.nombre) (\(origen.linea))
     Destino: \(destino.nombre) (\(destino.linea))
     Tiempo estimado: ~\(tiempoEstimado) min
     Paradas / Tramo: \(paradas)
    ═════════════════════════════════════════
    
    📍 ITINERARIO PASO A PASO:
    """)
    
    var lineaActual = origen.linea
    
    for (index, paso) in ruta.enumerated() {
        let e = paso.estacion
        let conector = (index == 0) ? "🟢 INICIO" : ((index == ruta.count - 1) ? "🏁 LLEGADA" : "  │")
        
        if index > 0 && e.linea != lineaActual {
            print("   ═══ TRANSBORDO HACIA \(e.linea.uppercased()) EN \(e.nombre) ═══")
            lineaActual = e.linea
        }
        
        print("\(conector) [\(e.id)] \(e.nombre) (\(e.linea))")
    }
    
    print("═════════════════════════════════════════\n")
}

// =================================
// MOTOR DE RUTAS Y GRAFOS (BFS)
// =================================

@MainActor
public func calcularRuta(origenNombre: String, destinoNombre: String) {
    guard let origen = buscarEstacionInteligente(origenNombre),
          let destino = buscarEstacionInteligente(destinoNombre) else {
        print("\n Una o ambas estaciones no fueron encontradas.")
        return
    }
    
    if origen.nombre == destino.nombre {
        print("\n Ya te encuentras en la estación de destino: \(origen.nombre)")
        return
    }
    
    var cola: [[PasoRuta]] = [[PasoRuta(estacion: origen, lineaActual: origen.linea)]]
    var visitados: Set<String> = ["\(origen.nombre)-\(origen.linea)"]
    var rutaEncontrada: [PasoRuta]? = nil
    
    while !cola.isEmpty {
        let camino = cola.removeFirst()
        let ultimoPaso = camino.last!
        let estacionActual = ultimoPaso.estacion
        
        if estacionActual.nombre.lowercased() == destino.nombre.lowercased() {
            rutaEncontrada = camino
            break
        }
        
        var vecinos: [Estacion] = []
        
        // 1. Conexiones adyacentes de la misma línea
        if let antNombre = estacionActual.estacionAnterior, let antEstacion = estacionesMetro[antNombre] {
            vecinos.append(antEstacion)
        }
        if let sigNombre = estacionActual.estacionSiguiente, let sigEstacion = estacionesMetro[sigNombre] {
            vecinos.append(sigEstacion)
        }
        
        // 2. Conexiones de transbordo entre líneas diferentes
        if estacionActual.tipo == .intercambio {
            for otra in estacionesMetro.values where otra.linea != estacionActual.linea {
                if otra.nombre.lowercased() == estacionActual.nombre.lowercased() ||
                   estacionActual.conexiones.contains(otra.linea) {
                    vecinos.append(otra)
                }
            }
        }
        
        // Explorar nodos adyacentes
        for vecino in vecinos {
            let claveUnica = "\(vecino.nombre)-\(vecino.linea)"
            if !visitados.contains(claveUnica) {
                visitados.insert(claveUnica)
                var nuevoCamino = camino
                nuevoCamino.append(PasoRuta(estacion: vecino, lineaActual: vecino.linea))
                cola.append(nuevoCamino)
            }
        }
    }
    
    if let ruta = rutaEncontrada {
        imprimirRuta(ruta: ruta, origen: origen, destino: destino)
    } else {
        print("\n No se encontró una ruta viable entre \(origen.nombre) y \(destino.nombre).")
    }
}

// =================================
// INFORMACIÓN DE ESTACIONES CERCANAS
// =================================

@MainActor
public func mostrarEstacionesCercanas(_ estacion: Estacion) {
    print("""
    
    📍 ESTACIONES CERCANAS A: \(estacion.nombre)
    ═════════════════════════════════════════
    """)
    
    if let anterior = estacion.estacionAnterior {
        print("⬅️ Anterior:  \(anterior)")
    } else {
        print("⬅️ Anterior:  [Inicio de línea]")
    }
    
    if let siguiente = estacion.estacionSiguiente {
        print("➡️ Siguiente: \(siguiente)")
    } else {
        print("➡️ Siguiente: [Final de línea]")
    }
    
    if estacion.tipo == .intercambio {
        print("\n Estación de Conexión. Conecta con: \(estacion.conexiones.joined(separator: ", "))")
    }
    
    if !estacion.lugaresCercanos.isEmpty {
        print("\n Lugares de interés cercanos:")
        for lugar in estacion.lugaresCercanos {
            print("  • \(lugar)")
        }
    }
    print("═════════════════════════════════════════\n")
}
