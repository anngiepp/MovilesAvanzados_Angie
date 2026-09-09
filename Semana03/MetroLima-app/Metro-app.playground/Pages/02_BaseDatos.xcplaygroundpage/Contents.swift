import Foundation

// =================================
// CARGA DE LÍNEAS
// =================================

@MainActor
func cargarLineas() {
    let linea1 = Linea(
        nombre: "Línea 1",
        color: "Verde",
        estado: .operativa,
        estaciones: [
            "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
            "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez",
            "Ayacucho", "Cabitos", "Angamos", "San Borja Sur",
            "Javier Prado", "Nicolás Arriola", "Gamarra", "Grau",
            "El Ángel", "Presbítero Maestro", "Caja de Agua", "Pirámide del Sol",
            "Los Jardines", "Los Postes", "San Carlos", "San Martín",
            "Santa Rosa", "Bayóvar"
        ],
        descripcion: "Primera línea operativa del Metro de Lima"
    )
    
    let linea2 = Linea(
        nombre: "Línea 2",
        color: "Amarillo",
        estado: .construccion,
        estaciones: [
            "Mercado Santa Anita", "Hermilio Valdizán", "Colectora Industrial",
            "Óvalo Santa Anita", "Evitamiento", "Puerto del Callao", "Buenos Aires",
            "Oscar R. Benavides", "Insurgentes", "Carmen de la Legua", "Tingo María",
            "Plaza Bolognesi", "Estación Central", "Plaza Manco Cápac", "28 de Julio",
            "Cangallo", "Nicolás Ayllón", "Circunvalación", "San Juan de Dios",
            "Vista Alegre", "Prolongación Javier Prado", "Municipalidad de Ate"
        ],
        descripcion: "Línea parcialmente operativa y en expansión"
    )

    let linea3 = Linea(
        nombre: "Línea 3", color: "Azul", estado: .proyecto,
        estaciones: ["Puente Piedra", "Pro", "Naranjal", "Izaguirre", "Tomas Valle", "UNI", "Plaza Acho", "Plaza de Armas", "Estación Central", "Arequipa", "Javier Prado", "Miraflores / Pardo", "Cabitos", "Atocongo"],
        descripcion: "Línea proyectada del Metro de Lima"
    )

    let linea4 = Linea(
        nombre: "Línea 4", color: "Rojo", estado: .proyecto,
        estaciones: ["Gambetta", "Canta Callao", "Aeropuerto", "El Olivar", "Quilca", "Morales Duárez", "Carmen de la Legua", "Faucett", "Avenida Marina", "Pershing", "Salaverry", "Javier Prado Norte", "La Encalada", "Pachacútec"],
        descripcion: "Ramal proyectado hacia el Callao"
    )

    let linea5 = Linea(
        nombre: "Línea 5", color: "Marrón", estado: .proyecto,
        estaciones: ["Miguel Grau", "Paseo de la República", "Bolognesi", "Huaylas", "Chorrillos", "Villa", "Km. 26"],
        descripcion: "Proyecto futuro de transporte ferroviario"
    )

    let linea6 = Linea(
        nombre: "Línea 6", color: "Gris", estado: .proyecto,
        estaciones: ["Túpac Amaru", "Independencia", "Universitaria", "José Granda", "Quilca", "Venezuela", "Tingo María", "Sucre", "Ejército", "Pardo"],
        descripcion: "Proyecto futuro del Metro de Lima"
    )

    lineasMetro["Línea 1"] = linea1
    lineasMetro["Línea 2"] = linea2
    lineasMetro["Línea 3"] = linea3
    lineasMetro["Línea 4"] = linea4
    lineasMetro["Línea 5"] = linea5
    lineasMetro["Línea 6"] = linea6
}

// =================================
// CARGA DE ESTACIONES PRINCIPALES
// =================================

@MainActor
func cargarEstaciones() {
    estacionesMetro["Villa El Salvador"] = Estacion(
        id: "L1-001", nombre: "Villa El Salvador", linea: "Línea 1", colorLinea: "Verde",
        estado: .operativa, tipo: .normal, distrito: "Villa El Salvador",
        estacionAnterior: nil, estacionSiguiente: "Parque Industrial", conexiones: [],
        lugaresCercanos: ["Parque Zonal Huáscar"], destinoInicio: "Villa El Salvador", destinoFinal: "Bayóvar",
        observacion: "Inicio de la Línea 1"
    )

    estacionesMetro["Grau"] = Estacion(
        id: "L1-016", nombre: "Grau", linea: "Línea 1", colorLinea: "Verde",
        estado: .operativa, tipo: .intercambio, distrito: "Cercado de Lima",
        estacionAnterior: "Gamarra", estacionSiguiente: "El Ángel", conexiones: ["Línea 2"],
        lugaresCercanos: ["Mercado Central", "Parque Universitario", "Hospital Dos de Mayo"],
        destinoInicio: "Villa El Salvador", destinoFinal: "Bayóvar", observacion: "Estación de conexión"
    )

    estacionesMetro["Bayóvar"] = Estacion(
        id: "L1-026", nombre: "Bayóvar", linea: "Línea 1", colorLinea: "Verde",
        estado: .operativa, tipo: .normal, distrito: "San Juan de Lurigancho",
        estacionAnterior: "Santa Rosa", estacionSiguiente: nil, conexiones: [],
        lugaresCercanos: ["Parque Zonal Huiracocha"], destinoInicio: "Villa El Salvador", destinoFinal: "Bayóvar",
        observacion: "Final de la Línea 1"
    )
}

// =================================
// EJECUCIÓN Y PRUEBA
// =================================

cargarLineas()
cargarEstaciones()

print("Líneas cargadas correctamente: \(lineasMetro.count)")
print("Estaciones de prueba cargadas: \(estacionesMetro.count)")
