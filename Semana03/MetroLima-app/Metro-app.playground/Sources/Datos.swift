import Foundation

// =================================
// BASE DE DATOS GLOBAL
// =================================

@MainActor public var estacionesMetro: [String: Estacion] = [:]
@MainActor public var lineasMetro: [String: Linea] = [:]

// =================================
// HELPER PARA AGREGAR ESTACIONES
// =================================

@MainActor
public func agregarEstacion(
    id: String,
    nombre: String,
    linea: String,
    color: String,
    estado: EstadoEstacion,
    tipo: TipoEstacion,
    distrito: String,
    anterior: String?,
    siguiente: String?,
    conexiones: [String] = [],
    lugares: [String] = [],
    inicio: String = "Villa El Salvador",
    final: String = "Bayóvar",
    observacion: String = "Estación de Línea"
) {
    estacionesMetro[nombre] = Estacion(
        id: id,
        nombre: nombre,
        linea: linea,
        colorLinea: color,
        estado: estado,
        tipo: tipo,
        distrito: distrito,
        estacionAnterior: anterior,
        estacionSiguiente: siguiente,
        conexiones: conexiones,
        lugaresCercanos: lugares,
        destinoInicio: inicio,
        destinoFinal: final,
        observacion: observacion
    )
}

// =================================
// CARGA DE LÍNEAS DE METRO
// =================================

@MainActor
public func cargarLineas() {
    lineasMetro["Línea 1"] = Linea(
        nombre: "Línea 1", color: "Verde", estado: .operativa,
        estaciones: [
            "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
            "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez",
            "Ayacucho", "Cabitos", "Angamos", "San Borja Sur",
            "Javier Prado", "Nicolás Arriola", "Gamarra", "Grau",
            "El Ángel", "Presbítero Maestro", "Caja de Agua", "Pirámide del Sol",
            "Los Jardines", "Los Postes", "San Carlos", "San Martín",
            "Santa Rosa", "Bayóvar"
        ],
        descripcion: "Primera línea operativa del Metro de Lima (Sur a Norte)"
    )

    lineasMetro["Línea 2"] = Linea(
        nombre: "Línea 2", color: "Amarillo", estado: .construccion,
        estaciones: ["Mercado Santa Anita", "Hermilio Valdizán", "Colectora Industrial", "Óvalo Santa Anita", "Evitamiento"],
        descripcion: "Línea subterránea Este-Oeste en construcción/operación parcial"
    )

    lineasMetro["Línea 3"] = Linea(nombre: "Línea 3", color: "Azul", estado: .proyecto, estaciones: [], descripcion: "Proyecto corredor Norte-Sur")
    lineasMetro["Línea 4"] = Linea(nombre: "Línea 4", color: "Rojo", estado: .proyecto, estaciones: [], descripcion: "Proyecto Ramal Faucett - Gambetta")
    lineasMetro["Línea 5"] = Linea(nombre: "Línea 5", color: "Marrón", estado: .proyecto, estaciones: [], descripcion: "Proyecto corredor Chorrillos")
    lineasMetro["Línea 6"] = Linea(nombre: "Línea 6", color: "Gris", estado: .proyecto, estaciones: [], descripcion: "Proyecto corredor Suburbano")
}

// =================================
// CARGA COMPLETA: LÍNEA 1 (26 ESTACIONES)
// =================================

@MainActor
public func cargarEstacionesLinea1() {
    let l1 = "Línea 1"
    let verde = "Verde"
    
    agregarEstacion(id: "L1-01", nombre: "Villa El Salvador", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Villa El Salvador", anterior: nil, siguiente: "Parque Industrial", lugares: ["Parque Zonal Huáscar"], observacion: "Terminal Sur")
    agregarEstacion(id: "L1-02", nombre: "Parque Industrial", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Villa El Salvador", anterior: "Villa El Salvador", siguiente: "Pumacahua", lugares: ["Zona Industrial VES"])
    agregarEstacion(id: "L1-03", nombre: "Pumacahua", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Villa María del Triunfo", anterior: "Parque Industrial", siguiente: "Villa María", lugares: ["Av. Pumacahua"])
    agregarEstacion(id: "L1-04", nombre: "Villa María", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Villa María del Triunfo", anterior: "Pumacahua", siguiente: "María Auxiliadora", lugares: ["Plaza de Armas VMT"])
    agregarEstacion(id: "L1-05", nombre: "María Auxiliadora", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Miraflores", anterior: "Villa María", siguiente: "San Juan", lugares: ["Hospital María Auxiliadora"])
    agregarEstacion(id: "L1-06", nombre: "San Juan", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Miraflores", anterior: "María Auxiliadora", siguiente: "Atocongo", lugares: ["CT San Juan"])
    agregarEstacion(id: "L1-07", nombre: "Atocongo", linea: l1, color: verde, estado: .operativa, tipo: .intercambio, distrito: "San Juan de Miraflores", anterior: "San Juan", siguiente: "Jorge Chávez", conexiones: ["Línea 3"], lugares: ["Open Plaza Atocongo", "Mall del Sur"])
    agregarEstacion(id: "L1-08", nombre: "Jorge Chávez", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Santiago de Surco", anterior: "Atocongo", siguiente: "Ayacucho", lugares: ["Av. Jorge Chávez"])
    agregarEstacion(id: "L1-09", nombre: "Ayacucho", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Santiago de Surco", anterior: "Jorge Chávez", siguiente: "Cabitos", lugares: ["Plaza Vea Ayacucho"])
    agregarEstacion(id: "L1-10", nombre: "Cabitos", linea: l1, color: verde, estado: .operativa, tipo: .intercambio, distrito: "Santiago de Surco", anterior: "Ayacucho", siguiente: "Angamos", conexiones: ["Línea 3"], lugares: ["Óvalo Higuereta", "Polvos Rosados"])
    agregarEstacion(id: "L1-11", nombre: "Angamos", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Borja", anterior: "Cabitos", siguiente: "San Borja Sur", lugares: ["Real Plaza Primavera", "INEN"])
    agregarEstacion(id: "L1-12", nombre: "San Borja Sur", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Borja", anterior: "Angamos", siguiente: "Javier Prado", lugares: ["Av. Aviación"])
    agregarEstacion(id: "L1-13", nombre: "Javier Prado", linea: l1, color: verde, estado: .operativa, tipo: .intercambio, distrito: "San Borja", anterior: "San Borja Sur", siguiente: "Nicolás Arriola", conexiones: ["Línea 4"], lugares: ["Gran Teatro Nacional", "Biblioteca Nacional", "Centro Empresarial"])
    agregarEstacion(id: "L1-14", nombre: "Nicolás Arriola", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "La Victoria", anterior: "Javier Prado", siguiente: "Gamarra", lugares: ["Mercado Mayorista de Frutas"])
    agregarEstacion(id: "L1-15", nombre: "Gamarra", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "La Victoria", anterior: "Nicolás Arriola", siguiente: "Grau", lugares: ["Emporio Comercial Gamarra", "Parque Cánepa"])
    agregarEstacion(id: "L1-16", nombre: "Grau", linea: l1, color: verde, estado: .operativa, tipo: .intercambio, distrito: "Cercado de Lima", anterior: "Gamarra", siguiente: "El Ángel", conexiones: ["Línea 2"], lugares: ["Hospital Dos de Mayo", "Mercado Central"], observacion: "Punto de conexión con Línea 2")
    agregarEstacion(id: "L1-17", nombre: "El Ángel", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "El Agustino", anterior: "Grau", siguiente: "Presbítero Maestro", lugares: ["Cementerio El Ángel"])
    agregarEstacion(id: "L1-18", nombre: "Presbítero Maestro", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "Cercado de Lima", anterior: "El Ángel", siguiente: "Caja de Agua", lugares: ["Museo Cementerio Presbítero Maestro"])
    agregarEstacion(id: "L1-19", nombre: "Caja de Agua", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Presbítero Maestro", siguiente: "Pirámide del Sol", lugares: ["Entrada a SJL"])
    agregarEstacion(id: "L1-20", nombre: "Pirámide del Sol", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Caja de Agua", siguiente: "Los Jardines", lugares: ["Av. Pirámide del Sol"])
    agregarEstacion(id: "L1-21", nombre: "Los Jardines", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Pirámide del Sol", siguiente: "Los Postes", lugares: ["C.C. Los Jardines"])
    agregarEstacion(id: "L1-22", nombre: "Los Postes", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Los Jardines", siguiente: "San Carlos", lugares: ["Av. Los Postes"])
    agregarEstacion(id: "L1-23", nombre: "San Carlos", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Los Postes", siguiente: "San Martín", lugares: ["Universidad Cibertec SJL", "UTP"])
    agregarEstacion(id: "L1-24", nombre: "San Martín", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "San Carlos", siguiente: "Santa Rosa", lugares: ["Av. Canto Grande"])
    agregarEstacion(id: "L1-25", nombre: "Santa Rosa", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "San Martín", siguiente: "Bayóvar", lugares: ["Av. Santa Rosa"])
    agregarEstacion(id: "L1-26", nombre: "Bayóvar", linea: l1, color: verde, estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho", anterior: "Santa Rosa", siguiente: nil, lugares: ["Parque Zonal Huiracocha"], observacion: "Terminal Norte")
}

// =================================
// CARGA: LÍNEA 2 (22 ESTACIONES)
// =================================

@MainActor
public func cargarEstacionesLinea2() {
    let l2 = "Línea 2"
    let amarillo = "Amarillo"
    let ini = "Puerto del Callao"
    let fin = "Municipalidad de Ate"
    
    // Tramo 1A (Operativo)
    agregarEstacion(id: "L2-01", nombre: "Evitamiento", linea: l2, color: amarillo, estado: .operativa, tipo: .normal, distrito: "Ate", anterior: "San Juan de Dios", siguiente: "Óvalo Santa Anita", inicio: ini, final: fin, observacion: "Tramo 1A Operativo")
    agregarEstacion(id: "L2-02", nombre: "Óvalo Santa Anita", linea: l2, color: amarillo, estado: .operativa, tipo: .normal, distrito: "Ate", anterior: "Evitamiento", siguiente: "Hermilio Valdizán", inicio: ini, final: fin, observacion: "Tramo 1A Operativo")
    agregarEstacion(id: "L2-03", nombre: "Hermilio Valdizán", linea: l2, color: amarillo, estado: .operativa, tipo: .normal, distrito: "Santa Anita", anterior: "Óvalo Santa Anita", siguiente: "Colectora Industrial", inicio: ini, final: fin, observacion: "Tramo 1A Operativo")
    agregarEstacion(id: "L2-04", nombre: "Mercado Santa Anita", linea: l2, color: amarillo, estado: .operativa, tipo: .normal, distrito: "Santa Anita", anterior: "Colectora Industrial", siguiente: "Vista Alegre", inicio: ini, final: fin, observacion: "Terminal Este (Tramo 1A)")
    
    // Tramos en Construcción
    agregarEstacion(id: "L2-05", nombre: "Puerto del Callao", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: nil, siguiente: "Buenos Aires", inicio: ini, final: fin, observacion: "Terminal Oeste en obra")
    agregarEstacion(id: "L2-06", nombre: "Buenos Aires", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Puerto del Callao", siguiente: "Oscar R. Benavides", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-07", nombre: "Oscar R. Benavides", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Buenos Aires", siguiente: "Insurgentes", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-08", nombre: "Insurgentes", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Oscar R. Benavides", siguiente: "Carmen de la Legua", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-09", nombre: "Carmen de la Legua", linea: l2, color: amarillo, estado: .construccion, tipo: .intercambio, distrito: "Callao", anterior: "Insurgentes", siguiente: "Tingo María", conexiones: ["Línea 4"], inicio: ini, final: fin, observacion: "Conexión Ramal L4")
    agregarEstacion(id: "L2-10", nombre: "Tingo María", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Lima", anterior: "Carmen de la Legua", siguiente: "Plaza Bolognesi", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-11", nombre: "Plaza Bolognesi", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Lima", anterior: "Tingo María", siguiente: "Estación Central", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-12", nombre: "Estación Central", linea: l2, color: amarillo, estado: .construccion, tipo: .intercambio, distrito: "Lima", anterior: "Plaza Bolognesi", siguiente: "Plaza Manco Cápac", conexiones: ["Línea 3", "Metropolitano"], inicio: ini, final: fin, observacion: "Gran Hub de Interconexión")
    agregarEstacion(id: "L2-13", nombre: "Plaza Manco Cápac", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "La Victoria", anterior: "Estación Central", siguiente: "28 de Julio", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-14", nombre: "28 de Julio", linea: l2, color: amarillo, estado: .construccion, tipo: .intercambio, distrito: "La Victoria", anterior: "Plaza Manco Cápac", siguiente: "Cangallo", conexiones: ["Línea 1"], inicio: ini, final: fin, observacion: "Conexión con L1 Grau")
    agregarEstacion(id: "L2-15", nombre: "Cangallo", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "La Victoria", anterior: "28 de Julio", siguiente: "Nicolás Ayllón", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-16", nombre: "Nicolás Ayllón", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Cangallo", siguiente: "Circunvalación", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-17", nombre: "Circunvalación", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Nicolás Ayllón", siguiente: "San Juan de Dios", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-18", nombre: "San Juan de Dios", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Circunvalación", siguiente: "Evitamiento", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-19", nombre: "Colectora Industrial", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Hermilio Valdizán", siguiente: "Mercado Santa Anita", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-20", nombre: "Vista Alegre", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Mercado Santa Anita", siguiente: "Prolongación Javier Prado", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-21", nombre: "Prolongación Javier Prado", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Vista Alegre", siguiente: "Municipalidad de Ate", inicio: ini, final: fin, observacion: "En obra")
    agregarEstacion(id: "L2-22", nombre: "Municipalidad de Ate", linea: l2, color: amarillo, estado: .construccion, tipo: .normal, distrito: "Ate", anterior: "Prolongación Javier Prado", siguiente: nil, inicio: ini, final: fin, observacion: "Terminal Este final")
}

// =================================
// CARGA: LÍNEA 3 (PROYECTO)
// =================================

@MainActor
public func cargarEstacionesLinea3() {
    let l3 = "Línea 3"
    let azul = "Azul"
    let ini = "El Álamo (Comas)"
    let fin = "Pedro de Osma (Barranco)"
    
    agregarEstacion(id: "L3-01", nombre: "El Álamo", linea: l3, color: azul, estado: .proyecto, tipo: .normal, distrito: "Comas", anterior: nil, siguiente: "Huandoy", inicio: ini, final: fin, observacion: "Proyecto Corredor Norte")
    agregarEstacion(id: "L3-02", nombre: "Izaguirre", linea: l3, color: azul, estado: .proyecto, tipo: .normal, distrito: "Los Olivos", anterior: "Huandoy", siguiente: "Tomas Valle", inicio: ini, final: fin, observacion: "Proyecto Corredor Norte")
    agregarEstacion(id: "L3-03", nombre: "UNI", linea: l3, color: azul, estado: .proyecto, tipo: .normal, distrito: "Rímac", anterior: "Tomas Valle", siguiente: "Plaza Acho", inicio: ini, final: fin, observacion: "Conexión Universitaria")
    agregarEstacion(id: "L3-04", nombre: "Arequipa", linea: l3, color: azul, estado: .proyecto, tipo: .normal, distrito: "Lima", anterior: "Estación Central", siguiente: "Javier Prado L3", inicio: ini, final: fin, observacion: "Eje Av. Arequipa")
}

// =================================
// CARGA: LÍNEA 4 (RAMAL Y PROYECTO)
// =================================

@MainActor
public func cargarEstacionesLinea4() {
    let l4 = "Línea 4"
    let rojo = "Rojo"
    let ini = "Gambetta"
    let fin = "Mercado Santa Anita"
    
    agregarEstacion(id: "L4-01", nombre: "Gambetta", linea: l4, color: rojo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: nil, siguiente: "Canta Callao", inicio: ini, final: fin, observacion: "Ramal L4")
    agregarEstacion(id: "L4-02", nombre: "Canta Callao", linea: l4, color: rojo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Gambetta", siguiente: "Aeropuerto", inicio: ini, final: fin, observacion: "Ramal L4")
    agregarEstacion(id: "L4-03", nombre: "Aeropuerto", linea: l4, color: rojo, estado: .construccion, tipo: .intercambio, distrito: "Callao", anterior: "Canta Callao", siguiente: "El Olivar", conexiones: ["Aeropuerto Jorge Chávez"], inicio: ini, final: fin, observacion: "Acceso al Aeropuerto Internacional")
    agregarEstacion(id: "L4-04", nombre: "El Olivar", linea: l4, color: rojo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Aeropuerto", siguiente: "Quilca", inicio: ini, final: fin, observacion: "Ramal L4")
    agregarEstacion(id: "L4-05", nombre: "Quilca", linea: l4, color: rojo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "El Olivar", siguiente: "Morales Duárez", inicio: ini, final: fin, observacion: "Ramal L4")
    agregarEstacion(id: "L4-06", nombre: "Morales Duárez", linea: l4, color: rojo, estado: .construccion, tipo: .normal, distrito: "Callao", anterior: "Quilca", siguiente: "Carmen de la Legua L4", inicio: ini, final: fin, observacion: "Ramal L4")
}

// =================================
// CARGA: LÍNEAS 5 Y 6 (PROYECTOS FUTUROS)
// =================================

@MainActor
public func cargarEstacionesLineas5y6() {
    let l5 = "Línea 5"
    let marron = "Marrón"
    agregarEstacion(id: "L5-01", nombre: "Huaylas", linea: l5, color: marron, estado: .proyecto, tipo: .normal, distrito: "Chorrillos", anterior: nil, siguiente: "Villa", inicio: "Chorrillos", final: "Km 26", observacion: "Proyecto Corredor Sur")
    agregarEstacion(id: "L5-02", nombre: "Villa", linea: l5, color: marron, estado: .proyecto, tipo: .normal, distrito: "Chorrillos", anterior: "Huaylas", siguiente: nil, inicio: "Chorrillos", final: "Km 26", observacion: "Proyecto Corredor Sur")

    let l6 = "Línea 6"
    let gris = "Gris"
    agregarEstacion(id: "L6-01", nombre: "Universitaria", linea: l6, color: gris, estado: .proyecto, tipo: .normal, distrito: "Los Olivos", anterior: nil, siguiente: "Venezuela", inicio: "Túpac Amaru", final: "Javier Prado", observacion: "Proyecto Corredor Suburbano")
    agregarEstacion(id: "L6-02", nombre: "Venezuela", linea: l6, color: gris, estado: .proyecto, tipo: .normal, distrito: "San Miguel", anterior: "Universitaria", siguiente: nil, inicio: "Túpac Amaru", final: "Javier Prado", observacion: "Proyecto Corredor Suburbano")
}

// =================================
// INICIALIZACIÓN GENERAL
// =================================

@MainActor
public func inicializarBaseDatos() {
    guard estacionesMetro.isEmpty else { return }
    cargarLineas()
    cargarEstacionesLinea1()
    cargarEstacionesLinea2()
    cargarEstacionesLinea3()
    cargarEstacionesLinea4()
    cargarEstacionesLineas5y6()
}

// =================================
// FUNCIONES PÚBLICAS DE CONSULTA
// =================================

@MainActor
public func buscarEstacion(nombre: String) -> Estacion? {
    return estacionesMetro[nombre]
}

public func mostrarInformacionEstacion(_ estacion: Estacion) {
    print("""
    
    ═══════════════════════════════
             METRO DE LIMA
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

@MainActor
public func buscarLinea(nombre: String) -> Linea? {
    return lineasMetro[nombre]
}

public func mostrarLinea(_ linea: Linea) {
    print("""
    
    🚈 \(linea.nombre)
    
     Color:
    \(linea.color)
    
    📌 Descripción:
    \(linea.descripcion)
    
    Estaciones:
    """)
    
    for estacion in linea.estaciones {
        print("• \(estacion)")
    }
}

@MainActor
public func mostrarEstacionesOperativas() {
    print("\n--- ESTACIONES OPERATIVAS ---")
    for estacion in estacionesMetro.values {
        if estacion.estado == .operativa {
            print("🟢 \(estacion.nombre)")
        }
    }
}

@MainActor
public func mostrarProyectosFuturos() {
    print("\n--- PROYECTOS FUTUROS ---")
    for estacion in estacionesMetro.values {
        if estacion.estado == .proyecto {
            print("🔴 \(estacion.nombre)")
        }
    }
}

@MainActor
public func mostrarEstadisticas() {
    let total = estacionesMetro.count
    let operativas = estacionesMetro.values.filter { $0.estado == .operativa }.count
    let construccion = estacionesMetro.values.filter { $0.estado == .construccion }.count
    let proyectos = estacionesMetro.values.filter { $0.estado == .proyecto }.count
    let conexiones = estacionesMetro.values.filter { $0.tipo == .intercambio }.count
    
    print("""
    
     --- ESTADÍSTICAS DEL SISTEMA ---
    Total de estaciones: \(total)
    🟢 Operativas: \(operativas)
    🟡 En construcción: \(construccion)
    🔴 Proyectos: \(proyectos)
     Nodos de intercambio: \(conexiones)
    """)
}
