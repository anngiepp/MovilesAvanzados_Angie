# PROMPTS.md · Consultas a la IA

Formato: Contexto, Tarea, Restricciones, Formato esperado y qué hice con la respuesta.

---

## Consulta 1 · Revisar el expediente

- **Contexto:** Laboratorio 11, Grupo A (Ventas con UIKit + Core Data). Ya tenía las entidades, roles y reglas del enunciado.
- **Tarea:** ordenar el expediente con la plantilla del anexo y comprobar los ejemplos numéricos (descuento VIP, IGV, stock y anulación).
- **Restricciones:** usar solo las reglas del enunciado; los montos con dos decimales.
- **Formato esperado:** documento en Markdown con las 9 secciones de la plantilla.
- **Qué hice con la respuesta:** la acepté; agregué dos casos de prueba propios (10 y 11) y revisé a mano los montos de los casos 4, 5 y 8.

## Consulta 2 · Modelo de datos y login

- **Contexto:** proyecto UIKit con Core Data. 4 entidades (Usuario, Producto, Cliente, Venta) con delete rule Deny en las relaciones To Many.
- **Tarea:** crear el modelo, la clase Sesion con un objeto compartido y las pantallas de login, registro y pestañas por rol.
- **Restricciones:** interfaz por código (sin storyboard), usuario único con `==[c]`, mensaje genérico en el login.
- **Formato esperado:** archivos `.swift` completos.
- **Qué hice con la respuesta:** 

## Consulta 3 · Pantallas de productos, clientes y venta

- **Contexto:** ya funcionaban el login y las pestañas.
- **Tarea:** armar A3, A4 y A5 según la maqueta: chips de categoría, colores de stock, categoría del cliente calculada y resumen de la venta.
- **Restricciones:** la categoría no se guarda, se calcula con las ventas no anuladas; si la cantidad supera el stock no se registra.
- **Formato esperado:** un archivo por pantalla.
- **Qué hice con la respuesta:** 

## Consulta 4 · Ventas, anulación y resumen

- **Contexto:** faltaban las pantallas que leen ventas.
- **Tarea:** A6 con predicate por vendedor, A7 con filtro por vendedor (relación), A8 con motivo obligatorio y A9 con gráfico de 7 días y ranking.
- **Restricciones:** usar NSPredicate con fechas y con la relación `vendedor`; el botón Anular desactivado si el motivo está vacío.
- **Formato esperado:** archivos `.swift` completos.
- **Qué hice con la respuesta:** 
