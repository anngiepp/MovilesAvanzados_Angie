import Foundation

// =================================
// MOTOR DE BÚSQUEDA Y CONSULTAS
// =================================

/// Función 1: Buscar estación por nombre exacto
@MainActor
func buscarEstacion(nombre: String) -> Estacion? {
    return estacionesMetro[nombre]
}

/// Función 2: Mostrar ficha técnica completa de la estación
func mostrarInformacionEstacion(_ estacion: Estacion) {
    print("""
    
    ═══════════════════════════════
            🚇 METRO DE LIMA
    ═══════════════════════════════
    
     Estación:
    \(estacion.nombre)
    
    Código:
    \(estacion.id)
    
     Línea:
    \(estacion.linea)
    
    Color:
    \(estacion.colorLinea)
    
    📍 Distrito:
    \(estacion.distrito)
    
    ═══════════════════════════════
    """)
    
    switch estacion.estado {
    case .operativa:
        print("🟢 Estado: Operativa")
    case .construccion:
        print("🟡 Estado: En construcción")
    case .proyecto:
        print("🔴 Estado: Proyecto futuro")
    }
    
    switch estacion.tipo {
    case .normal:
        print("Tipo: Estación normal")
    case .intercambio:
        print("Tipo: Estación de conexión")
    }
    
    print("""
    
    Conexiones:
    \(estacion.conexiones.isEmpty ? "Sin conexiones adicionales" : estacion.conexiones.joined(separator: ", "))
    
    📌 Estación anterior:
    \(estacion.estacionAnterior ?? "Inicio de ruta")
    
    📌 Estación siguiente:
    \(estacion.estacionSiguiente ?? "Fin de ruta")
    
    Lugares cercanos:
    \(estacion.lugaresCercanos.isEmpty ? "No registrados" : estacion.lugaresCercanos.joined(separator: ", "))
    
    Inicio de ruta:
    \(estacion.destinoInicio)
    
    Final de ruta:
    \(estacion.destinoFinal)
    
    Observación:
    \(estacion.observacion)
    
    ═══════════════════════════════
    """)
}

/// Función 3: Buscar línea por nombre
@MainActor
func buscarLinea(nombre: String) -> Linea? {
    return lineasMetro[nombre]
}

/// Función 4: Mostrar información detallada de la línea
func mostrarLinea(_ linea: Linea) {
    print("""
    
     \(linea.nombre)
    
     Color:
    \(linea.color)
    
     Descripción:
    \(linea.descripcion)
    
    Estaciones:
    """)
    
    for estacion in linea.estaciones {
        print("• \(estacion)")
    }
}

/// Función 5: Listar estaciones operativas
@MainActor
func mostrarEstacionesOperativas() {
    print("\n--- ESTACIONES OPERATIVAS ---")
    for estacion in estacionesMetro.values {
        if estacion.estado == .operativa {
            print("🟢 \(estacion.nombre)")
        }
    }
}

/// Función 6: Listar proyectos futuros
@MainActor
func mostrarProyectosFuturos() {
    print("\n--- PROYECTOS FUTUROS ---")
    for estacion in estacionesMetro.values {
        if estacion.estado == .proyecto {
            print("🔴 \(estacion.nombre)")
        }
    }
}

// =================================
// PRUEBA DE FUNCIONALIDAD
// =================================

@MainActor
func probarSistema() {
    inicializarBaseDatos()
    
    print("Estaciones cargadas en total: \(estacionesMetro.count)")
    
    if let estacion = buscarEstacion(nombre: "Estación Central") {
        mostrarInformacionEstacion(estacion)
    } else {
        print(" Estación no encontrada")
    }
}

probarSistema()
