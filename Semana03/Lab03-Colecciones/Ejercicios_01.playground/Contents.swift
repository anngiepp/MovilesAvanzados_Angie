import Foundation

//TODO 1
var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}

print("\nAlumnos registrados: \(alumnos)")
print("Total de alumnos: \(alumnos.count)")

//TODO 2
print("\nBuscar alumno:")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista.")
} else {
    print("\(buscar) NO está en la lista.")
}

//TODO 3
var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i):")
    let entrada = readLine() ?? ""
    let n = Double(entrada) ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota

    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

let promedio = sumaNotas / Double(notasClase.count)

print("\nNotas ingresadas: \(notasClase)")
print("Total de notas: \(notasClase.count)")
print("Suma de notas: \(sumaNotas)")
print("Promedio: \(promedio)")
print("Nota más alta: \(notasClase.max()!)")
print("Nota más baja: \(notasClase.min()!)")
print("Notas ordenadas: \(notasClase.sorted())")
print("Aprobados: \(aprobados)")
print("Desaprobados: \(desaprobados)")


// FIX
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("7")   // FIX 1: el arreglo deberia llamar a un String

var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")   // FIX 2: let es una constante inmutable

let numeros = [10, 20, 30, 40, 50]
print(numeros[4])   // FIX 3: Al tener 5 elementos solo tiene 4 indices empezando desde el 0 al 4
