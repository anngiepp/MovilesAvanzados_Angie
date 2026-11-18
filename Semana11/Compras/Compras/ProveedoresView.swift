import SwiftUI
import SwiftData

// B4 · Proveedores
// "por pagar" y "comprado" se calculan con la relación proveedor ▸ compras
struct ProveedoresView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @State private var busqueda = ""
    @State private var creando = false
    @State private var editando: Proveedor?
    @State private var aviso: String?

    var filtrados: [Proveedor] {
        busqueda.isEmpty ? proveedores : proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) || $0.ruc.contains(busqueda)
        }
    }

    var conDeuda: Int {
        proveedores.filter { $0.cantidadPorPagar > 0 }.count
    }

    var body: some View {
        List {
            Banner(icono: "building.2.fill", titulo: "\(proveedores.count) proveedores",
                   detalle: conDeuda == 0 ? "Todos al día" : "\(conDeuda) con compras por pagar", fondo: Paleta.arena)
                .filaLimpia()

            ForEach(filtrados) { proveedor in
                let deuda = proveedor.cantidadPorPagar
                FilaTarjeta(iniciales: iniciales(proveedor.nombre), colorAvatar: colorPara(proveedor.nombre),
                            titulo: proveedor.nombre, subtitulo: "RUC " + proveedor.ruc,
                            franja: deuda > 0 ? Paleta.rojo : Paleta.azul) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(soles(proveedor.totalComprado)).font(.serif(16)).foregroundStyle(Paleta.cafe)
                        Text("comprado").font(.caption2).foregroundStyle(Paleta.textoSuave)
                        if deuda > 0 {
                            Etiqueta(texto: "\(deuda) por pagar", color: Paleta.rojo)
                        } else {
                            Etiqueta(texto: "Al día", color: Paleta.azulFuerte)
                        }
                    }
                }
                .filaLimpia()
                .contentShape(Rectangle())
                .onTapGesture {
                    if sesion.esSupervisor { editando = proveedor }
                }
            }
            .onDelete(perform: sesion.esSupervisor ? borrar : nil)

            Text("\"Por pagar\" y \"comprado\" salen de las compras de cada proveedor (relación proveedor ▸ compras).")
                .font(.footnote)
                .foregroundStyle(Paleta.textoSuave)
                .filaLimpia()
        }
        .listStyle(.plain)
        .fondoCrema()
        .navigationTitle("Proveedores")
        .searchable(text: $busqueda, prompt: "Buscar por nombre o RUC")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if sesion.esSupervisor {
                    Button { creando = true } label: { Image(systemName: "plus") }
                }
                MenuCuenta()
            }
        }
        .sheet(isPresented: $creando) { ProveedorForm(proveedor: nil) }
        .sheet(item: $editando) { ProveedorForm(proveedor: $0) }
        .alert("No se puede borrar", isPresented: mostrar($aviso)) {
            Button("OK") {}
        } message: {
            Text(aviso ?? "")
        }
    }

    func borrar(_ posiciones: IndexSet) {
        for i in posiciones {
            let proveedor = filtrados[i]
            if !proveedor.compras.isEmpty {
                aviso = "\(proveedor.nombre) tiene compras registradas."
                return
            }
            contexto.delete(proveedor)
        }
        try? contexto.save()
    }
}

struct ProveedorForm: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var cerrar
    let proveedor: Proveedor?
    @State private var nombre = ""
    @State private var ruc = ""
    @State private var aviso: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Proveedor") {
                    TextField("Razón social", text: $nombre)
                    TextField("RUC (11 dígitos)", text: $ruc).keyboardType(.numberPad)
                }
                .listRowBackground(Paleta.tarjeta)
            }
            .fondoCrema()
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { cerrar() } }
                ToolbarItem(placement: .confirmationAction) { Button("Guardar", action: guardar) }
            }
            .onAppear {
                if let p = proveedor {
                    nombre = p.nombre
                    ruc = p.ruc
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
        let elRuc = ruc.trimmingCharacters(in: .whitespaces)
        guard !elNombre.isEmpty, elRuc.count == 11 else {
            aviso = "Escribe la razón social y un RUC de 11 dígitos."
            return
        }
        if let p = proveedor {
            p.nombre = elNombre
            p.ruc = elRuc
        } else {
            contexto.insert(Proveedor(nombre: elNombre, ruc: elRuc))
        }
        try? contexto.save()
        cerrar()
    }
}
