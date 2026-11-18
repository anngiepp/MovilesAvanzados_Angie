# Semana 11 · Ventas (UIKit + Core Data)

App de ventas para una tienda, hecha con **UIKit** (interfaz por código) y **Core Data**. Tiene login, registro y dos roles: **Vendedor** y **Supervisor**, y las pestañas cambian según el rol. Grupo **A**.

**Alumna:** Angie Portocarrero

**Niveles:** Base, Nivel + y Reto.

## Entregables

| Entregable | Dónde está |
|---|---|
| Expediente (modelo, permisos, reglas, casos, plan de commits) | `docs/Expediente.md` |
| App en Xcode | `Ventas/Ventas.xcodeproj` |
| Excel (calculadora, casos vs app y cierre de IGV) | `Excel/Ventas_Semana11.xlsx` |
| Cierre de IGV del mes | `docs/CierreIGV.md`, hoja *Cierre IGV* del Excel y tarjeta en el Resumen |
| Consultas a la IA | `PROMPTS.md` |
| Capturas e ícono en la pantalla de inicio | `docs/capturas/` |

## Cómo ejecutar

1. Abrir `Ventas/Ventas.xcodeproj` en Xcode 16 o posterior.
2. Elegir un simulador de iPhone con iOS 17 o posterior y darle ▶.
3. La primera vez se cargan datos de ejemplo (ver abajo). Para empezar de cero: borrar la app del simulador y volver a correrla.

## Usuarios predeterminados

| Usuario | Clave | Rol | Nombre |
|---|---|---|---|
| `angie1` | `123456` | Vendedor | Carlos Ruiz |
| `angie2` | `123456` | Vendedor | Ana Díaz |
| `lparedes` | `123456` | Supervisor | Lucía Paredes · **no viene cargado**: se crea en *Crear cuenta* (caso de prueba 1) |

Datos de ejemplo que se cargan con ellos (`DatosEjemplo.swift`):
- **Productos:** Laptop Pro 14 (S/ 200, stock 40), Monitor 24" (S/ 450, stock 9), Mouse inalámbrico (S/ 35, stock 120) y Teclado mecánico (S/ 129.90, stock 4).
- **Clientes:** Comercial Andina SAC (ya es VIP), María Quispe (Frecuente), Luis Rojas y Tienda Sol EIRL (Regular).
- **Ventas:** 7 ventas de los últimos días, una de ellas anulada, para que el Resumen y el ranking tengan datos.

## Base de datos (Core Data)

- **Modelo:** `Ventas.xcdatamodeld`, con las entidades Usuario, Producto, Cliente y Venta y sus relaciones.
- **Conexión:** `AppDelegate.swift` crea el `NSPersistentContainer(name: "Ventas")`, que carga el modelo y abre el archivo `Ventas.sqlite`. Su ruta sale en la consola de Xcode al iniciar la app.
- **Uso:** `BD.swift` da el contexto (`BD.contexto`) y `BD.guardar()`. Las pantallas leen con `NSFetchRequest` + `NSPredicate` y escriben creando objetos (`Venta(context:)`), cambiando sus atributos y llamando a `guardar()`.

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
- **A9 Resumen**: vendido hoy vs ayer, IGV del mes, gráfico de 7 días, ranking de vendedores, stock bajo y **cierre de IGV**.

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

## Excel

`Excel/Ventas_Semana11.xlsx` tiene 5 hojas: **Parámetros** (IGV, descuento VIP, límites de categoría y de stock), **Venta** (calculadora con los mismos datos de Nueva venta), **Casos** (casos 4, 5, 6, 8 y 11 calculados con fórmulas y comparados con lo que muestra la app), **Cierre IGV** (IGV de cada venta, crédito fiscal del grupo B y resultado) y **Explicación** (cada fórmula en palabras y dónde está en el código).

## Casos de prueba

Los 9 casos del laboratorio más 2 propios están en `docs/Expediente.md` (sección 6) con su resultado esperado.

## Cierre de IGV del mes

**IGV por pagar = IGV de ventas − crédito fiscal de compras** (si sale negativo es saldo a favor).

En el Resumen está la tarjeta **Cierre de IGV del mes**: toma el IGV de las ventas no anuladas del mes, se escribe el crédito fiscal que trae el grupo B y la app calcula el resultado. Las cifras y el cuadro para la clase están en `docs/CierreIGV.md`.
