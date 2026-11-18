import SwiftUI
import SwiftData

// B6 · Mis compras: el comprador solo ve las suyas; no puede pagar ni aprobar
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]
    @State private var filtro = 0
    @State private var busqueda = ""

    var mias: [Compra] {
        compras
            .filter { $0.comprador == sesion.usuario }
            .filter {
                switch filtro {
                case 1: return $0.estado == "Pendiente"
                case 2: return $0.estado == "Rechazada"
                default: return true
                }
            }
            .filter { busqueda.isEmpty || ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        List {
            Picker("Filtro", selection: $filtro) {
                Text("Todas").tag(0)
                Text("Pendientes").tag(1)
                Text("Rechazadas").tag(2)
            }
            .pickerStyle(.segmented)
            .filaLimpia()

            ForEach(mias) { compra in
                FilaTarjeta(iniciales: "", icono: icono(compra), colorAvatar: colorFondo(compra),
                            titulo: compra.proveedor?.nombre ?? "",
                            subtitulo: "\(compra.producto?.nombre ?? "") × \(compra.cantidad) · \(textoFecha(compra.fecha))",
                            nota: compra.motivoRechazo.map { "Motivo: \($0)" },
                            franja: colorEstado(compra.estado)) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(soles(compra.total)).font(.serif(15)).foregroundStyle(Paleta.cafe)
                        Etiqueta(texto: compra.estado, color: colorEstado(compra.estado))
                    }
                }
                .filaLimpia()
            }

            if mias.isEmpty {
                Text("No hay compras con este filtro.").font(.footnote).foregroundStyle(Paleta.textoSuave).filaLimpia()
            }

            Text("Solo ves tus compras. No puedes pagar ni aprobar.")
                .font(.footnote)
                .foregroundStyle(Paleta.textoSuave)
                .filaLimpia()
        }
        .listStyle(.plain)
        .fondoCrema()
        .navigationTitle("Mis compras")
        .searchable(text: $busqueda, prompt: "Buscar por proveedor")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
        }
    }

    func icono(_ compra: Compra) -> String {
        switch compra.estado {
        case "Pendiente": return "hourglass"
        case "Rechazada": return "xmark"
        default: return "checkmark"
        }
    }

    func colorFondo(_ compra: Compra) -> Color {
        switch compra.estado {
        case "Pendiente": return Paleta.arena
        case "Rechazada": return Paleta.rosa
        default: return Paleta.azul
        }
    }
}
