import UIKit

// Pestaña Cuenta: datos del usuario y cerrar sesión
class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Cuenta"

        let usuario = Sesion.shared.usuario
        let avatar = AvatarView(tamano: 80)
        avatar.poner(iniciales(usuario?.nombre), colorPara(usuario?.nombre))

        let lblNombre = crearLabel(usuario?.nombre ?? "", tamano: 22, peso: .bold)
        let lblUsuario = crearLabel("@" + (usuario?.usuario ?? ""), tamano: 15, color: .secondaryLabel)
        let etiquetaRol = EtiquetaView()
        etiquetaRol.poner(usuario?.rol, Sesion.shared.esSupervisor ? .systemPurple : .systemBlue)

        let datos = UIStackView(arrangedSubviews: [avatar, lblNombre, lblUsuario, etiquetaRol])
        datos.axis = .vertical
        datos.alignment = .center
        datos.spacing = 8
        datos.setCustomSpacing(14, after: avatar)
        let tarjeta = Tarjeta()
        tarjeta.agregar(datos, margen: 24)

        let btnSalir = botonPrincipal("Cerrar sesión", color: .systemRed)
        btnSalir.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [tarjeta, btnSalir])
        stack.axis = .vertical
        stack.spacing = 24
        montarEnScroll(stack, arriba: 16)
    }

    @objc func cerrarSesion() {
        Sesion.shared.usuario = nil
        escena?.mostrarLogin()
    }
}
