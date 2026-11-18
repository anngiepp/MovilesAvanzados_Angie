import UIKit

// Pestaña Cuenta: datos del usuario y cerrar sesión
class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.title = "Perfil"

        let usuario = Sesion.shared.usuario
        let avatar = AvatarView(tamano: 80)
        avatar.poner(iniciales(usuario?.nombre), Paleta.azul)

        let lblNombre = crearLabel(usuario?.nombre ?? "", tamano: 22, peso: .bold)
        let lblUsuario = crearLabel("@" + (usuario?.usuario ?? ""), tamano: 15, color: Paleta.textoSuave)
        let etiquetaRol = EtiquetaView()
        etiquetaRol.poner(usuario?.rol, Sesion.shared.esSupervisor ? Paleta.cafe : Paleta.azulFuerte)

        let datos = UIStackView(arrangedSubviews: [avatar, lblNombre, lblUsuario, etiquetaRol])
        datos.axis = .vertical
        datos.alignment = .center
        datos.spacing = 8
        datos.setCustomSpacing(14, after: avatar)
        let tarjeta = Tarjeta()
        tarjeta.agregar(datos, margen: 24)

        let btnSalir = botonPrincipal("Cerrar sesión", color: Paleta.rojo)
        let lblApp = crearLabel("Ventas Tecsup · v1.0", tamano: 12, color: Paleta.textoSuave)
        lblApp.textAlignment = .center
        btnSalir.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [tarjeta, btnSalir, lblApp])
        stack.axis = .vertical
        stack.spacing = 24
        montarEnScroll(stack, arriba: 16)
    }

    @objc func cerrarSesion() {
        Sesion.shared.usuario = nil
        escena?.mostrarLogin()
    }
}
