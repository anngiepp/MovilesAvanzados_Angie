# Expediente del trabajo · Semana 11

**Curso:** Desarrollo de Aplicaciones Móviles Avanzadas · Tecsup
**Laboratorio:** 11 · Manejo de datos con Core Data

## Enunciado (resumen)

**Laboratorio 11 · Trabajo de la semana · Grupo A: app de Ventas (UIKit + Core Data).**

Una tienda necesita registrar productos, clientes y ventas en una app de iPhone que funcione como app de empresa: con inicio de sesión, registro y dos roles.

- **Datos:** cuatro entidades en Core Data: Usuario, Producto, Cliente y Venta. Cada venta queda ligada a su vendedor, producto y cliente. No se puede borrar un producto, cliente o usuario que ya tenga ventas (delete rule Deny).
- **Roles:**
  - El **vendedor** consulta productos, registra clientes y ventas, y solo ve sus propias ventas.
  - El **supervisor** administra los productos, ve las ventas de todo el equipo, anula ventas con un motivo y tiene un panel de resumen.
- **Reglas:**
  - La categoría del cliente depende de lo que compró: Regular, Frecuente desde S/ 1,000 y VIP desde S/ 5,000.
  - Los VIP tienen 10 % de descuento y a todas las ventas se les aplica IGV de 18 %.
  - No se vende más de lo que hay en stock.
  - Al anular una venta, el stock se devuelve.
- **Pantallas (9):** login, crear cuenta, productos, clientes, nueva venta, mis ventas, ventas del equipo, anular venta y resumen del supervisor.
- **Cierre de IGV:** el grupo A aporta el IGV de sus ventas del mes y el grupo B el crédito fiscal de sus compras, para calcular el IGV por pagar o el saldo a favor.
- **Entrega:** se presenta y se defiende en la siguiente sesión, con capturas de los casos de prueba y el ícono de la app.

## 1. Integrantes y caso

| Integrante | Grupo | App |
|---|---|---|
| Angie Portocarrero | A | **Ventas** (UIKit + Core Data) |

Caso: una tienda registra productos, clientes y ventas. La app tiene login, registro y dos roles: **Vendedor** y **Supervisor**. Las pestañas cambian según el rol.

## 2. Modelo de datos

```
 ┌──────────────┐ 1      * ┌──────────────────────┐ *      1 ┌──────────────┐
 │   Usuario    │──────────▶│        Venta         │◀──────────│   Producto   │
 │ nombre       │ ventas    │ fecha (Date)         │  ventas   │ nombre       │
 │ usuario      │ (Deny)    │ cantidad (Int)       │  (Deny)   │ categoria    │
 │ clave        │           │ precioUnitario       │           │ precio       │
 │ rol          │◀──────────│ descuento            │──────────▶│ stock (Int)  │
 └──────────────┘ vendedor  │ igv, total (Double)  │ producto  └──────────────┘
                  (Nullify) │ anulada (Bool)       │ (Nullify)
                            │ motivoAnulacion      │
                            └──────────────────────┘
                                 ▲ * │ cliente (Nullify)
                          ventas │   ▼ 1
                            (Deny) ┌──────────────┐
                                   │   Cliente    │
                                   │ nombre       │
                                   │ documento    │
                                   └──────────────┘
```

| Entidad | Atributos | Relaciones y delete rule |
|---|---|---|
| Usuario | nombre, usuario, clave, rol (String: "Vendedor" o "Supervisor") | ventas: To Many ▶ Venta · **Deny** |
| Producto | nombre, categoria (String), precio (Double), stock (Integer 64) | ventas: To Many ▶ Venta · **Deny** |
| Cliente | nombre, documento (String) | ventas: To Many ▶ Venta · **Deny** |
| Venta | fecha (Date), cantidad (Integer 64), precioUnitario, descuento, igv, total (Double), anulada (Bool), motivoAnulacion (String, opcional) | vendedor: To One ▶ Usuario · producto: To One ▶ Producto · cliente: To One ▶ Cliente (las tres **Nullify**) |

**Por qué Deny:** si un producto, cliente o usuario ya tiene ventas, borrarlo dejaría ventas "huérfanas" y los reportes no cuadrarían. Con Deny Core Data no deja guardar el borrado; igual lo revisamos antes y mostramos una alerta.

La categoría del cliente y su total comprado **no se guardan**: se calculan cada vez con sus ventas no anuladas.

## 3. Roles y permisos

| Qué puede hacer | Vendedor | Supervisor |
|---|---|---|
| Pestañas | Productos, Clientes, Venta, Mis ventas, Cuenta | Resumen, Ventas, Productos, Clientes, Cuenta |
| Productos | Solo consultar y buscar | Crear, editar y borrar (si no tiene ventas) |
| Clientes | Crear, editar y consultar | Crear, editar, consultar y borrar (si no tiene ventas) |
| Ventas | Registrar y ver solo las suyas | Ver todas, filtrar por vendedor y anular con motivo |
| Resumen | No lo ve | Panel con indicadores, gráfico de 7 días, ranking y stock bajo |
| Cuenta | Ver sus datos y cerrar sesión | Ver sus datos y cerrar sesión |

Cada venta guarda quién la registró (relación `vendedor`), así se filtra "solo las mías" con un predicate.

## 4. Reglas de negocio (con ejemplos resueltos a mano)

**Categoría del cliente** (suma del total de sus ventas no anuladas):
- Menos de S/ 1,000 → Regular · desde S/ 1,000 → Frecuente · desde S/ 5,000 → VIP
- Ejemplo: María compró S/ 1,593.00 → Frecuente. Si se anula esa venta, vuelve a S/ 0 → Regular.

**Descuento, IGV y total:**
- Descuento = 10 % del subtotal solo si es VIP. IGV = 18 % de (subtotal − descuento). Total = subtotal − descuento + IGV.
- Ejemplo VIP: 2 Laptop × S/ 200 = 400.00 → descuento 40.00 → base 360.00 → IGV 64.80 → **total 424.80**
- Ejemplo Regular: 3 Mouse × S/ 35 = 105.00 → descuento 0 → IGV 18.90 → **total 123.90**

**Stock:**
- Al registrar baja el stock: Laptop 40 − 2 = 38.
- Si piden 50 y hay 40 → alerta "Stock insuficiente" y no se guarda nada.
- Colores en la lista: verde más de 10, ámbar de 6 a 10, rojo 5 o menos.

**Anulación (solo supervisor):**
- Pide motivo obligatorio (el botón Anular está desactivado si está vacío).
- Marca `anulada = true`, guarda el motivo y devuelve el stock: 38 + 2 = 40.
- La venta deja de sumar en el resumen y en la categoría del cliente (el resumen de hoy baja 424.80).

**Cierre de IGV del mes (con el grupo B):**
- IGV por pagar = IGV de ventas (no anuladas) − crédito fiscal de compras. Si es negativo, es saldo a favor.
- Ejemplo del enunciado: IGV de ventas 734.10 − crédito fiscal 2,361.60 = −1,627.50 → **saldo a favor S/ 1,627.50**.
- El crédito fiscal lo trae el grupo B y se escribe en la tarjeta de cierre del Resumen.

**Login y registro:**
- Usuario único sin importar mayúsculas: "lparedes" y "LPAREDES" son el mismo → se rechaza el segundo.
- Clave de mínimo 6 caracteres e igual a su confirmación.
- Si el login falla, siempre el mismo mensaje: "Usuario o clave incorrectos".

## 5. Pantallas

| N.º | Pantalla | Para qué sirve | Lee | Escribe |
|---|---|---|---|---|
| A1 | Login | Entrar con usuario y clave | Usuario | Sesión |
| A2 | Crear cuenta | Registrarse con rol | Usuario (para ver si existe) | Usuario, Sesión |
| A3 | Productos | Lista con búsqueda, chips de categoría y stock en color | Producto | Producto (solo supervisor) |
| A4 | Clientes | Lista con total comprado y categoría | Cliente, Venta | Cliente |
| A5 | Nueva venta | Registrar venta con resumen calculado | Cliente, Producto, Sesión | Venta, Producto.stock |
| A6 | Mis ventas | Ventas propias, indicadores hoy/mes, filtro y búsqueda | Venta (vendedor == yo) | — |
| A7 | Ventas del equipo | Todas las ventas, filtro por periodo y vendedor | Venta, Usuario | — |
| A8 | Anular venta | Alerta con motivo obligatorio | Venta | Venta, Producto.stock |
| A9 | Resumen | Panel del supervisor y cierre de IGV del mes | Venta, Usuario, Producto | Crédito fiscal (dato del grupo B) |
| — | Cuenta | Nombre, usuario, rol y cerrar sesión | Sesión | Sesión |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
|---|---|---|
| 1 | Registrar "lparedes" como Supervisor e intentar registrar "LPAREDES" | El primero entra a la app; el segundo se rechaza por usuario repetido |
| 2 | Registrar con claves distintas o de 4 caracteres | Mensaje de error; no se crea el usuario |
| 3 | Login con clave incorrecta | "Usuario o clave incorrectos"; no entra |
| 4 | Vendedor vende 2 Laptop a S/ 200 a un cliente VIP | Subtotal 400.00 · descuento 40.00 · IGV 64.80 · total 424.80 · stock 40 → 38 |
| 5 | Vendedor vende 3 Mouse de S/ 35 a un cliente Regular | Subtotal 105.00 · IGV 18.90 · total 123.90 |
| 6 | Venta de 50 unidades con stock 40 | Alerta y no se registra; el stock no cambia |
| 7 | Un vendedor abre Mis ventas | Solo ve sus ventas y ninguna fila permite Anular |
| 8 | Supervisor anula la venta del caso 4 sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda anulada, stock vuelve a 40 y el resumen baja 424.80 |
| 9 | Borrar un cliente que tiene ventas | Se impide y se muestra un mensaje |
| 10 *(propio)* | Un vendedor entra a Productos | No ve el botón "+" ni puede deslizar para borrar |
| 11 *(propio)* | Cliente Regular con S/ 0 compra 8 Laptop (S/ 1,888.00) | En Clientes pasa a **Frecuente**; en la siguiente venta sigue sin descuento |
| 12 *(cierre)* | En Resumen ingresar crédito fiscal 2,361.60 | Muestra IGV de ventas, resta el crédito y dice "Saldo a favor" con la diferencia |

Datos de ejemplo: la app carga 4 productos, 4 clientes y 2 vendedores (angie1 y angie2, clave 123456) con algunas ventas para que Comercial Andina SAC ya sea VIP y el resumen tenga datos.

## 7. Plan de commits

| Commit | Qué se entrega |
|---|---|
| 1 | Expediente y estructura de la carpeta |
| 2 | Proyecto, modelo Core Data con las 4 entidades y delete rules, datos de ejemplo |
| 3 | A1 Login, A2 Registro, sesión, pestañas por rol y Cuenta |
| 4 | A3 Productos (búsqueda, chips, colores de stock, permisos) |
| 5 | A4 Clientes (categoría y total calculados, borrado con Deny) |
| 6 | A5 Nueva venta (stock, descuento VIP, IGV) |
| 7 | A6 Mis ventas (predicate por vendedor, periodo y búsqueda) |
| 8 | A7 Ventas del equipo y A8 Anular con motivo |
| 9 | A9 Resumen del supervisor (gráfico, ranking, stock bajo) |
| 9b | Cierre de IGV del mes en el Resumen y `docs/CierreIGV.md` |
| 10 | Ícono, capturas, PROMPTS.md y README final |

## 8. Plan de uso de IA

- **A mano:** el modelo de datos (entidades, tipos y delete rules), las reglas de negocio con sus números y los casos de prueba de este expediente.
- **Con IA:** armar la interfaz por código (constraints, celdas, chips, gráfico de barras) y revisar errores de compilación.
- **Cómo verifico:** corro los 12 casos en el simulador y comparo con los resultados calculados a mano en la sección 4. Cada consulta queda anotada en `PROMPTS.md`.
