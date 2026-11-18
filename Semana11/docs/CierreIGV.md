# Cierre de IGV del mes · Grupo A (Ventas)

Fórmula: **IGV por pagar = IGV de ventas − crédito fiscal de compras**. Si sale negativo, es **saldo a favor**.

- El **IGV de ventas** lo pone mi app (grupo A): suma del IGV de las ventas **no anuladas** del mes.
- El **crédito fiscal** lo trae el grupo B (IGV de sus compras).

## Dónde se ve en la app

Pestaña **Resumen** (supervisor) ▶ tarjeta **Cierre de IGV del mes**:

1. Muestra el IGV de ventas del mes, calculado con un fetch de las ventas no anuladas desde el día 1.
2. Botón **Ingresar crédito fiscal**: se escribe el monto del grupo B.
3. Calcula solo y muestra **IGV por pagar** o **Saldo a favor**.

## Mis cifras

Con los datos de ejemplo y los casos de prueba hechos (el caso 4 queda anulado en el caso 8):

| Venta (no anulada) | Base (subtotal − descuento) | IGV 18 % |
|---|---|---|
| Comercial Andina · Monitor × 4 | 1,800.00 | 324.00 |
| María Quispe · Monitor × 3 | 1,350.00 | 243.00 |
| Comercial Andina · Monitor × 4 | 1,800.00 | 324.00 |
| Luis Rojas · Mouse × 7 | 245.00 | 44.10 |
| Comercial Andina · Monitor × 4 (VIP, −10 %) | 1,620.00 | 291.60 |
| Luis Rojas · Teclado × 1 | 129.90 | 23.38 |
| Caso 5 · Tienda Sol · Mouse × 3 | 105.00 | 18.90 |
| Caso 11 · Tienda Sol · Laptop × 8 | 1,600.00 | 288.00 |
| **Total IGV de ventas** | | **1,556.98** |

> La cifra final es la que muestre la tarjeta el día de la entrega (cambia si se registran o anulan más ventas). Captura: `docs/capturas/cierre_igv.png`.

## Cuadro para completar en clase

| Concepto | Monto |
|---|---|
| IGV de ventas (grupo A) | S/ 1,556.98 |
| Crédito fiscal de compras (grupo B) | S/ ________ |
| **IGV por pagar / saldo a favor** | S/ ________ |

Ejemplo con el crédito fiscal del enunciado (S/ 2,361.60): 1,556.98 − 2,361.60 = −804.62 → **saldo a favor de S/ 804.62**.
