# Guía rápida para terminar en la Mac

Todo el código ya está listo. En la Mac solo falta compilar, probar y sacar capturas.

## 1. Bajar el repo (2 min)

```bash
cd ~/Desktop
git clone https://github.com/anngiepp/MovilesAvanzados_Angie.git   # o: git pull si ya lo tienes
open MovilesAvanzados_Angie/Semana11/Ventas/Ventas.xcodeproj
```

## 2. Compilar (3 min)

1. Arriba elegir el esquema **Ventas** y un simulador (iPhone 16 o el que haya).
2. **⌘R**. Si pide equipo de firma, en el simulador no hace falta; si molesta: target ▶ Signing & Capabilities ▶ Team = tu Apple ID.
3. Si el proyecto no abre (plan B): File ▶ New ▶ Project ▶ App, nombre `Ventas`, Interface **Storyboard**, Storage **Core Data**. Borra `ViewController.swift`, `Main.storyboard` y el `.xcdatamodeld` que crea, y arrastra todo el contenido de `Semana11/Ventas/Ventas/`. En Info quita la entrada *Main storyboard file base name* y la de *Storyboard Name* dentro de *Application Scene Manifest*.

## 3. Probar los casos (15 min)

| N.º | Cómo probarlo |
|---|---|
| 1 | Crear cuenta: Lucía Paredes / `lparedes` / Supervisor → entra. Cerrar sesión, crear `LPAREDES` → "Usuario repetido" |
| 2 | Crear cuenta con claves distintas, y con clave `1234` → mensajes de error |
| 3 | Login `cruiz` con clave mala → "Usuario o clave incorrectos" |
| 4 | Login `cruiz` / `123456` → Venta: Comercial Andina SAC, Laptop Pro 14, cantidad 2 → total S/ 424.80, stock 38 |
| 5 | Venta: Tienda Sol EIRL, Mouse inalámbrico, cantidad 3 → total S/ 123.90 |
| 6 | Venta: Laptop Pro 14, escribir 50 → "Stock insuficiente" |
| 7 | Mis ventas como `cruiz` → solo sus ventas, sin deslizar |
| 8 | Login `lparedes` → Ventas → deslizar la venta del caso 4 → Anular sin motivo (botón gris) y con motivo → stock 40, Resumen baja 424.80 |
| 9 | Clientes → deslizar Comercial Andina → "No se puede borrar" |
| 10 | Como `cruiz` en Productos → sin "+" y sin borrar |
| 11 | Como `cruiz`: venta a Tienda Sol de 8 Laptop → en Clientes pasa a Frecuente |
| 12 | Como `lparedes` en Resumen → Cierre de IGV → Ingresar crédito fiscal `2361.60` → "Saldo a favor". Captura `cierre_igv.png` y anota el IGV de ventas en `docs/CierreIGV.md` |

Toma captura de cada pantalla con **⌘S** en el simulador (se guardan en el Escritorio) y pásalas a `Semana11/docs/capturas/`.

## 4. Ícono (1 min)

Ya está puesto en `Assets.xcassets ▶ AppIcon` y el nombre "Ventas" en Display Name. Detén la app, **Shift + ⌘ + H** en el simulador y captura la pantalla de inicio (`docs/capturas/inicio.png`).

## 5. Subir

```bash
cd ~/Desktop/MovilesAvanzados_Angie
git add Semana11
git commit -m "semana11: capturas de los casos de prueba e ícono"
git push
```

## Para borrar los datos y empezar de cero

En el simulador mantener presionado el ícono ▶ Eliminar app, y volver a correr.
