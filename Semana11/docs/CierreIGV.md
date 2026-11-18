# Cierre de IGV del mes · Grupo B (Compras)

Fórmula: **IGV por pagar = IGV de ventas − crédito fiscal de compras**. Si sale negativo, es **saldo a favor**.

- El **crédito fiscal** lo pone mi app (grupo B): es la suma del IGV de las compras **aprobadas** del mes. Las pendientes y las rechazadas no cuentan.
- El **IGV de ventas** lo trae el grupo A.

## Dónde se ve en la app

Pestaña **Resumen** (supervisor):
- La tarjeta **Crédito fiscal** muestra el IGV de las compras aprobadas desde el día 1 del mes.
- La tarjeta **Cierre de IGV del mes** tiene el botón **Ingresar IGV de ventas** para escribir la cifra del grupo A. La app calcula sola si es **IGV por pagar** o **Saldo a favor**.

## Mis cifras

Con los datos de ejemplo (noviembre 2026):

| Compra aprobada del mes | Subtotal | IGV 18 % |
|---|---|---|
| Distribuidora Lima · Laptop × 10 a 120.00 (crédito) | 1,200.00 | 216.00 |
| Mayorista Sur · Monitor × 5 a 300.00 (crédito) | 1,500.00 | 270.00 |
| TecnoImport · Teclado × 20 a 80.00 (contado) | 1,600.00 | 288.00 |
| **Crédito fiscal del mes** | | **774.00** |

No cuentan la compra de mouse (es del mes pasado) ni la de monitores rechazada.

> La cifra que vale para la clase es la que muestre la tarjeta el día de la entrega: cambia si se registran o aprueban más compras. Captura: `docs/capturas/cierre_igv.png`.

El mismo cálculo está hecho con fórmulas en la hoja **Cierre IGV** de `Excel/Compras_Semana11.xlsx`.

## Cuadro para completar en clase

| Concepto | Monto |
|---|---|
| IGV de ventas (grupo A) | S/ ________ |
| Crédito fiscal de compras (grupo B) | S/ 774.00 |
| **IGV por pagar / saldo a favor** | S/ ________ |

Ejemplo del enunciado: IGV de ventas 734.10 − crédito fiscal 2,361.60 = −1,627.50 → **saldo a favor de S/ 1,627.50**.
