# Semana 09 · Boleta de pago

Proyecto SwiftUI de una sola pantalla. Trabajo individual, niveles 1 y 2.

## Ejecutar

Abrir `BoletaPagoApp/BoletaPagoApp.xcodeproj` en Xcode 16 o posterior y ejecutar el esquema `BoletaPagoApp` en un simulador con iOS 17 o posterior.

El formulario recibe sueldo, días, hijos, pensión, horas extras y adelantos. Calcular muestra remuneraciones, descuentos, EsSalud y neto. Los controles y funcionalidades se incorporan según los hitos siguientes.

## Entrega externa

El Excel, análisis, fuentes, capturas, guías y archivos auxiliares se entregan por separado en `Entrega_Semana09`, fuera de este repositorio. Las guías de exposición y evaluación no forman parte del código ni del historial publicado.

## Hitos completados

1. inicio: estructura SwiftUI y alcance de la actividad
2. config: parametros de calculo y fuentes
3. modelo: calculo de boleta del nivel 1
4. pruebas: casos 1 y 2 verificados
5. ui: formulario y boleta del nivel 1
6. funcionalidad: AFP horas extras y adelantos
7. excel: calculadora y explicacion de formulas

## Pruebas

Desde `BoletaPagoApp`, ejecutar `swift test --disable-sandbox`. El paquete prueba el mismo modelo utilizado por la aplicación.
