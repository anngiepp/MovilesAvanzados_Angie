import Foundation

// =================================
// HISTORIAL DE CONSULTAS
// =================================

@MainActor public var historialBusquedas: [String] = []

@MainActor
public func registrarEnHistorial(_ busqueda: String) {
    if !busqueda.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        historialBusquedas.insert(busqueda, at: 0)
        if historialBusquedas.count > 5 {
            historialBusquedas.removeLast()
        }
    }
}

@MainActor
public func mostrarHistorial() {
    print("\n--- ÚLTIMAS BÚSQUEDAS ---")
    if historialBusquedas.isEmpty {
        print("No hay búsquedas recientes.")
    } else {
        for (index, item) in historialBusquedas.enumerated() {
            print("\(index + 1). \(item)")
        }
    }
}

// =================================
// BÚSQUEDA INTELIGENTE
// =================================

/// Elimina tildes y diacríticos para facilitar coincidencias
private func normalizarTexto(_ texto: String) -> String {
    return texto
        .folding(options: .diacriticInsensitive, locale: .current)
        .lowercased()
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

@MainActor
public func buscarEstacionInteligente(_ texto: String) -> Estacion? {
    let busqueda = normalizarTexto(texto)
    guard !busqueda.isEmpty else { return nil }
    
    // 1. Coincidencia exacta
    for estacion in estacionesMetro.values {
        if normalizarTexto(estacion.nombre) == busqueda {
            registrarEnHistorial(estacion.nombre)
            return estacion
        }
    }
    
    // 2. Coincidencia parcial (que empiece o contenga el término)
    for estacion in estacionesMetro.values {
        if normalizarTexto(estacion.nombre).contains(busqueda) {
            registrarEnHistorial(estacion.nombre)
            return estacion
        }
    }
    
    return nil
}
