# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada
Claude / ChatGPT

## Caso 2B — Biblioteca

### Prompt 1:
"Soy estudiante de Swift, cuarta semana, trabajo en un Playground de Xcode. Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con prestar, devolver e inventario. Restricciones: solo struct, class, herencia, enum, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genéricos. Solo el código Swift, con las firmas exactas que te indico. La salida esperada debe ser idéntica a: 
Préstamo aprobado: La ciudad y los perros
Error: La ciudad y los perros ya está prestado
Devolución registrada: La ciudad y los perros
Préstamo aprobado: El Quijote
Error: no existe El Principito
===== INVENTARIO =====
Cien años de soledad (Gabriel García Márquez) - disponible
La ciudad y los perros (Mario Vargas Llosa) - disponible
El Quijote (Miguel de Cervantes) - prestado"

### Respuesta de la IA:
La IA generó la estructura solicitada respetando el uso del arreglo con bucles tradicionales e índices `for i in 0..<libros.count` y el formateo exacto de la salida en consola.

### ¿Funcionó a la primera?
Sí, al especificar estrictamente no utilizar `firstIndex(where:)` ni opcionales, entregó el código usando ciclos `for` por índice sin errores de compilación.

### ¿Usó algo que no hemos visto en clase?
No, debido a las restricciones colocadas en el prompt se adaptó exclusivamente a los conceptos vistos en clase (POO básica, Structs, Enums y Arrays).

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?
Ambas soluciones fueron prácticamente idénticas en lógica estructurada debido a las restricciones de firma y sintaxis. La IA agregó comentarios detallados por cada línea.

### ¿Hay alguna línea de la IA que no entiendo del todo?
No, todas las instrucciones se comprenden claramente ya que emplean variables locales, condicionales `if-else` y bucles `for-in` estándar.

### ¿Qué me pareció mejor de MI versión?
Mi versión es más limpia y directa de leer sin tener un exceso de comentarios explicativos en cada línea.

### ¿Qué me pareció mejor de la versión de la IA?
La versión de la IA es muy útil para documentación pedagógica, ya que explica la razón de cada asignación y modificación sobre los structs dentro de los arreglos.
