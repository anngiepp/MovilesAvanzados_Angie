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
