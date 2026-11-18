import SwiftUI
import SwiftData

// B8 · Por pagar (supervisor): compras aprobadas al crédito
struct PorPagarView: View {
    @State private var filtro = 0
    @State private var busqueda = ""
    @Query(filter: #Predicate<Compra> { $0.estado == "Aprobada" && $0.alCredito == true && $0.pagada == false })
    private var deudas: [Compra]

    var totalPorPagar: Double {
        deudas.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                Picker("Filtro", selection: $filtro) {
                    Text("Pendientes").tag(0)
                    Text("Vencidas").tag(1)
                    Text("Pagadas").tag(2)
                }
                .pickerStyle(.segmented)

                VStack(alignment: .leading, spacing: 4) {
                    Text("TOTAL POR PAGAR").font(.caption.bold()).foregroundStyle(Paleta.azul)
                    Text(soles(totalPorPagar)).font(.serif(32, .heavy)).foregroundStyle(Paleta.fondo)
                    Text("Solo cuentan compras aprobadas a crédito y no pagadas").font(.caption).foregroundStyle(Paleta.arena)
                }
                .tarjeta(Paleta.cafe)
            }
            .padding(.horizontal, 16)

            // La lista se arma con un #Predicate distinto según el filtro
            ListaPorPagar(filtro: filtro, busqueda: busqueda)
        }
        .background(Paleta.fondo)
        .navigationTitle("Por pagar")
        .searchable(text: $busqueda, prompt: "Buscar por proveedor")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
        }
    }
}

struct ListaPorPagar: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @Query private var compras: [Compra]
    let busqueda: String

    init(filtro: Int, busqueda: String) {
        self.busqueda = busqueda
        let ahora = Date()
        let predicado: Predicate<Compra>
        switch filtro {
        case 1:
            predicado = #Predicate { $0.estado == "Aprobada" && $0.alCredito == true && $0.pagada == false && $0.vence < ahora }
        case 2:
            predicado = #Predicate { $0.estado == "Aprobada" && $0.alCredito == true && $0.pagada == true }
        default:
            predicado = #Predicate { $0.estado == "Aprobada" && $0.alCredito == true && $0.pagada == false }
        }
        _compras = Query(filter: predicado, sort: \Compra.vence)
    }

    var filtradas: [Compra] {
        busqueda.isEmpty ? compras : compras.filter { ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        List {
            ForEach(filtradas) { compra in
                FilaTarjeta(iniciales: iniciales(compra.proveedor?.nombre ?? ""), colorAvatar: colorPara(compra.proveedor?.nombre ?? ""),
                            titulo: compra.proveedor?.nombre ?? "",
                            subtitulo: "\(compra.producto?.nombre ?? "") × \(compra.cantidad) · vence \(textoFecha(compra.vence))",
                            franja: compra.vencida ? Paleta.rojo : (compra.pagada ? Paleta.salvia : Paleta.azul)) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(soles(compra.total)).font(.serif(15)).foregroundStyle(Paleta.cafe)
                        if compra.vencida {
                            Etiqueta(texto: "VENCIDA", color: Paleta.rojo)
                        } else if compra.pagada {
                            Etiqueta(texto: "Pagada", color: Paleta.azulFuerte)
                        }
                    }
                }
                .filaLimpia()
                .swipeActions(edge: .trailing) {
                    if sesion.esSupervisor && !compra.pagada {
                        Button("Pagar") {
                            compra.pagada = true
                            try? contexto.save()
                        }
                        .tint(Paleta.azulFuerte)
                    }
                }
            }

            if filtradas.isEmpty {
                Text("No hay compras en este filtro.").font(.footnote).foregroundStyle(Paleta.textoSuave).filaLimpia()
            }

            Text("Desliza a la izquierda para marcar como pagada.")
                .font(.footnote)
                .foregroundStyle(Paleta.textoSuave)
                .filaLimpia()
        }
        .listStyle(.plain)
        .fondoCrema()
    }
}
