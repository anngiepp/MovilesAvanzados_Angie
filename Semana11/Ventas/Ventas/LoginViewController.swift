import UIKit
import CoreData

// A1 · Login
// Cabecera café con el logo y una tarjeta con el formulario encima
class LoginViewController: UIViewController {

    let txtUsuario = UITextField()
    let txtClave = UITextField()
    let lblError = crearLabel("⚠︎ Usuario o clave incorrectos", tamano: 14, peso: .medium, color: Paleta.rojo)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.backButtonTitle = "Ingresar"

        // Fondo café arriba con las esquinas de abajo redondeadas
        let cabecera = UIView()
        cabecera.backgroundColor = Paleta.cafe
        cabecera.layer.cornerRadius = 40
        cabecera.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cabecera.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cabecera)
        NSLayoutConstraint.activate([
            cabecera.topAnchor.constraint(equalTo: view.topAnchor),
            cabecera.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cabecera.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cabecera.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.42)
        ])

        let logo = UIImageView(image: UIImage(systemName: "bag.fill"))
        logo.tintColor = Paleta.cafe
        logo.contentMode = .scaleAspectFit
        let fondoLogo = UIView()
        fondoLogo.backgroundColor = Paleta.menta
        fondoLogo.layer.cornerRadius = 40
        logo.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.translatesAutoresizingMaskIntoConstraints = false
        fondoLogo.addSubview(logo)
        NSLayoutConstraint.activate([
            fondoLogo.widthAnchor.constraint(equalToConstant: 80),
            fondoLogo.heightAnchor.constraint(equalToConstant: 80),
            logo.centerXAnchor.constraint(equalTo: fondoLogo.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: fondoLogo.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 38),
            logo.heightAnchor.constraint(equalToConstant: 38)
        ])

        let lblTitulo = crearLabel("Ventas Tecsup", tamano: 30, peso: .heavy, color: Paleta.fondo)
        let lblSub = crearLabel("Hola de nuevo, inicia sesión para continuar", tamano: 15, color: Paleta.menta)
        lblSub.textAlignment = .center

        let marca = UIStackView(arrangedSubviews: [fondoLogo, lblTitulo, lblSub])
        marca.axis = .vertical
        marca.alignment = .center
        marca.spacing = 8
        marca.setCustomSpacing(16, after: fondoLogo)

        // Formulario dentro de una tarjeta
        txtUsuario.placeholder = "Tu usuario"
        txtClave.placeholder = "Tu clave"
        txtClave.isSecureTextEntry = true
        lblError.isHidden = true

        let btnIngresar = botonPrincipal("Ingresar")
        btnIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let lblForm = crearLabel("Iniciar sesión", tamano: 20, peso: .bold)
        let formulario = UIStackView(arrangedSubviews: [lblForm, cajaCampo("USUARIO", txtUsuario), cajaCampo("CLAVE", txtClave), lblError, btnIngresar])
        formulario.axis = .vertical
        formulario.spacing = 12
        formulario.setCustomSpacing(18, after: lblError)
        let tarjeta = Tarjeta()
        tarjeta.agregar(formulario, margen: 18)
        for caja in formulario.arrangedSubviews where caja is Tarjeta {
            caja.backgroundColor = Paleta.fondo
            caja.layer.shadowOpacity = 0
        }

        let btnCrear = UIButton(type: .system)
        let texto = NSMutableAttributedString(string: "¿Primera vez? ", attributes: [.foregroundColor: Paleta.textoSuave])
        texto.append(NSAttributedString(string: "Crear cuenta", attributes: [.foregroundColor: Paleta.mentaFuerte, .font: UIFont.systemFont(ofSize: 15, weight: .bold)]))
        btnCrear.setAttributedTitle(texto, for: .normal)
        btnCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [marca, tarjeta, btnCrear])
        stack.axis = .vertical
        stack.spacing = 28
        stack.setCustomSpacing(18, after: tarjeta)
        montarEnScroll(stack, arriba: 36)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

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
