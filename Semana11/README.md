# Semana 11 · Ventas (UIKit + Core Data)

App de ventas para una tienda, hecha con **UIKit** (interfaz por código) y **Core Data**. Tiene login, registro y dos roles: **Vendedor** y **Supervisor**, y las pestañas cambian según el rol. Grupo **A**.

**Alumna:** Angie Portocarrero

**Niveles:** Base, Nivel + y Reto.

## Entregables

| Entregable | Dónde está |
|---|---|
| Expediente (modelo, permisos, reglas, casos, plan de commits) | `docs/Expediente.md` |
| App en Xcode | `Ventas/Ventas.xcodeproj` |
| Consultas a la IA | `PROMPTS.md` |
| Capturas e ícono en la pantalla de inicio | `docs/capturas/` |

## Cómo ejecutar

1. Abrir `Ventas/Ventas.xcodeproj` en Xcode 16 o posterior.
2. Elegir un simulador de iPhone con iOS 17 o posterior y darle ▶.
3. La primera vez se cargan datos de ejemplo: 4 productos, 4 clientes y dos vendedores (`cruiz` y `adiaz`, clave `123456`). El supervisor se crea desde **Crear cuenta** (caso 1 de prueba).

## Modelo de datos

| Entidad | Atributos | Relaciones |
|---|---|---|
| Usuario | nombre, usuario, clave, rol | ventas ▶ Venta (To Many, **Deny**) |
| Producto | nombre, categoria, precio, stock | ventas ▶ Venta (To Many, **Deny**) |
| Cliente | nombre, documento | ventas ▶ Venta (To Many, **Deny**) |
| Venta | fecha, cantidad, precioUnitario, descuento, igv, total, anulada, motivoAnulacion | vendedor, producto, cliente (To One, Nullify) |

## Pantallas

| | Vendedor | Supervisor |
|---|---|---|
| Pestañas | Productos · Clientes · Venta · Mis ventas · Cuenta | Resumen · Ventas · Productos · Clientes · Cuenta |

- **A1 Login** y **A2 Crear cuenta**: usuario único sin importar mayúsculas, clave de mínimo 6 y confirmación.
- **A3 Productos**: búsqueda, chips por categoría y stock en color (verde > 10, ámbar 6–10, rojo ≤ 5). Solo el supervisor crea, edita y borra.
- **A4 Clientes**: total comprado y categoría (Regular, Frecuente, VIP) calculados con las ventas no anuladas.
- **A5 Nueva venta**: el vendedor sale de la sesión; calcula subtotal, descuento VIP 10 %, IGV 18 % y total; valida el stock.
- **A6 Mis ventas**: solo las del vendedor, indicadores de hoy y del mes, filtro Todas/Hoy/Mes y búsqueda por cliente.
- **A7 Ventas del equipo**: todas las ventas, filtro por periodo y por vendedor, deslizar para anular.
- **A8 Anular**: motivo obligatorio, devuelve el stock.
- **A9 Resumen**: vendido hoy vs ayer, IGV del mes, gráfico de 7 días, ranking de vendedores y stock bajo.

## Organización del código

```
Ventas/Ventas/
├── AppDelegate.swift / SceneDelegate.swift   Core Data y cambio entre login y pestañas
├── Ventas.xcdatamodeld                        las 4 entidades con sus relaciones
├── BD.swift                                   contexto, guardar() y la Sesion
├── Reglas.swift                               categoría, descuento, IGV, total y filtros de fecha
├── Estilos.swift                              celdas, tarjetas, chips y etiquetas reutilizables
├── DatosEjemplo.swift                         datos iniciales
├── LoginViewController / RegistroViewController / TabsViewController / CuentaViewController
├── ProductosViewController / ClientesViewController
├── NuevaVentaViewController / SeleccionViewController
├── MisVentasViewController / VentasEquipoViewController / AnularVenta
└── ResumenViewController                      incluye el gráfico de barras
```

## Casos de prueba

Los 9 casos del laboratorio más 2 propios están en `docs/Expediente.md` (sección 6) con su resultado esperado.

## Cierre de IGV (para la próxima clase)

IGV de ventas del mes: se lee en la tarjeta **IGV del mes** del Resumen.
