# Caso 2: Gestión de Biblioteca — Laboratorio 04 (POO en Swift)

Sistema de gestión e inventario de libros para una biblioteca desarrollado en Swift como parte del Laboratorio 04 de Programación Orientada a Objetos.

---

## Requerimientos del Caso

El objetivo principal es implementar un modelo de datos orientado a objetos que aplique los conceptos de **Semántica de Valor vs. Referencia**, **Enumeraciones**, **Estructuras**, **Clases** y **Manejo de Arreglos por Índice** sin hacer uso de métodos avanzados como `firstIndex(where:)` u opcionales complejos.

### 1. Modelado de Datos
* **`EstadoLibro` (Enum):** Define los estados posibles de un ejemplar (`.disponible` y `.prestado`).
* **`Libro` (Struct):** Define la entidad del libro con sus atributos de valor:
  * `titulo: String`
  * `autor: String`
  * `estado: EstadoLibro` (por defecto `.disponible`)
* **`Biblioteca` (Class):** Gestiona la colección de libros en un arreglo (`var libros: [Libro] = []`) y centraliza la lógica de negocio.

---

## 🛠️ Métodos e Implementación Técnica

### `agregar(libro: Libro)`
Añade un nuevo objeto `Libro` al arreglo mutable de la biblioteca.

### `prestar(titulo: String) -> Bool`
* Busca el libro recorriendo el arreglo mediante un bucle por índice (`for i in 0..<libros.count`).
* Si el libro existe y su estado es `.disponible`, actualiza directamente el elemento en el arreglo (`libros[i].estado = .prestado`), imprime la confirmación y retorna `true`.
* Si el libro ya está prestado o no existe en la lista, imprime el mensaje de error correspondiente y retorna `false`.

### `devolver(titulo: String) -> Bool`
* Recorre el arreglo por índice verificando coincidencia de título.
* Si el libro está en estado `.prestado`, lo cambia a `.disponible` en el arreglo (`libros[i].estado = .disponible`), confirma la operación y retorna `true`.
* Si no estaba prestado o no se encuentra en la biblioteca, imprime el error e indica `false`.

### `inventario()`
Recorre la colección e imprime la lista de libros con su respectivo título, autor y representación en cadena del enum utilizando un bloque `switch`.

---

## 🖥️ Simulación y Salida Esperada

El flujo de prueba ejecuta la adición de tres obras, pruebas de préstamos duplicados, devoluciones, búsquedas de títulos inexistentes e impresión del catálogo final.

### Código de Simulación
```swift
let biblioteca = Biblioteca()

biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.devolver(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "El Quijote")
_ = biblioteca.prestar(titulo: "El Principito")

biblioteca.inventario()
