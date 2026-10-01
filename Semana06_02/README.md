# Laboratorio 6 — Ventanas modales

App de datos del cliente construida con UIKit y `Main.storyboard`. Corresponde a la sección **VENTANAS MODALES** de la guía; la calculadora de venta a plazos se realizará después.

## Ejecutar

1. Abrir `Semana06_02.xcodeproj` en Xcode.
2. Seleccionar el esquema `Semana06_02` y un simulador de iPhone.
3. Ejecutar con Cmd + R.

## Flujo y conexiones

- `ViewController`: campos `tfApellidos`, `tfNombres` y `tfDNI`; el botón Continuar llama a `btnContinuar:`.
- `ClienteModel`: clase que hereda de `NSObject`, con código, apellidos, nombres y DNI. El DNI es texto para conservar ceros iniciales.
- `ViewControllerConfirmacion`: Custom Class y Storyboard ID de la segunda escena. Recibe el modelo antes de `present(...)`, muestra sus datos en tres UILabel y cierra con `dismiss(...)` desde Volver.
- Todos los controles, outlets, acciones y restricciones están definidos en el storyboard. No se usa SwiftUI.
- Se mantienen el diseño sencillo y las dos pantallas del avance. Auto Layout y un UIScrollView permiten adaptar y desplazar el contenido.

En este ejercicio se usa presentación modal porque la confirmación se abre temporalmente sobre el formulario. `Show` y `prepare(for:sender:)` se usarán en la calculadora según la guía.

## Comprobaciones realizadas

Compilación de Debug para iOS Simulator con Xcode 26.3: correcta.
Prueba del flujo en iPhone 17 Pro con iOS 26.3:

1. Continuar con campos vacíos: muestra alerta y mantiene el formulario.
2. Apellidos y nombres con DNI de tres dígitos: muestra alerta de DNI.
3. Datos de prueba con DNI `00000000`: abre la confirmación y conserva los ocho ceros.
4. Volver: cierra la confirmación y conserva los valores del formulario.

La validación comprueba el formato del DNI (ocho dígitos), sin consultar identidad ni servicios externos. Los datos solo viven en memoria.

## Avances en Git

Los avances de esta app se guardan en `main`: estado inicial, flujo modal y validación con Auto Layout. Las correcciones se realizaron con asistencia de Codex. El rediseño y la calculadora todavía no se han iniciado; quedan pendientes de la indicación del usuario.
