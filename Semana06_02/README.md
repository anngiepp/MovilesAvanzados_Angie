# Laboratorio 6 — Ventanas modales

App de datos del cliente construida con UIKit y `Main.storyboard`. Corresponde a la sección **VENTANAS MODALES** de la guía; la calculadora de venta a plazos se realizará después.

## Ejecutar

1. Abrir `Semana06_02.xcodeproj` en Xcode.
2. Seleccionar el esquema `Semana06_02` y un simulador de iPhone.
3. Ejecutar con Cmd + R.

## Flujo y conexiones

- `ViewController`: campos `tfApellidos`, `tfNombres` y `tfDNI`; el botón Revisar datos llama a `btnContinuar:`.
- `ClienteModel`: clase que hereda de `NSObject`, con código, apellidos, nombres y DNI. El DNI es texto para conservar ceros iniciales.
- `ViewControllerConfirmacion`: Custom Class y Storyboard ID de la segunda escena. Recibe el modelo antes de `present(...)`, muestra sus datos en tres UILabel y cierra con `dismiss(...)` desde Volver al formulario.
- Todos los controles, outlets, acciones y restricciones están definidos en el storyboard. No se usa SwiftUI.
- El rediseño usa tarjetas, campos verticales con margen interior y botones de ancho completo. Auto Layout y un UIScrollView permiten adaptar y desplazar el contenido.
- Los colores del sistema se adaptan al modo claro y oscuro. El teclado numérico incluye Listo; el formulario se desplaza para mantener visible el campo activo.

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

La versión base se conserva en `main`. La rama existente para IA es `ai-assisted`, que sigue a `origin/ai-assisted`; se incorporaron los cuatro commits de la app base y después se guardaron avances independientes del rediseño.

Las pantallas siguen en `Main.storyboard`. `PaddedTextField` añade únicamente margen interior a los campos colocados en Interface Builder. El código UIKit gestiona teclado, validación y paso de datos; no se usa SwiftUI.

Comprobaciones del rediseño: compilación correcta con Xcode 26.3, formulario y confirmación en iPhone 17 Pro, apellido compuesto, DNI con ceros iniciales, retorno conservando valores, cierre del teclado con Listo y revisión visual del formulario en modo oscuro. Se restauró el simulador al modo claro después de la revisión.

El rediseño se realizó con asistencia de Codex. La calculadora queda pendiente. Los commits se guardaron localmente; todavía no se realizó push.
