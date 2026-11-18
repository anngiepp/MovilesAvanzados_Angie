import SwiftUI
import SwiftData

// B3 · Productos
// Comprador: solo consulta. Supervisor: crea, edita y borra.
struct ProductosView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @Query(sort: \Producto.nombre) private var productos: [Producto]
    @State private var busqueda = ""
    @State private var creando = false
    @State private var editando: Producto?
    @State private var aviso: String?

    var filtrados: [Producto] {
        busqueda.isEmpty ? productos : productos.filter { $0.nombre.localizedCaseInsensitiveContains(busqueda) }
    }

    // Valor del inventario = stock × costo promedio
    var valorInventario: Double {
        productos.reduce(0) { $0 + Double($1.stock) * $1.costoPromedio }
    }

    var body: some View {
        List {
            Banner(icono: "shippingbox.fill", titulo: soles(valorInventario), detalle: "Valor del inventario (stock × costo promedio)")
                .filaLimpia()

            ForEach(filtrados) { producto in
                FilaTarjeta(iniciales: iniciales(producto.nombre), colorAvatar: colorPara(producto.categoria),
                            titulo: producto.nombre, subtitulo: producto.categoria, franja: colorStock(producto.stock)) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(soles(producto.costoPromedio)).font(.serif(16)).foregroundStyle(Paleta.cafe)
                        Text("costo prom.").font(.caption2).foregroundStyle(Paleta.textoSuave)
                        Etiqueta(texto: "\(producto.stock) u.", color: colorStock(producto.stock))
                    }
                }
                .filaLimpia()
                .contentShape(Rectangle())
                .onTapGesture {
                    if sesion.esSupervisor { editando = producto }
                }
            }
            .onDelete(perform: sesion.esSupervisor ? borrar : nil)

            Text(sesion.esSupervisor ? "Toca para editar. Desliza para borrar (no se puede si tiene compras)." : "Vista de comprador: solo consulta.")
                .font(.footnote)
                .foregroundStyle(Paleta.textoSuave)
                .filaLimpia()
        }
        .listStyle(.plain)
        .fondoCrema()
        .navigationTitle("Productos")
        .searchable(text: $busqueda, prompt: "Buscar producto")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if sesion.esSupervisor {
                    Button { creando = true } label: { Image(systemName: "plus") }
                }
                MenuCuenta()
            }
        }
        .sheet(isPresented: $creando) { ProductoForm(producto: nil) }
        .sheet(item: $editando) { ProductoForm(producto: $0) }
        .alert("No se puede borrar", isPresented: mostrar($aviso)) {
            Button("OK") {}
        } message: {
            Text(aviso ?? "")
        }
    }

    func borrar(_ posiciones: IndexSet) {
        for i in posiciones {
            let producto = filtrados[i]
            // .deny: si tiene compras no se borra
            if !producto.compras.isEmpty {
                aviso = "\(producto.nombre) tiene compras registradas."
                return
            }
            contexto.delete(producto)
        }
        try? contexto.save()
    }
}

struct ProductoForm: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var cerrar
    let producto: Producto?
    @State private var nombre = ""
    @State private var categoria = ""
    @State private var costo = ""
    @State private var stock = ""
    @State private var aviso: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Producto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Categoría (ej. Laptops)", text: $categoria)
                }
                .listRowBackground(Paleta.tarjeta)
                Section("Inventario") {
                    TextField("Costo promedio", text: $costo).keyboardType(.decimalPad)
                    TextField("Stock", text: $stock).keyboardType(.numberPad)
                }
                .listRowBackground(Paleta.tarjeta)
            }
            .fondoCrema()
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { cerrar() } }
                ToolbarItem(placement: .confirmationAction) { Button("Guardar", action: guardar) }
            }
            .onAppear {
                if let p = producto {
                    nombre = p.nombre
                    categoria = p.categoria
                    costo = String(format: "%.2f", p.costoPromedio)
                    stock = "\(p.stock)"
                }
            }
            .alert("Datos incompletos", isPresented: mostrar($aviso)) {
                Button("OK") {}
            } message: {
                Text(aviso ?? "")
            }
        }
    }

    func guardar() {
        let elNombre = nombre.trimmingCharacters(in: .whitespaces)
        let laCategoria = categoria.trimmingCharacters(in: .whitespaces)
        guard !elNombre.isEmpty, !laCategoria.isEmpty,
              let elCosto = Double(costo.replacingOccurrences(of: ",", with: ".")), elCosto >= 0,
              let elStock = Int(stock), elStock >= 0 else {
            aviso = "Revisa nombre, categoría, costo y stock."
            return
        }
        if let p = producto {
            p.nombre = elNombre
            p.categoria = laCategoria
            p.costoPromedio = elCosto
            p.stock = elStock
        } else {
            contexto.insert(Producto(nombre: elNombre, categoria: laCategoria, stock: elStock, costoPromedio: elCosto))
        }
        try? contexto.save()
        cerrar()
    }
}
