import Foundation

public enum EstadoEstacion {
    case operativa
    case construccion
    case proyecto
}

public enum TipoEstacion {
    case normal
    case intercambio
}

public struct Estacion {
    public let id: String
    public let nombre: String
    public let linea: String
    public let colorLinea: String
    public let estado: EstadoEstacion
    public let tipo: TipoEstacion
    public let distrito: String
    public let estacionAnterior: String?
    public let estacionSiguiente: String?
    public let conexiones: [String]
    public let lugaresCercanos: [String]
    public let destinoInicio: String
    public let destinoFinal: String
    public let observacion: String

    public init(id: String, nombre: String, linea: String, colorLinea: String, estado: EstadoEstacion, tipo: TipoEstacion, distrito: String, estacionAnterior: String?, estacionSiguiente: String?, conexiones: [String], lugaresCercanos: [String], destinoInicio: String, destinoFinal: String, observacion: String) {
        self.id = id
        self.nombre = nombre
        self.linea = linea
        self.colorLinea = colorLinea
        self.estado = estado
        self.tipo = tipo
        self.distrito = distrito
        self.estacionAnterior = estacionAnterior
        self.estacionSiguiente = estacionSiguiente
        self.conexiones = conexiones
        self.lugaresCercanos = lugaresCercanos
        self.destinoInicio = destinoInicio
        self.destinoFinal = destinoFinal
        self.observacion = observacion
    }
}

public struct Linea {
    public let nombre: String
    public let color: String
    public let estado: EstadoEstacion
    public let estaciones: [String]
    public let descripcion: String

    public init(nombre: String, color: String, estado: EstadoEstacion, estaciones: [String], descripcion: String) {
        self.nombre = nombre
        self.color = color
        self.estado = estado
        self.estaciones = estaciones
        self.descripcion = descripcion
    }
}
