# Actividad Propuesta 02 — Sistema de Gestión de Clientes (POO en Swift)

Este proyecto implementa un sistema orientada a objetos en **Swift** para la gestión de clientes en una entidad financiera o comercial. Aplica conceptos fundamentales de **Programación Orientada a Objetos (POO)** como **Herencia**, **Encapsulamiento** y **Sobrescritura de Métodos (`override`)**.

---

## 📋 Requerimientos del Sistema

El sistema categoriza a los clientes en dos tipos primarios (Naturales y Jurídicos) a partir de una clase base compartida:

1. **Clase Base (`Cliente`)**:
   - Define las propiedades comunes de cualquier cuenta: `codigo`, `direccion`, `fechaDeRegistro`, `numeroCuenta` y `montoMinimoApertura`.
   - Incluye el método `mostrarDatos()` para imprimir en consola la información financiera del cliente.

2. **Clase Derivada (`ClienteNatural`)**:
   - Hereda de `Cliente`.
   - Modela personas naturales agregando los atributos particulares: `nombreCompleto` y `dni`.
   - Sobrescribe (`override`) el método `mostrarDatos()` para presentar la identidad de la persona junto a sus datos de cuenta base mediante `super.mostrarDatos()`.

3. **Clase Derivada (`ClienteJuridico`)**:
   - Hereda de `Cliente`.
   - Modela empresas u organizaciones agregando atributos corporativos: `razonSocial`, `ruc` y `representanteLegal`.
   - Sobrescribe (`override`) el método `mostrarDatos()` mostrando los registros fiscales y legales de la empresa, invocando también la lógica compartida de la clase padre.

---

## 🛠️ Estructura del Código

```swift
import Foundation

// 1. Clase Base
class Cliente {
    let codigo: String
    let direccion: String
    let fechaDeRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double
    
    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }
    
    func mostrarDatos() {
        print("👤 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("📅 Fecha de registro: \(fechaDeRegistro)")
        print("💳 Nº Cuenta: \(numeroCuenta)")
        print("💰 Monto mínimo de apertura: S/ \(montoMinimoApertura)")
    }
}

// 2. Subclase para Personas Naturales
class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String
    
    init(nombreCompleto: String, dni: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func mostrarDatos() {
        print("👤 Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

// 3. Subclase para Empresas (Personas Jurídicas)
class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String
    
    init(razonSocial: String, ruc: String, representanteLegal: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func mostrarDatos() {
        print("🏢 Cliente Jurídico:")
        print("Razón Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}
