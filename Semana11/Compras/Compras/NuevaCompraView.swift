import SwiftUI
import SwiftData
import UIKit

// B5 · Nueva compra (comprador)
struct NuevaCompraView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]
    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidad = ""
    @State private var costo = ""
    @State private var alCredito = false
    @State private var aviso: String?
    @State private var tituloAviso = ""

    var calculo: Calculo {
        calcularCompra(cantidad: Int(cantidad) ?? 0,
                       costoUnitario: Double(costo.replacingOccurrences(of: ",", with: ".")) ?? 0)
    }

    // Desde S/ 5,000 necesita aprobación del supervisor
    var necesitaAprobacion: Bool {
        calculo.total >= limiteAprobacion
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    fila("Proveedor") {
                        Picker("Proveedor", selection: $proveedor) {
                            Text("Elegir").tag(Proveedor?.none)
                            ForEach(proveedores) { Text($0.nombre).tag(Optional($0)) }
                        }
                    }
                    Divider()
                    fila("Producto") {
                        Picker("Producto", selection: $producto) {
                            Text("Elegir").tag(Producto?.none)
                            ForEach(productos) { Text($0.nombre).tag(Optional($0)) }
                        }
                    }
                    Divider()
                    fila("Cantidad") {
                        cajaNumero("0", texto: $cantidad, teclado: .numberPad)
                    }
                    Divider()
                    fila("Costo unitario") {
                        cajaNumero("0.00", texto: $costo, teclado: .decimalPad)
                    }
                }
                .tarjeta()

                if let producto = producto {
                    Text("Stock actual \(producto.stock) u. · costo promedio \(soles(producto.costoPromedio))")
                        .font(.footnote)
                        .foregroundStyle(Paleta.textoSuave)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }

                Picker("Pago", selection: $alCredito) {
                    Text("Contado").tag(false)
                    Text("Crédito 30 días").tag(true)
                }
                .pickerStyle(.segmented)

                VStack(spacing: 10) {
                    filaMonto("Subtotal", calculo.subtotal)
                    filaMonto("IGV 18% (crédito fiscal)", calculo.igv)
                    Divider()
                    HStack {
                        Text("Total").font(.serif(20))
                        Spacer()
                        Text(soles(calculo.total)).font(.serif(22, .heavy))
                    }
                    .foregroundStyle(Paleta.cafe)
                }
                .tarjeta(Paleta.azul.opacity(0.45))

                if necesitaAprobacion {
                    Label {
                        Text("Supera S/ 5,000: quedará **pendiente de aprobación** del supervisor. No cambia stock ni costo promedio todavía.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .font(.footnote)
                    .foregroundStyle(Paleta.cafe)
                    .tarjeta(Paleta.ambar.opacity(0.25))
                }

                Button(necesitaAprobacion ? "Enviar a aprobación" : "Registrar compra", action: registrar)
                    .buttonStyle(BotonPrincipal(color: necesitaAprobacion ? Paleta.ambar : Paleta.cafe))
            }
            .padding(16)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Paleta.fondo)
        .navigationTitle("Nueva compra")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
        }
        .onChange(of: producto) { _, nuevo in
            // Sugiere el costo promedio actual como costo unitario
            if costo.isEmpty, let nuevo = nuevo {
                costo = String(format: "%.2f", nuevo.costoPromedio)
            }
        }
        .alert(tituloAviso, isPresented: mostrar($aviso)) {
            Button("OK") {}
        } message: {
            Text(aviso ?? "")
        }
    }

    func fila<Contenido: View>(_ titulo: String, @ViewBuilder contenido: () -> Contenido) -> some View {
        HStack {
            Text(titulo).foregroundStyle(Paleta.texto)
            Spacer()
            contenido()
        }
        .frame(minHeight: 46)
    }

    func cajaNumero(_ placeholder: String, texto: Binding<String>, teclado: UIKeyboardType) -> some View {
        TextField(placeholder, text: texto)
            .keyboardType(teclado)
            .multilineTextAlignment(.trailing)
            .font(.body.monospacedDigit())
            .padding(.horizontal, 10)
            .frame(width: 110, height: 36)
            .background(Paleta.fondo, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Paleta.borde))
    }

    func filaMonto(_ titulo: String, _ valor: Double) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(soles(valor))
        }
        .foregroundStyle(Paleta.texto)
    }

    func registrar() {
        guard let proveedor = proveedor, let producto = producto else {
            tituloAviso = "Faltan datos"
            aviso = "Elige un proveedor y un producto."
            return
        }
        guard let laCantidad = Int(cantidad), laCantidad > 0,
              let elCosto = Double(costo.replacingOccurrences(of: ",", with: ".")), elCosto > 0 else {
            tituloAviso = "Datos inválidos"
            aviso = "La cantidad y el costo unitario deben ser mayores a 0."
            return
        }

        let c = calcularCompra(cantidad: laCantidad, costoUnitario: elCosto)
        let compra = Compra(fecha: Date(), cantidad: laCantidad, costoUnitario: elCosto, igv: c.igv, total: c.total, alCredito: alCredito)
        contexto.insert(compra)
        compra.comprador = sesion.usuario
        compra.proveedor = proveedor
        compra.producto = producto

        if c.total >= limiteAprobacion {
            // Queda pendiente: todavía no cambia stock ni costo promedio
            compra.estado = "Pendiente"
            tituloAviso = "Enviada a aprobación"
            aviso = "Total \(soles(c.total)). El supervisor debe aprobarla."
        } else {
            compra.estado = "Aprobada"
            aplicarCompra(compra)
            tituloAviso = "Compra registrada"
            aviso = "Total \(soles(c.total)). \(producto.nombre): stock \(producto.stock) u., costo promedio \(soles(producto.costoPromedio))."
        }
        try? contexto.save()

        self.producto = nil
        cantidad = ""
        costo = ""
        alCredito = false
    }
}
