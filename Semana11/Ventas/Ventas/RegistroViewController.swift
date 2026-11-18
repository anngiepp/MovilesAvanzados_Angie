import UIKit
import CoreData

// A2 · Crear cuenta
class RegistroViewController: UIViewController {

    let txtNombre = UITextField()
    let txtUsuario = UITextField()
    let txtClave = UITextField()
    let txtConfirmar = UITextField()
    let lblDisponible = crearLabel("", tamano: 13, peso: .medium)
    let segRol = UISegmentedControl(items: ["Vendedor", "Supervisor"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.title = "Crear cuenta"

        txtNombre.placeholder = "Ej. Lucía Paredes"
        txtNombre.autocapitalizationType = .words
        txtUsuario.placeholder = "Ej. lparedes"
        txtUsuario.addTarget(self, action: #selector(revisarUsuario), for: .editingChanged)
        txtClave.placeholder = "••••••"
        txtClave.isSecureTextEntry = true
        txtConfirmar.placeholder = "••••••"
        txtConfirmar.isSecureTextEntry = true
        segRol.selectedSegmentIndex = 0

        let lblRol = crearLabel("TU ROL", tamano: 12, peso: .medium, color: Paleta.textoSuave)
        let btnRegistrar = botonPrincipal("Registrarme")
        btnRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)
        let lblNota = crearLabel("Al registrarte entrarás directamente a la app con las pestañas de tu rol.", tamano: 13, color: Paleta.textoSuave)
        lblNota.textAlignment = .center

        let banner = BannerView(icono: "person.badge.plus")
        banner.lblTitulo.text = "Únete al equipo"
        banner.lblDetalle.text = "Elige tu rol: vendedor o supervisor"
        let cajaNombre = cajaCampo("NOMBRE COMPLETO", txtNombre)
        let cajaUsuario = cajaCampo("USUARIO", txtUsuario, extra: lblDisponible)
        let stack = UIStackView(arrangedSubviews: [banner, cajaNombre, cajaUsuario, cajaCampo("CLAVE (MÍNIMO 6 CARACTERES)", txtClave), cajaCampo("CONFIRMAR CLAVE", txtConfirmar), lblRol, segRol, btnRegistrar, lblNota])
        stack.axis = .vertical
        stack.spacing = 14
        stack.setCustomSpacing(6, after: lblRol)
        stack.setCustomSpacing(24, after: segRol)
        montarEnScroll(stack, arriba: 16)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func usuarioExiste(_ texto: String) -> Bool {
        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "usuario ==[c] %@", texto)
        let cantidad = (try? BD.contexto.count(for: req)) ?? 0
        return cantidad > 0
    }

    @objc func revisarUsuario() {
        let texto = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if texto.isEmpty {
            lblDisponible.text = ""
        } else if usuarioExiste(texto) {
            lblDisponible.text = "✕ Ya existe"
            lblDisponible.textColor = Paleta.rojo
        } else {
            lblDisponible.text = "✓ Disponible"
            lblDisponible.textColor = Paleta.azulFuerte
        }
    }

    @objc func registrar() {
        let nombre = txtNombre.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let usuario = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let clave = txtClave.text ?? ""
        let confirmar = txtConfirmar.text ?? ""

        if nombre.isEmpty || usuario.isEmpty {
            alerta("Faltan datos", "Escribe tu nombre completo y un usuario.")
            return
        }
        if usuarioExiste(usuario) {
            alerta("Usuario repetido", "El usuario \"\(usuario)\" ya está registrado. Elige otro.")
            return
        }
        if clave.count < 6 {
            alerta("Clave muy corta", "La clave debe tener mínimo 6 caracteres.")
            return
        }
        if clave != confirmar {
            alerta("Las claves no coinciden", "Escribe la misma clave en los dos campos.")
            return
        }

        let nuevo = Usuario(context: BD.contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = segRol.selectedSegmentIndex == 0 ? "Vendedor" : "Supervisor"

        if BD.guardar() {
            Sesion.shared.usuario = nuevo
            escena?.mostrarApp()
        } else {
            alerta("Error", "No se pudo crear la cuenta.")
        }
    }
}
