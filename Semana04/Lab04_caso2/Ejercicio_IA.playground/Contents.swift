// ===== CASO 2 — PARTE B: BIBLIOTECA (CON IA) =====

// Enum para representar los dos únicos estados en los que puede estar un libro
enum EstadoLibro {
    case disponible // El libro se encuentra en la biblioteca para ser prestado
    case prestado   // El libro ya fue entregado a un usuario
}

// Struct de tipo valor para definir los datos de cada libro individual
struct Libro {
    let titulo: String               // Nombre o título descriptivo del libro
    let autor: String                // Nombre del autor que escribió el libro
    var estado: EstadoLibro = .disponible // Estado inicial que por defecto es disponible
}

// Clase de tipo referencia que gestiona la colección completa de libros
class Biblioteca {
    var libros: [Libro] = [] // Arreglo mutable que almacena la lista de libros

    // Método que añade un objeto Libro al arreglo de la biblioteca
    func agregar(libro: Libro) {
        libros.append(libro) // Agrega el struct Libro al final de la lista
    }

    // Método para prestar un libro buscando por su título
    func prestar(titulo: String) -> Bool {
        // Recorre el arreglo por índice para modificar directamente la struct en el arreglo
        for i in 0..<libros.count {
            // Evalúa si el título en la posición 'i' coincide con el parámetro
            if libros[i].titulo == titulo {
                // Comprueba si el estado actual es disponible
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado // Modifica el struct DENTRO del array (una copia no serviría)
                    print("Préstamo aprobado: \(titulo)") // Imprime confirmación de éxito
                    return true // Devuelve verdadero finalizando la función
                } else {
                    print("Error: \(titulo) ya está prestado") // Informa el error si no está disponible
                    return false // Devuelve falso indicando que falló la operación
                }
            }
        }
        print("Error: no existe \(titulo)") // Informa si terminó el ciclo sin encontrar el libro
        return false // Devuelve falso si el título no fue hallado
    }

    // Método para registrar la devolución de un libro prestado
    func devolver(titulo: String) -> Bool {
        // Bucle tradicional que itera sobre cada índice válido del array
        for i in 0..<libros.count {
            // Verifica coincidencia entre el título buscado y el libro en la posición i
            if libros[i].titulo == titulo {
                // Evalúa si el libro está marcado actualmente como prestado
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible // Cambia el estado directo en el arreglo
                    print("Devolución registrada: \(titulo)") // Imprime la confirmación
                    return true // Devuelve verdadero confirmando la devolución
                } else {
                    print("Error: \(titulo) no está prestado") // Notifica que no estaba prestado
                    return false // Retorna falso si no se pudo devolver
                }
            }
        }
        print("Error: no existe \(titulo)") // Notifica que el libro no existe en el catálogo
        return false // Retorna falso al no encontrar coincidencia
    }

    // Método que imprime en consola el reporte completo de los libros
    func inventario() {
        print("===== INVENTARIO =====") // Imprime la cabecera del reporte
        // Recorre cada libro contenido en la colección de la biblioteca
        for libro in libros {
            var estadoTexto = "" // Variable temporal para guardar la representación en texto
            // Switch exhaustivo para mapear el enum a una cadena de texto
            switch libro.estado {
            case .disponible:
                estadoTexto = "disponible" // Asigna la palabra disponible
            case .prestado:
                estadoTexto = "prestado"   // Asigna la palabra prestado
            }
            // Imprime los datos del libro formateados como la salida esperada
            print("\(libro.titulo) (\(libro.autor)) - \(estadoTexto)")
        }
    }
}

// --- Simulación ---
let biblioteca = Biblioteca() // Instancia de la clase Biblioteca

// Registro de los libros solicitados
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez")) // Añade libro 1
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))     // Añade libro 2
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))             // Añade libro 3

// Ejecución de pruebas de préstamo y devolución
_ = biblioteca.prestar(titulo: "La ciudad y los perros")  // Primer préstamo (exitoso)
_ = biblioteca.prestar(titulo: "La ciudad y los perros")  // Segundo préstamo (falla por estar prestado)
_ = biblioteca.devolver(titulo: "La ciudad y los perros") // Devolución (exitosa)
_ = biblioteca.prestar(titulo: "El Quijote")              // Préstamo (exitoso)
_ = biblioteca.prestar(titulo: "El Principito")           // Préstamo (falla por no existir)

// Muestra la lista final del inventario
biblioteca.inventario() // Imprime el listado final
