import SwiftUI
import SwiftData
import UIKit

@main
struct ComprasApp: App {
    @State private var sesion = Sesion()

    init() {
        // Títulos de las barras con letra con serifa y color café
        let barra = UINavigationBarAppearance()
        barra.configureWithTransparentBackground()
        barra.backgroundColor = UIColor(Paleta.fondo)
        let serif = UIFont.systemFont(ofSize: 34, weight: .heavy).fontDescriptor.withDesign(.serif)
        if let serif = serif {
            barra.largeTitleTextAttributes = [.font: UIFont(descriptor: serif, size: 34), .foregroundColor: UIColor(Paleta.cafe)]
        }
        barra.titleTextAttributes = [.foregroundColor: UIColor(Paleta.cafe)]
        UINavigationBar.appearance().standardAppearance = barra
        UINavigationBar.appearance().scrollEdgeAppearance = barra
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Paleta.cafe)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Paleta.fondo)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Paleta.cafe)], for: .normal)
    }

    var body: some Scene {
        WindowGroup {
            RaizView()
                .environment(sesion)
                .tint(Paleta.cafe)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self])
    }
}

// Si hay sesión muestra las pestañas; si no, el login
struct RaizView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    var body: some View {
        Group {
            if sesion.usuario != nil {
                PrincipalView()
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .task {
            DatosEjemplo.cargarSiHaceFalta(contexto)
        }
    }
}
