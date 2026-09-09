import Foundation


enum EstadoEstacion {
    case operativa
    case construccion
    case proyecto
}


enum TipoEstacion {
    case normal
    case intercambio
}


struct Estacion {
    
    let id: String
    let nombre: String
    let linea: String
    let colorLinea: String
    
    let estado: EstadoEstacion
    let tipo: TipoEstacion
    
    let distrito: String
    
    let estacionAnterior: String?
    let estacionSiguiente: String?
    
    let conexiones: [String]
    
    let lugaresCercanos: [String]
    
    let destinoInicio: String
    let destinoFinal: String
    
    let observacion: String
}


struct Linea {
    
    let nombre: String
    let color: String
    let estado: EstadoEstacion
    
    let estaciones: [String]
    
    let descripcion: String
}
