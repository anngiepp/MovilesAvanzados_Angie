# PROMPTS.md · Consultas a la IA

Cada consulta tiene el formato del laboratorio: Contexto, Tarea, Restricciones, Formato esperado y qué hice con la respuesta.

---

## Consulta 1 · Revisar el expediente

- **Contexto:** Laboratorio 11, Grupo B (Compras con SwiftUI + SwiftData). Ya tenía las clases, los roles y las reglas del enunciado.
- **Tarea:** ordenar el expediente con la plantilla del anexo y comprobar los ejemplos numéricos (IGV, aprobación desde S/ 5,000 y costo promedio).
- **Restricciones:** usar solo las reglas del enunciado y montos con dos decimales.
- **Formato esperado:** un documento en Markdown con las secciones de la plantilla.
- **Qué hice con la respuesta:** 

## Consulta 2 · Clases y login

- **Contexto:** proyecto SwiftUI con SwiftData y 4 clases `@Model` (Usuario, Proveedor, Producto, Compra) con `.deny` en las relaciones To Many.
- **Tarea:** crear las clases, la sesión `@Observable` con `.environment` y las pantallas de login, registro y pestañas por rol.
- **Restricciones:** usuario único sin importar mayúsculas, `FetchDescriptor` con `#Predicate` y mensaje genérico en el login.
- **Formato esperado:** archivos `.swift` completos.
- **Qué hice con la respuesta:** 

## Consulta 3 · Productos, proveedores y nueva compra

- **Contexto:** el login y las pestañas ya funcionaban.
- **Tarea:** armar B3, B4 y B5 según la maqueta: valor del inventario, "por pagar" calculado por proveedor y el aviso de aprobación.
- **Restricciones:** la compra desde S/ 5,000 queda Pendiente y no cambia el stock; al aprobar se usa el costo promedio ponderado.
- **Formato esperado:** una vista por archivo.
- **Qué hice con la respuesta:** 

## Consulta 4 · Aprobar, por pagar y resumen

- **Contexto:** faltaban las pantallas del supervisor.
- **Tarea:** B7 con vista previa del efecto, B8 con filtros Pendientes, Vencidas y Pagadas con `#Predicate`, y B9 con el total por proveedor.
- **Restricciones:** rechazar exige un motivo, Pagar solo para el supervisor y la búsqueda es por proveedor.
- **Formato esperado:** archivos `.swift` completos.
- **Qué hice con la respuesta:** 
