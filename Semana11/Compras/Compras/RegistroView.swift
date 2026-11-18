import SwiftUI
import SwiftData

// B2 · Crear cuenta
struct RegistroView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmar = ""
    @State private var rol = "Comprador"
    @State private var mensaje: String?

    var aviso: String? {
        let texto = usuario.trimmingCharacters(in: .whitespaces)
        if texto.isEmpty { return nil }
        return existe(texto) ? "✕ Ya existe" : "✓ Disponible"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Banner(icono: "person.badge.plus", titulo: "Únete al equipo", detalle: "Elige tu rol: comprador o supervisor")

                CampoSubrayado(titulo: "NOMBRE COMPLETO", texto: $nombre, placeholder: "Ej. Marco Torres")
                CampoSubrayado(titulo: "USUARIO", texto: $usuario, placeholder: "Ej. mtorres",
                               aviso: aviso, colorAviso: aviso == "✕ Ya existe" ? Paleta.rojo : Paleta.azulFuerte)
                CampoSubrayado(titulo: "CLAVE (MÍNIMO 6 CARACTERES)", texto: $clave, placeholder: "••••••", seguro: true)
                CampoSubrayado(titulo: "CONFIRMAR CLAVE", texto: $confirmar, placeholder: "••••••", seguro: true)

                VStack(alignment: .leading, spacing: 8) {
                    Text("TU ROL").font(.caption.bold()).foregroundStyle(Paleta.azulFuerte)
                    Picker("Rol", selection: $rol) {
                        Text("Comprador").tag("Comprador")
                        Text("Supervisor").tag("Supervisor")
                    }
                    .pickerStyle(.segmented)
                }

                Button("Registrarme", action: registrar)
                    .buttonStyle(BotonPrincipal())

                Text("Al registrarte entras directo a la app con las pestañas de tu rol.")
                    .font(.footnote)
                    .foregroundStyle(Paleta.textoSuave)
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Paleta.fondo)
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .alert("Revisa los datos", isPresented: mostrar($mensaje)) {
            Button("OK") {}
        } message: {
            Text(mensaje ?? "")
        }
    }

    // Usuario único sin importar mayúsculas (se guardan en minúsculas)
    func existe(_ texto: String) -> Bool {
        let buscado = texto.lowercased()
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        return ((try? contexto.fetchCount(descriptor)) ?? 0) > 0
    }

    func registrar() {
        let elNombre = nombre.trimmingCharacters(in: .whitespaces)
        let elUsuario = usuario.trimmingCharacters(in: .whitespaces)

        if elNombre.isEmpty || elUsuario.isEmpty {
            mensaje = "Escribe tu nombre completo y un usuario."
            return
        }
        if existe(elUsuario) {
            mensaje = "El usuario \"\(elUsuario)\" ya está registrado. Elige otro."
            return
        }
        if clave.count < 6 {
            mensaje = "La clave debe tener mínimo 6 caracteres."
            return
        }
        if clave != confirmar {
            mensaje = "Las claves no coinciden."
            return
        }

        let nuevo = Usuario(nombre: elNombre, usuario: elUsuario, clave: clave, rol: rol)
        contexto.insert(nuevo)
        try? contexto.save()
        sesion.usuario = nuevo
    }
}
