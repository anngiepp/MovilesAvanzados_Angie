import SwiftUI
import SwiftData

// B7 · Aprobar (supervisor): compras de S/ 5,000 o más
struct AprobarView: View {
    @Environment(\.modelContext) private var contexto
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]
    @State private var rechazando: Compra?
    @State private var motivo = ""
    @State private var aviso: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                if pendientes.isEmpty {
                    Banner(icono: "checkmark.seal.fill", titulo: "Todo al día", detalle: "No hay compras por aprobar")
                }
                ForEach(pendientes) { compra in
                    tarjetaCompra(compra)
                }
                Text("Al rechazar se pide un motivo, que el comprador verá en \"Mis compras\".")
                    .font(.footnote)
                    .foregroundStyle(Paleta.textoSuave)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
        .background(Paleta.fondo)
        .navigationTitle("Aprobar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
        }
        .alert("Rechazar compra", isPresented: Binding(get: { rechazando != nil }, set: { if !$0 { rechazando = nil } })) {
            TextField("Motivo (obligatorio)", text: $motivo)
            Button("Cancelar", role: .cancel) {}
            Button("Rechazar", role: .destructive) { rechazar() }
        } message: {
            Text("El comprador verá el motivo en Mis compras.")
        }
        .alert("Falta el motivo", isPresented: mostrar($aviso)) {
            Button("OK") {}
        } message: {
            Text(aviso ?? "")
        }
    }

    func tarjetaCompra(_ compra: Compra) -> some View {
        let producto = compra.producto
        let stockAntes = producto?.stock ?? 0
        let costoAntes = producto?.costoPromedio ?? 0
        let costoDespues = nuevoCostoPromedio(stock: stockAntes, costoPromedio: costoAntes,
                                              cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text("\(compra.proveedor?.nombre ?? "") · \(producto?.nombre ?? "")").font(.serif(18))
                Spacer()
                Etiqueta(texto: "Pendiente", color: Paleta.ambar)
            }
            Text("Solicitó: \(compra.comprador?.nombre ?? "") · \(textoFecha(compra.fecha))")
                .font(.footnote)
                .foregroundStyle(Paleta.textoSuave)
            Text("\(compra.cantidad) u. × \(soles(compra.costoUnitario)) = \(soles(compra.subtotal))")
            Text(verbatim: "IGV 18% \(soles(compra.igv)) · ") + Text(verbatim: "Total \(soles(compra.total))").bold()
            Text(compra.alCredito ? "Crédito 30 días · vence \(textoFecha(compra.vence))" : "Contado")
                .foregroundStyle(Paleta.textoSuave)

            // Vista previa del efecto si se aprueba
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: "Si apruebas: stock ") + Text(verbatim: "\(stockAntes) → \(stockAntes + compra.cantidad)").bold()
                Text(verbatim: "Costo promedio ") + Text(verbatim: "\(soles(costoAntes)) → \(soles(costoDespues))").bold()
            }
            .font(.subheadline)
            .tarjeta(Paleta.azul.opacity(0.4))

            HStack(spacing: 12) {
                Button("Rechazar") {
                    motivo = ""
                    rechazando = compra
                }
                .buttonStyle(BotonBorde(color: Paleta.rojo))

                Button("Aprobar") { aprobar(compra) }
                    .buttonStyle(BotonPrincipal())
            }
        }
        .foregroundStyle(Paleta.texto)
        .tarjeta()
    }

    func aprobar(_ compra: Compra) {
        compra.estado = "Aprobada"
        aplicarCompra(compra)   // ahora sí cambian stock y costo promedio
        try? contexto.save()
    }

    func rechazar() {
        guard let compra = rechazando else { return }
        let texto = motivo.trimmingCharacters(in: .whitespaces)
        if texto.isEmpty {
            aviso = "Para rechazar una compra tienes que escribir el motivo."
            return
        }
        compra.estado = "Rechazada"
        compra.motivoRechazo = texto
        try? contexto.save()
    }
}
