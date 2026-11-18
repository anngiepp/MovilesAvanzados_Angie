# Expediente del trabajo · Semana 11

**Curso:** Desarrollo de Aplicaciones Móviles Avanzadas · Tecsup
**Laboratorio:** 11 · Manejo de datos con Core Data y SwiftData

## Enunciado (resumen)

**Laboratorio 11 · Trabajo de la semana · Grupo B: app de Compras (SwiftUI + SwiftData).**

Una distribuidora registra a sus proveedores, el costo de sus productos y las compras al contado o al crédito. La app funciona como una app de empresa, con inicio de sesión, registro y dos roles.

- **Datos:** cuatro clases `@Model` en SwiftData: Usuario, Proveedor, Producto y Compra. Cada compra queda ligada a quien la registró, a su proveedor y a su producto. No se puede borrar un usuario, proveedor o producto que tenga compras (`.deny`).
- **Roles:**
  - El **comprador** consulta productos y proveedores, registra compras y solo ve las suyas.
  - El **supervisor** administra productos y proveedores, aprueba o rechaza las compras grandes, paga las cuentas a crédito y tiene un resumen.
- **Reglas:**
  - El IGV es 18 % del subtotal y cuenta como crédito fiscal.
  - Las compras desde S/ 5,000 necesitan aprobación.
  - Al aprobar una compra se recalcula el costo promedio ponderado.
  - Una compra al crédito vence a los 30 días; si se pasa la fecha sin pagarse, aparece como VENCIDA.
- **Pantallas (9):** login, crear cuenta, productos, proveedores, nueva compra, mis compras, aprobar, por pagar y resumen.
- **Cierre de IGV:** el grupo B aporta el crédito fiscal de sus compras y el grupo A el IGV de sus ventas, para calcular el IGV por pagar o el saldo a favor.
- **Entrega:** se presenta y se defiende en la siguiente sesión, con capturas de los casos de prueba y el ícono de la app.

## 1. Integrante y caso

| Integrante | Grupo | App |
|---|---|---|
| Angie Portocarrero | B | **Compras** (SwiftUI + SwiftData) |

## 2. Modelo de datos

```
 ┌──────────────┐ 1       * ┌────────────────────────┐ *       1 ┌───────────────┐
 │   Usuario    │───────────▶│         Compra         │◀───────────│   Producto    │
 │ nombre       │ compras    │ fecha (Date)           │  compras   │ nombre        │
 │ usuario      │ (.deny)    │ cantidad (Int)         │  (.deny)   │ categoria     │
 │ clave        │            │ costoUnitario, igv,    │            │ stock (Int)   │
 │ rol          │◀───────────│ total (Double)         │───────────▶│ costoPromedio │
 └──────────────┘ comprador  │ alCredito (Bool)       │ producto   └───────────────┘
                             │ vence (Date)           │
                             │ estado (String)        │
                             │ pagada (Bool)          │
                             │ motivoRechazo (String?)│
                             └────────────────────────┘
                                   ▲ *    │ proveedor
                           compras │      ▼ 1
                           (.deny) ┌──────────────┐
                                   │  Proveedor   │
                                   │ nombre, ruc  │
                                   └──────────────┘
```

| Clase `@Model` | Propiedades | Relaciones |
|---|---|---|
| Usuario | nombre, usuario, clave, rol ("Comprador" o "Supervisor") | compras: [Compra] · `.deny`, inverse comprador |
| Proveedor | nombre, ruc | compras: [Compra] · `.deny`, inverse proveedor |
| Producto | nombre, categoria, stock (Int), costoPromedio (Double) | compras: [Compra] · `.deny`, inverse producto |
| Compra | fecha, cantidad, costoUnitario, igv, total, alCredito, vence, estado ("Pendiente", "Aprobada" o "Rechazada"), pagada, motivoRechazo (opcional) | comprador: Usuario?, proveedor: Proveedor?, producto: Producto? |

**Por qué `.deny`:** si un proveedor o producto ya tiene compras, borrarlo dejaría compras sin dueño y las cuentas por pagar no cuadrarían. Igual se revisa antes de borrar y se muestra un mensaje.

"Comprado", "por pagar", el valor del inventario y el crédito fiscal **no se guardan**: se calculan desde las compras.

## 3. Roles y permisos

| Qué puede hacer | Comprador | Supervisor |
|---|---|---|
| Pestañas | Productos, Proveedores, Compra, Mis compras | Resumen, Aprobar, Por pagar, Productos, Proveedores |
| Productos y proveedores | Solo consultar y buscar | Crear, editar y borrar (si no tienen compras) |
| Compras | Registrar y ver solo las suyas | Aprobar o rechazar, ver todo y pagar |
| Cuenta | Menú del avatar con nombre, rol y Cerrar sesión | Menú del avatar con nombre, rol y Cerrar sesión |

Cada compra guarda quién la registró (relación `comprador`), así "Mis compras" muestra solo las del usuario de la sesión.

## 4. Reglas de negocio (con ejemplos resueltos a mano)

**IGV (crédito fiscal):** subtotal = cantidad × costo unitario · IGV = 18 % del subtotal · total = subtotal + IGV.
- 10 × S/ 120.00 = 1,200.00 → IGV 216.00 → **total 1,416.00**

**Aprobación:**
- Total menor a S/ 5,000 → queda **Aprobada** al instante y cambia el stock y el costo promedio.
- Desde S/ 5,000 → queda **Pendiente**: no cambia stock, costo promedio ni cuentas por pagar.
- Ejemplo: 50 × 120.00 = 6,000.00 + IGV 1,080.00 = **7,080.00 → Pendiente**.
- El supervisor la aprueba (se aplican los efectos) o la rechaza con un motivo obligatorio (no cambia nada).

**Costo promedio ponderado (al aprobar):** nuevo = (stock × costo promedio + cantidad × costo unitario) / (stock + cantidad).
- Laptop con stock 40 a S/ 110.00, compra de 10 a 120.00: (4,400 + 1,200) / 50 = **112.00**, stock 50.
- Misma laptop, compra de 50 a 120.00: (4,400 + 6,000) / 90 = **115.56**, stock 90.

**Pago:**
- Contado: queda pagada.
- Crédito 30 días: queda por pagar y vence en 30 días. Si pasa la fecha sin pagarse, se muestra **VENCIDA**.
- Pagar (solo supervisor): la marca como pagada y deja de sumar en "Total por pagar".

**Login y registro:**
- El usuario es único sin importar mayúsculas: se guarda en minúsculas, así "mtorres" y "MTORRES" son el mismo.
- La clave tiene mínimo 6 caracteres y debe coincidir con la confirmación.
- Si el login falla: "Usuario o clave incorrectos".

## 5. Pantallas

| N.º | Pantalla | Para qué sirve | Lee | Escribe |
|---|---|---|---|---|
| B1 | Login | Entrar con usuario y clave | Usuario (`FetchDescriptor` + `#Predicate`) | Sesión |
| B2 | Crear cuenta | Registrarse con rol; avisa si el usuario ya existe | Usuario (`fetchCount`) | Usuario, Sesión |
| B3 | Productos | Costo promedio, stock en color, valor del inventario | Producto (`@Query`) | Producto (solo supervisor) |
| B4 | Proveedores | Total comprado y "N por pagar" o "Al día" | Proveedor y sus compras | Proveedor (solo supervisor) |
| B5 | Nueva compra | Registrar con IGV, contado o crédito; aviso desde S/ 5,000 | Proveedor, Producto, Sesión | Compra, Producto (si se aprueba al instante) |
| B6 | Mis compras | Todas, Pendientes o Rechazadas, con su motivo | Compra (solo del comprador) | — |
| B7 | Aprobar | Compra pendiente con vista previa de stock y costo promedio | Compra (`#Predicate` estado Pendiente) | Compra, Producto |
| B8 | Por pagar | Pendientes, Vencidas o Pagadas; deslizar para Pagar; total | Compra (`#Predicate` por filtro) | Compra.pagada |
| B9 | Resumen | Inventario, crédito fiscal, por pagar, por aprobar, total por proveedor y cierre de IGV | Producto, Compra, Proveedor | IGV de ventas del grupo A (solo para el cierre) |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
|---|---|---|
| 1 | Registrar "mtorres" como Comprador y luego repetir el usuario | Se crea el primero y entra a la app; el repetido se rechaza |
| 2 | Login con clave incorrecta | "Usuario o clave incorrectos"; no entra |
| 3 | Laptop con stock 40 y costo 110.00: compra de 10 a 120.00 al crédito | Subtotal 1,200.00 · IGV 216.00 · total 1,416.00 · Aprobada · stock 50 · costo promedio 112.00 · vence en 30 días |
| 4 | La misma compra, pero al contado | Queda pagada y no aparece en Pendientes de pago |
| 5 | Compra de 50 a 120.00 (total 7,080.00) | Queda Pendiente de aprobación; el stock sigue en 40 y no suma a por pagar |
| 6 | El supervisor aprueba la compra del caso 5 | Stock 90 · costo promedio 115.56 · aparece en Por pagar |
| 7 | El supervisor rechaza otra compra grande sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda Rechazada, el comprador ve el motivo y el stock no cambia |
| 8 | Compra a crédito vencida (TecnoImport, S/ 2,183.00) y luego Pagar | Sale en Vencidas con VENCIDA; al pagarla pasa a Pagadas y el total por pagar baja 2,183.00 |
| 9 | Un comprador abre Mis compras e intenta pagar | Solo ve sus compras y no tiene la opción de Pagar |
| 10 *(propio)* | Un comprador entra a Productos | No ve el botón "+" ni puede deslizar para borrar |
| 11 *(propio)* | El supervisor intenta borrar a Distribuidora Lima SAC | Se impide porque tiene compras (`.deny`) |
| 12 *(cierre)* | En Resumen, ingresar IGV de ventas 734.10 | Muestra crédito fiscal, la diferencia y si es IGV por pagar o saldo a favor |

Los casos 3 y 4 cambian el stock de la laptop. Para que los casos 5 y 6 partan de stock 40, se corren con datos nuevos (borrando la app del simulador) o en otro orden.

**Usuarios y datos de ejemplo:** `angie1` (Comprador) y `angie2` (Supervisor), los dos con clave `123456`. También se cargan 3 proveedores, 4 productos y 5 compras (una vencida y una rechazada).

## 7. Plan de commits

| Commit | Qué se entrega |
|---|---|
| 1 | Expediente y estructura de la carpeta |
| 2 | Clases `@Model` con relaciones `.deny`, sesión `@Observable` y datos de ejemplo |
| 3 | B1 Login, B2 Registro y pestañas por rol con el menú del avatar |
| 4 | B3 Productos y B4 Proveedores |
| 5 | B5 Nueva compra (IGV, contado o crédito y aprobación) |
| 6 | B6 Mis compras y B7 Aprobar (costo promedio) |
| 7 | B8 Por pagar con `#Predicate` y B9 Resumen con cierre de IGV |
| 8 | Ícono, capturas, Excel, PROMPTS.md y README final |

## 8. Plan de uso de IA

- **A mano:** el modelo de datos (clases, tipos y reglas de borrado), las reglas de negocio con sus números y los casos de prueba de este expediente.
- **Con IA:** armar las vistas de SwiftUI (barra de pestañas, tarjetas, gráfico de barras) y revisar errores de compilación.
- **Cómo verifico:** corro los 12 casos en el simulador y comparo con los resultados calculados a mano en la sección 4 y en el Excel. Cada consulta queda anotada en `PROMPTS.md`.
