import SwiftUI
import SwiftData

// B9 · Resumen del supervisor
struct ResumenView: View {
    @Environment(Sesion.self) private var sesion
    @Query private var productos: [Producto]
    @Query private var compras: [Compra]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    // IGV de ventas que trae el grupo A para el cierre (se guarda en el teléfono)
    @AppStorage("igvVentas") private var igvVentas = 0.0
    @State private var pidiendoIGV = false
    @State private var textoIGV = ""

    var inventario: Double {
        productos.reduce(0) { $0 + Double($1.stock) * $1.costoPromedio }
    }

    // Crédito fiscal del mes: IGV de las compras aprobadas desde el día 1
    var creditoFiscal: Double {
        compras.filter { $0.estado == "Aprobada" && $0.fecha >= inicioDelMes() }.reduce(0) { $0 + $1.igv }
    }

    var porPagar: Double {
        compras.filter { $0.porPagar }.reduce(0) { $0 + $1.total }
    }

    var pendientes: [Compra] {
        compras.filter { $0.estado == "Pendiente" }
    }

    var ranking: [FilaRanking] {
        proveedores.map { FilaRanking(nombre: $0.nombre, total: $0.totalComprado) }.sorted { $0.total > $1.total }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                let fecha = textoFecha(Date(), "EEEE d 'de' MMMM")
                Text(fecha.prefix(1).uppercased() + fecha.dropFirst()).font(.subheadline).foregroundStyle(Paleta.textoSuave)
                Text("Hola, \(primerNombre(sesion.usuario?.nombre ?? "")) ✱").font(.serif(30, .heavy)).foregroundStyle(Paleta.cafe)

                // Inventario en grande
                VStack(alignment: .leading, spacing: 4) {
                    Text("VALOR DEL INVENTARIO").font(.caption.bold()).foregroundStyle(Paleta.azul)
                    Text(soles(inventario)).font(.serif(38, .heavy)).foregroundStyle(Paleta.fondo)
                    Text("stock × costo promedio de \(productos.count) productos").font(.caption).foregroundStyle(Paleta.arena)
                }
                .tarjeta(Paleta.cafe)

                HStack(spacing: 12) {
                    indicador("Crédito fiscal", soles(creditoFiscal), "IGV de compras del mes", Paleta.azul)
                    indicador("Por pagar", soles(porPagar), "crédito sin pagar", Paleta.arena)
                }
                indicador("Por aprobar", "\(pendientes.count)", "\(soles(pendientes.reduce(0) { $0 + $1.total })) en espera", Paleta.salvia)

                barras
                cierre
            }
            .padding(16)
        }
        .background(Paleta.fondo)
        .navigationTitle("Resumen")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
        }
        .alert("IGV de ventas (grupo A)", isPresented: $pidiendoIGV) {
            TextField("Ej. 734.10", text: $textoIGV).keyboardType(.decimalPad)
            Button("Cancelar", role: .cancel) {}
            Button("Calcular") {
                igvVentas = Double(textoIGV.replacingOccurrences(of: ",", with: ".")) ?? igvVentas
            }
        } message: {
            Text("Escribe el IGV de ventas del mes que trae el grupo A.")
        }
    }

    func indicador(_ titulo: String, _ valor: String, _ detalle: String, _ fondo: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo.uppercased()).font(.caption.bold()).foregroundStyle(Paleta.cafe)
            Text(valor).font(.serif(22)).foregroundStyle(Paleta.texto).lineLimit(1).minimumScaleFactor(0.6)
            Text(detalle).font(.caption).foregroundStyle(Paleta.cafe.opacity(0.8))
        }
        .tarjeta(fondo)
    }

    // Total comprado por proveedor con barras
    var barras: some View {
        let maximo = max(ranking.first?.total ?? 1, 1)
        return VStack(alignment: .leading, spacing: 12) {
            Text("Total comprado por proveedor").font(.serif(17)).foregroundStyle(Paleta.cafe)
            ForEach(ranking) { item in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(item.nombre).font(.subheadline.bold())
                        Spacer()
                        Text(soles(item.total)).font(.subheadline).foregroundStyle(Paleta.textoSuave)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Paleta.borde)
                            Capsule().fill(Paleta.azulFuerte).frame(width: geo.size.width * item.total / maximo)
                        }
                    }
                    .frame(height: 8)
                }
                .foregroundStyle(Paleta.texto)
            }
        }
        .tarjeta()
    }

    // Cierre de IGV con el grupo A: IGV por pagar = IGV de ventas − crédito fiscal
    var cierre: some View {
        let diferencia = redondear(igvVentas - creditoFiscal)
        return VStack(alignment: .leading, spacing: 10) {
            Text("Cierre de IGV del mes").font(.serif(17)).foregroundStyle(Paleta.cafe)
            HStack { Text("IGV de ventas (grupo A)"); Spacer(); Text(soles(igvVentas)) }
            HStack { Text("Crédito fiscal (mis compras)"); Spacer(); Text("− " + soles(creditoFiscal)) }
            HStack {
                Text(diferencia < 0 ? "Saldo a favor" : "IGV por pagar").bold()
                Spacer()
                Text(soles(abs(diferencia))).font(.serif(18, .heavy))
            }
            .tarjeta(diferencia < 0 ? Paleta.azul.opacity(0.45) : Paleta.arena)

            Button(igvVentas == 0 ? "Ingresar IGV de ventas" : "Cambiar IGV de ventas") {
                textoIGV = igvVentas == 0 ? "" : String(format: "%.2f", igvVentas)
                pidiendoIGV = true
            }
            .font(.subheadline.bold())
        }
        .font(.subheadline)
        .foregroundStyle(Paleta.texto)
        .tarjeta()
    }
}

struct FilaRanking: Identifiable {
    let nombre: String
    let total: Double
    var id: String { nombre }
}
