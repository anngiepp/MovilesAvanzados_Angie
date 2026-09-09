import Foundation

@MainActor
public func ejecutarOpcionMenú(_ entrada: String) {
    let partes = entrada.components(separatedBy: ",")
    guard let opcionStr = partes.first?.trimmingCharacters(in: .whitespacesAndNewlines),
          let opcion = Int(opcionStr) else {
        print(" Opción no válida. Ingrese un número de 0 a 10.")
        return
    }
    
    switch opcion {
    case 1:
        let termino = partes.count > 1 ? partes[1].trimmingCharacters(in: .whitespaces) : "Grau"
        print("\n --- BÚSQUEDA DE ESTACIÓN ---")
        print("Buscando: '\(termino)'...")
        if let estacion = buscarEstacionInteligente(termino) {
            mostrarInformacionEstacion(estacion)
            mostrarEstacionesCercanas(estacion)
        } else {
            print("\n No se encontró ninguna estación con el término '\(termino)'.")
        }
        
    case 2:
        let origen = partes.count > 1 ? partes[1].trimmingCharacters(in: .whitespaces) : "Villa El Salvador"
        let destino = partes.count > 2 ? partes[2].trimmingCharacters(in: .whitespaces) : "Ate"
        print("\n --- PLANIFICADOR DE RUTAS INTELIGENTE ---")
        print("Origen: \(origen) | Destino: \(destino)")
        calcularRuta(origenNombre: origen, destinoNombre: destino)
        
    case 3:
        print("\n📍 --- TODAS LAS ESTACIONES REGISTRADAS (\(estacionesMetro.count)) ---")
        for e in estacionesMetro.values.sorted(by: { $0.id < $1.id }) {
            print(" • [\(e.id)] \(e.nombre) (\(e.linea)) - \(e.distrito)")
        }
        
    case 4:
        mostrarEstacionesOperativas()
        
    case 5:
        print("\n🟡 --- ESTACIONES EN CONSTRUCCIÓN ---")
        for e in estacionesMetro.values where e.estado == .construccion {
            print(" 🟡 \(e.nombre) (\(e.linea)) - \(e.distrito)")
        }
        
    case 6:
        mostrarProyectosFuturos()
        
    case 7:
        if partes.count > 1 {
            agregarFavorito(estacionNombre: partes[1].trimmingCharacters(in: .whitespaces))
        }
        mostrarFavoritos()
        
    case 8:
        let estacionTurismo = partes.count > 1 ? partes[1].trimmingCharacters(in: .whitespaces) : "Estación Central"
        explorarTurismoEstacion(estacionTurismo)
        
    case 9:
        mostrarEstadisticasAvanzadas()
        
    case 10:
        mostrarHistorial()
        
    case 0:
        print("\n ¡Gracias por utilizar MetroSmart Lima! Buen viaje. MetroSmart Lima v2.0")
        
    default:
        print("\n Opción no válida. Por favor elija un número de 0 a 10.")
    }
}

@MainActor
public func mostrarMenuInteractivo(instruccion: String? = nil) {
    inicializarBaseDatos()
    
    print("""
    
    ╔══════════════════════════════════════════╗
    ║              METRO DE LIMA               ║
    ║        Sistema Inteligente de Transporte ║
    ╚══════════════════════════════════════════╝
     1  Buscar estación (Búsqueda flexible)
     2  Planificar ruta (Algoritmo BFS)
     3 📍 Ver todas las estaciones
     4 🟢 Ver estaciones operativas
     5 🟡 Ver estaciones en construcción
     6 🔴 Ver proyectos futuros
     7  Mis estaciones favoritas
     8  Explorador turístico y entorno
     9  Analítica del sistema
    10  Historial de búsquedas
     0  Salir del sistema
    ════════════════════════════════════════════
    """)
    
    if let instruccion = instruccion {
        ejecutarOpcionMenú(instruccion)
    }
}


// =======================================================
// PANEL DE CONTROL: PRUEBAS EN PLAYGROUND
// =======================================================

// 1. Buscar estación (ingresa el nombre o fragmento)
// mostrarMenuInteractivo(instruccion: "1, grau")

// 2. Planificar ruta entre 2 estaciones (Origen, Destino)
mostrarMenuInteractivo(instruccion: "2, Villa El Salvador, Bayovar")

// 3. Ver todas las estaciones registradas
// mostrarMenuInteractivo(instruccion: "3")

// 4. Ver estaciones operativas (Línea 1 y Tramo Línea 2)
// mostrarMenuInteractivo(instruccion: "4")

// 5. Ver estaciones en construcción
// mostrarMenuInteractivo(instruccion: "5")

// 6. Ver proyectos futuros (Líneas proyectadas)
// mostrarMenuInteractivo(instruccion: "6")

// 7. Mis estaciones favoritas (Agregar y listar)
// mostrarMenuInteractivo(instruccion: "7, Estación Central")

// 8. Explorador turístico y recomendador entorno
// mostrarMenuInteractivo(instruccion: "8, Gamarra")

// 9. Analítica y estadísticas globales del sistema
//mostrarMenuInteractivo(instruccion: "9")

// 10. Consultar historial de búsquedas recientes
// mostrarMenuInteractivo(instruccion: "10")

// 0. Salir del sistema
// mostrarMenuInteractivo(instruccion: "0")
