import SwiftUI

enum Pestana {
    case productos, proveedores, compra, misCompras, resumen, aprobar, porPagar
}

struct ItemPestana: Identifiable {
    let id: Pestana
    let titulo: String
    let icono: String
}

// Pestañas según el rol, en una barra flotante tipo cápsula
// Comprador:  Productos · Proveedores · Compra · Mis compras
// Supervisor: Resumen · Aprobar · Por pagar · Productos · Proveedores
struct PrincipalView: View {
    @Environment(Sesion.self) private var sesion
    @State private var actual: Pestana = .productos

    var items: [ItemPestana] {
        if sesion.esSupervisor {
            return [
                ItemPestana(id: .resumen, titulo: "Resumen", icono: "chart.bar.fill"),
                ItemPestana(id: .aprobar, titulo: "Aprobar", icono: "checkmark.seal.fill"),
                ItemPestana(id: .porPagar, titulo: "Por pagar", icono: "creditcard.fill"),
                ItemPestana(id: .productos, titulo: "Productos", icono: "shippingbox.fill"),
                ItemPestana(id: .proveedores, titulo: "Proveedores", icono: "building.2.fill")
            ]
        }
        return [
            ItemPestana(id: .productos, titulo: "Productos", icono: "shippingbox.fill"),
            ItemPestana(id: .proveedores, titulo: "Proveedores", icono: "building.2.fill"),
            ItemPestana(id: .compra, titulo: "Compra", icono: "cart.fill.badge.plus"),
            ItemPestana(id: .misCompras, titulo: "Mis compras", icono: "doc.text.fill")
        ]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                pantalla
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 64)
            }

            barra
        }
        .onAppear {
            actual = sesion.esSupervisor ? .resumen : .productos
        }
    }

    @ViewBuilder
    var pantalla: some View {
        switch actual {
        case .productos: ProductosView()
        case .proveedores: ProveedoresView()
        case .compra: NuevaCompraView()
        case .misCompras: MisComprasView()
        case .resumen: ResumenView()
        case .aprobar: AprobarView()
        case .porPagar: PorPagarView()
        }
    }

    var barra: some View {
        HStack(spacing: 2) {
            ForEach(items) { item in
                let activa = item.id == actual
                Button {
                    withAnimation(.snappy) { actual = item.id }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: item.icono)
                        if activa {
                            Text(item.titulo).font(.footnote.bold()).lineLimit(1).fixedSize()
                        }
                    }
                    .foregroundStyle(activa ? Paleta.cafe : Paleta.fondo.opacity(0.85))
                    .padding(.horizontal, activa ? 14 : 11)
                    .frame(height: 46)
                    .background(activa ? Paleta.azul : Color.clear, in: Capsule())
                }
            }
        }
        .padding(6)
        .background(Paleta.cafe, in: Capsule())
        .shadow(color: Paleta.cafe.opacity(0.3), radius: 10, y: 4)
        .padding(.bottom, 6)
    }
}
