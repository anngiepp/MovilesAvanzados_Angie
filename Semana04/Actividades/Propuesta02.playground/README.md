# Actividad Propuesta 02 — Sistema de Gestión de Clientes

Documentación técnica y funcional para el módulo de administración de clientes desarrollado en **Swift** bajo el paradigma de **Programación Orientada a Objetos (POO)**.

---

## 🎯 Objetivo de la Aplicación

El propósito del módulo es gestionar el registro y la visualización de expedientes bancarios/comerciales diferenciando las identidades de **Personas Naturales** y **Personas Jurídicas**, optimizando la estructura mediante el uso de herencia y polimorfismo.

---

## 📋 Especificación de Requerimientos

### 1. Entidad Base: `Cliente`
Clase principal que define la estructura genérica para cualquier tipo de cliente registrado en la plataforma.

* **Atributos Obligatorios:**
  * **Código (`codigo`):** Identificador único del cliente en el sistema.
  * **Dirección (`direccion`):** Domicilio fiscal o residencia registrada.
  * **Fecha de Registro (`fechaDeRegistro`):** Fecha de alta del cliente en formato YYYY-MM-DD.
  * **Número de Cuenta (`numeroCuenta`):** Identificador de la cuenta bancaria o comercial.
  * **Monto Mínimo de Apertura (`montoMinimoApertura`):** Valor numérico decimal del fondo inicial requerido.

* **Comportamiento Requerido:**
  * **`mostrarDatos()`**: Método encargado de procesar e imprimir en consola el desglose estructurado con los datos generales de la cuenta.

---

### 2. Entidad Especializada: `ClienteNatural`
Subclase que hereda de `Cliente` y modela la atención a personas físicas.

* **Atributos Adicionales:**
  * **Nombre Completo (`nombreCompleto`):** Nombres y apellidos del titular.
  * **DNI (`dni`):** Documento Nacional de Identidad de 8 dígitos.

* **Requerimiento de Comportamiento (`override`):**
  * Debe sobrescribir el método `mostrarDatos()` para anteponer la identificación civil (`Nombre` y `DNI`) y posteriormente invocar la lógica heredada de la clase base (`super.mostrarDatos()`) para mostrar los datos de la cuenta.

---

### 3. Entidad Especializada: `ClienteJuridico`
Subclase que hereda de `Cliente` y modela la relación con organizaciones o empresas.

* **Atributos Adicionales:**
  * **Razón Social (`razonSocial`):** Nombre legal de la empresa registrada.
  * **RUC (`ruc`):** Registro Único de Contribuyentes (11 dígitos).
  * **Representante Legal (`representanteLegal`):** Nombre del apoderado o contacto principal.

* **Requerimiento de Comportamiento (`override`):**
  * Debe sobrescribir el método `mostrarDatos()` para exponer la información corporativa y legal (`Razón Social`, `RUC` y `Representante Legal`), complementando la salida mediante el método base (`super.mostrarDatos()`).

---

## 🖥️ Salida Esperada en Ejecución

Al instanciar ambos tipos de clientes con datos reales de prueba, la consola debe generar el siguiente reporte exacto:

```text
👤 Cliente Natural:
Nombre: Juan Pérez
DNI: 12345678
👤 Código: C001
📍 Dirección: Av. Lima 123
📅 Fecha de registro: 2025-04-03
💳 Nº Cuenta: 001-2025-000123
💰 Monto mínimo de apertura: S/ 500.0

-----------------------------------

🏢 Cliente Jurídico:
Razón Social: Soluciones SAC
RUC: 20123456789
Representante Legal: María León
👤 Código: C002
📍 Dirección: Jr. Empresas 456
📅 Fecha de registro: 2025-04-01
💳 Nº Cuenta: 001-2025-000456
💰 Monto mínimo de apertura: S/ 3000.0
