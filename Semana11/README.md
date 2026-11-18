# Semana 11 · Compras (SwiftUI + SwiftData)

App de compras para una distribuidora, hecha con **SwiftUI** y **SwiftData**. Tiene login, registro y dos roles, **Comprador** y **Supervisor**, y las pestañas cambian según el rol. Corresponde al Grupo **B**.

**Alumna:** Angie Portocarrero

**Niveles:** Base, Nivel + y Reto.

## Entregables

| Entregable | Dónde está |
|---|---|
| Expediente (enunciado, modelo, permisos, reglas, casos y plan de commits) | `docs/Expediente.md` |
| App en Xcode | `Compras/Compras.xcodeproj` |
| Excel (calculadora, casos vs app y crédito fiscal) | `Excel/Compras_Semana11.xlsx` |
| Cierre de IGV del mes | `docs/CierreIGV.md`, la hoja *Cierre IGV* del Excel y la tarjeta en el Resumen |
| Consultas a la IA | `PROMPTS.md` |
| Capturas e ícono en la pantalla de inicio | `docs/capturas/` |

## Cómo ejecutar

1. Abrir `Compras/Compras.xcodeproj` en Xcode 16 o posterior.
2. Elegir un simulador de iPhone con iOS 17 o posterior y darle ▶.
3. La primera vez se cargan los datos de ejemplo (ver abajo). Para empezar de cero, borrar la app del simulador y volver a correrla.

## Usuarios predeterminados

| Usuario | Clave | Rol | Nombre |
|---|---|---|---|
| `angie1` | `123456` | Comprador | Angie Uno |
| `angie2` | `123456` | Supervisor | Angie Dos |

Datos de ejemplo que se cargan con ellos (`DatosEjemplo.swift`):
- **Proveedores:** Distribuidora Lima SAC, TecnoImport EIRL y Mayorista Sur SAC.
- **Productos:**
  - Laptop Pro 14: stock 40, costo S/ 110.00
  - Monitor 24": stock 9, costo S/ 300.00
  - Mouse inalámbrico: stock 120, costo S/ 18.50
  - Teclado mecánico: stock 4, costo S/ 80.00
- **Compras de angie1:**
  - 3 a crédito por pagar, una de ellas **vencida** (TecnoImport, S/ 2,183.00)
  - 1 al contado
  - 1 rechazada con su motivo

## Base de datos (SwiftData)

- **Modelo:** las 4 clases `@Model` están en `Modelos.swift`. Las relaciones To Many tienen `deleteRule: .deny` y su `inverse`.
- **Conexión:** en `ComprasApp.swift`, `.modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self])` crea la base y la pone a disposición de todas las vistas.
- **Uso:**
  - Las vistas leen con `@Query`, que se actualiza sola, y con `FetchDescriptor` + `#Predicate`.
  - Escriben con `contexto.insert(...)`, cambiando propiedades y con `contexto.delete(...)`, donde el contexto sale de `@Environment(\.modelContext)`.
- **Sesión:** `Sesion` es una clase `@Observable` puesta con `.environment(sesion)`. Si `sesion.usuario` es `nil` se muestra el login; si no, las pestañas.

## Pantallas

| | Comprador | Supervisor |
|---|---|---|
| Pestañas | Productos · Proveedores · Compra · Mis compras | Resumen · Aprobar · Por pagar · Productos · Proveedores |

- **B1 Login** y **B2 Crear cuenta:** el usuario es único sin importar mayúsculas y la clave tiene mínimo 6 caracteres con su confirmación.
- **B3 Productos:** costo promedio, stock en color y valor del inventario (stock × costo promedio). Solo el supervisor crea, edita y borra.
- **B4 Proveedores:** total comprado y "N por pagar" o "Al día", calculados desde las compras de cada proveedor.
- **B5 Nueva compra:** subtotal, IGV 18 % y total, contado o crédito a 30 días, y un aviso cuando llega a S/ 5,000.
- **B6 Mis compras:** Todas, Pendientes o Rechazadas (con su motivo). El comprador solo ve las suyas.
- **B7 Aprobar:** muestra cómo cambiarían el stock y el costo promedio. Rechazar pide un motivo.
- **B8 Por pagar:** Pendientes, Vencidas o Pagadas con `#Predicate`, deslizar para Pagar y el total por pagar.
- **B9 Resumen:** inventario, crédito fiscal, por pagar, por aprobar, total comprado por proveedor con barras y cierre de IGV.
- **Cuenta:** el avatar de arriba a la derecha abre un menú con nombre, rol y Cerrar sesión.

## Organización del código

```
Compras/Compras/
├── ComprasApp.swift        modelContainer, sesión y RaizView (login o pestañas)
├── Modelos.swift           las 4 clases @Model con sus relaciones
├── Reglas.swift            Sesion, IGV, aprobación, costo promedio, formatos
├── Estilo.swift            paleta vintage, botones, tarjetas, filas, menú del avatar
├── DatosEjemplo.swift      datos iniciales
├── LoginView / RegistroView / PrincipalView (barra de pestañas)
├── ProductosView / ProveedoresView      (con sus formularios)
├── NuevaCompraView / MisComprasView
├── AprobarView / PorPagarView / ResumenView
```

## Casos de prueba

Los 9 casos del laboratorio, 2 propios y el del cierre de IGV están en `docs/Expediente.md` (sección 6), con su resultado esperado.

## Cierre de IGV del mes

**IGV por pagar = IGV de ventas (grupo A) − crédito fiscal de compras (grupo B).** Si sale negativo, es saldo a favor.

En el Resumen está la tarjeta **Cierre de IGV del mes**:
1. Toma el crédito fiscal del mes, que es el IGV de las compras aprobadas.
2. Se escribe el IGV de ventas que trae el grupo A.
3. La app calcula el resultado.

Más detalle en `docs/CierreIGV.md`.
