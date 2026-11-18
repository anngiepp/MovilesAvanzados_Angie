# Guía rápida en la Mac

## 1. Abrir y correr

1. Abrir `Semana11/Compras/Compras.xcodeproj`.
2. Elegir un simulador de iPhone y presionar **⌘R**.
3. Para empezar con datos limpios: mantener presionado el ícono **Compras** en el simulador ▶ Eliminar app ▶ volver a correr.

## 2. Probar los casos

| N.º | Cómo probarlo |
|---|---|
| 1 | Crear cuenta: Marco Torres / `mtorres` / Comprador → entra. Cerrar sesión (avatar) y crear otra vez `MTORRES` → "Ya existe" / usuario repetido |
| 2 | Login `angie1` con clave mala → "Usuario o clave incorrectos" |
| 3 | Login `angie1` / `123456` → Compra: Distribuidora Lima, Laptop Pro 14, cantidad 10, costo 120, **Crédito 30 días** → total S/ 1,416.00, stock 50, costo promedio 112.00 |
| 4 | Igual que el 3 pero **Contado** → como `angie2`, en Por pagar ▶ Pendientes no aparece |
| 5 | (Con datos limpios) Laptop, cantidad 50, costo 120 → total 7,080.00 → "Enviar a aprobación"; en Productos la laptop sigue en 40 |
| 6 | Login `angie2` / `123456` → Aprobar → **Aprobar** → stock 90, costo promedio 115.56, aparece en Por pagar |
| 7 | Hacer otra compra grande con `angie1`; con `angie2` tocar Rechazar sin motivo (no deja) y luego con motivo → en Mis compras de `angie1` se ve el motivo |
| 8 | `angie2` → Por pagar ▶ Vencidas → TecnoImport con VENCIDA → deslizar **Pagar** → pasa a Pagadas y el total baja 2,183.00 |
| 9 | `angie1` → Mis compras: solo sus compras y ninguna opción de pagar |
| 10 | `angie1` → Productos: sin "+" y sin borrar |
| 11 | `angie2` → Proveedores → deslizar Distribuidora Lima → "No se puede borrar" |
| 12 | `angie2` → Resumen ▶ Cierre de IGV ▶ Ingresar IGV de ventas `734.10` |

## 3. Capturas

En el simulador **⌘S** guarda la captura en el Escritorio. Muévelas a `Semana11/docs/capturas/` con estos nombres:

| Archivo | Qué mostrar |
|---|---|
| `b1_login.png` | Login (y `caso2_login_error.png` con el error) |
| `b2_registro.png` | Crear cuenta con "✓ Disponible" (y `caso1_usuario_repetido.png`) |
| `b3_productos.png` | Productos con el valor del inventario |
| `b4_proveedores.png` | Proveedores con "por pagar" y "Al día" |
| `b5_compra_credito.png` | Caso 3 antes de registrar (total 1,416.00) |
| `b5_compra_aprobacion.png` | Caso 5 con el aviso de S/ 5,000 |
| `b6_mis_compras.png` | Mis compras con una rechazada y su motivo |
| `b7_aprobar.png` | Aprobar con la vista previa 40 → 90 y 110.00 → 115.56 |
| `b8_por_pagar.png` | Por pagar ▶ Vencidas con VENCIDA |
| `b9_resumen.png` | Resumen con inventario, crédito fiscal y barras |
| `cierre_igv.png` | Tarjeta del cierre de IGV con el IGV de ventas ingresado |
| `menu_cuenta.png` | Menú del avatar con Cerrar sesión |
| `inicio.png` | Pantalla de inicio (⇧⌘H) con el ícono "Compras" |

## 4. Subir

```bash
cd ~/Desktop/MovilesAvanzados_Angie
git add Semana11
git commit -m "semana11: capturas de los casos de prueba"
git push
```
