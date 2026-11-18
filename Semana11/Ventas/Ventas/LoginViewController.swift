import UIKit
import CoreData

// A1 · Login
class LoginViewController: UIViewController {

    let txtUsuario = UITextField()
    let txtClave = UITextField()
    let lblError = crearLabel("⚠︎ Usuario o clave incorrectos", tamano: 14, color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.backButtonTitle = "Ingresar"

        let logo = UIImageView(image: UIImage(systemName: "cart.fill"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        let fondoLogo = UIView()
        fondoLogo.backgroundColor = .systemBlue
        fondoLogo.layer.cornerRadius = 22
        logo.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.addSubview(logo)
        NSLayoutConstraint.activate([
            fondoLogo.widthAnchor.constraint(equalToConstant: 90),
            fondoLogo.heightAnchor.constraint(equalToConstant: 90),
            logo.centerXAnchor.constraint(equalTo: fondoLogo.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: fondoLogo.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 48),
            logo.heightAnchor.constraint(equalToConstant: 48)
        ])

        let lblTitulo = crearLabel("Ventas Tecsup", tamano: 28, peso: .bold)
        let lblSub = crearLabel("Inicia sesión para continuar", tamano: 15, color: .secondaryLabel)

        txtUsuario.placeholder = "Tu usuario"
        txtClave.placeholder = "Tu clave"
        txtClave.isSecureTextEntry = true
        lblError.isHidden = true

        let btnIngresar = botonPrincipal("Ingresar")
        btnIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let btnCrear = UIButton(type: .system)
        let texto = NSMutableAttributedString(string: "¿Primera vez? ", attributes: [.foregroundColor: UIColor.secondaryLabel])
        texto.append(NSAttributedString(string: "Crear cuenta", attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]))
        btnCrear.setAttributedTitle(texto, for: .normal)
        btnCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        let cabecera = UIStackView(arrangedSubviews: [fondoLogo, lblTitulo, lblSub])
        cabecera.axis = .vertical
        cabecera.alignment = .center
        cabecera.spacing = 10
        cabecera.setCustomSpacing(20, after: fondoLogo)

        let stack = UIStackView(arrangedSubviews: [cabecera, cajaCampo("USUARIO", txtUsuario), cajaCampo("CLAVE", txtClave), lblError, btnIngresar, btnCrear])
        stack.axis = .vertical
        stack.spacing = 14
        stack.setCustomSpacing(32, after: cabecera)
        montarEnScroll(stack, arriba: 60)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc func ingresar() {
        let usuario = txtUsuario.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let clave = txtClave.text ?? ""

        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "usuario ==[c] %@ AND clave == %@", usuario, clave)
        let encontrados = (try? BD.contexto.fetch(req)) ?? []

        // Mismo mensaje si falla el usuario o la clave
        guard let encontrado = encontrados.first else {
            lblError.isHidden = false
            return
        }
        lblError.isHidden = true
        txtClave.text = ""
        Sesion.shared.usuario = encontrado
        escena?.mostrarApp()
    }

    @objc func irARegistro() {
        lblError.isHidden = true
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
