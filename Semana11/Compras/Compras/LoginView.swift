import SwiftUI
import SwiftData

// B1 · Login
struct LoginView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @State private var usuario = ""
    @State private var clave = ""
    @State private var error = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("✱")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(Paleta.azul)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Distribuidora Tecsup").font(.subheadline.bold()).foregroundStyle(Paleta.azul)
                    Text("Compras").font(.serif(52, .heavy)).foregroundStyle(Paleta.fondo)
                    Text("proveedores, costos y cuentas por pagar").font(.subheadline).foregroundStyle(Paleta.arena)
                }
                .padding(.bottom, 120)

                CampoSubrayado(titulo: "USUARIO", texto: $usuario, placeholder: "Tu usuario")
                CampoSubrayado(titulo: "CLAVE", texto: $clave, placeholder: "Tu clave", seguro: true)

                if error {
                    Label("Usuario o clave incorrectos", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(Paleta.rojo)
                }

                Button("Ingresar", action: ingresar)
                    .buttonStyle(BotonPrincipal())

                Text("— o —")
                    .font(.footnote)
                    .foregroundStyle(Paleta.textoSuave)
                    .frame(maxWidth: .infinity)

                NavigationLink("Crear una cuenta nueva") {
                    RegistroView()
                }
                .buttonStyle(BotonBorde())
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(alignment: .top) {
            Tazones().frame(height: 330).ignoresSafeArea()
        }
        .background(Paleta.fondo)
        .toolbar(.hidden, for: .navigationBar)
    }

    func ingresar() {
        // El usuario se guarda en minúsculas, así no importan las mayúsculas
        let texto = usuario.trimmingCharacters(in: .whitespaces).lowercased()
        let laClave = clave
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == texto && $0.clave == laClave })

        // Mismo mensaje si falla el usuario o la clave
        if let encontrado = try? contexto.fetch(descriptor).first {
            error = false
            sesion.usuario = encontrado
        } else {
            error = true
        }
    }
}
