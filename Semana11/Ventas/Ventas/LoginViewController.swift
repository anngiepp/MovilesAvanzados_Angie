import UIKit
import CoreData

// Dos medias lunas apiladas (café y celeste), como tazones vistos de lado
class TazonesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        let ancho = rect.width
        // Media luna celeste (atrás, más abajo)
        Paleta.azul.setFill()
        UIBezierPath(ovalIn: CGRect(x: -ancho * 0.45, y: -rect.height, width: ancho * 1.9, height: rect.height * 2)).fill()
        // Media luna café (adelante)
        Paleta.cafe.setFill()
        UIBezierPath(ovalIn: CGRect(x: -ancho * 0.5, y: -rect.height, width: ancho * 2, height: rect.height * 1.8)).fill()
    }
}

// A1 · Login
class LoginViewController: UIViewController {

    let txtUsuario = UITextField()
    let txtClave = UITextField()
    let lblError = crearLabel("✱ Usuario o clave incorrectos", tamano: 14, peso: .semibold, color: Paleta.rojo)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.backButtonTitle = "Ingresar"

        let tazones = TazonesView()
        tazones.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tazones)
        NSLayoutConstraint.activate([
            tazones.topAnchor.constraint(equalTo: view.topAnchor),
            tazones.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tazones.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tazones.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.42)
        ])

        // Marca sobre el café
        let lblAsterisco = crearLabel("✱", tamano: 40, peso: .bold, color: Paleta.azul)
        lblAsterisco.textAlignment = .right
        let lblMarca = crearLabel("Tienda Tecsup", tamano: 15, peso: .semibold, color: Paleta.azul)
        let lblTitulo = crearLabel("Ventas", color: Paleta.fondo)
        lblTitulo.font = fuenteSerif(52, .heavy)
        let lblSub = crearLabel("registra, vende y controla tu stock", tamano: 15, color: Paleta.arena)

        let marca = UIStackView(arrangedSubviews: [lblAsterisco, lblMarca, lblTitulo, lblSub])
        marca.axis = .vertical
        marca.spacing = 2
        marca.setCustomSpacing(0, after: lblAsterisco)

        // Formulario sin caja, con campos subrayados
        txtUsuario.placeholder = "Tu usuario"
        txtClave.placeholder = "Tu clave"
        txtClave.isSecureTextEntry = true
        lblError.isHidden = true

        let btnIngresar = botonPrincipal("Ingresar")
        btnIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let btnCrear = botonBorde("Crear una cuenta nueva")
        btnCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)

        let lblO = crearLabel("— o —", tamano: 13, color: Paleta.textoSuave)
        lblO.textAlignment = .center

        let espacio = UIView()
        espacio.heightAnchor.constraint(equalToConstant: 124).isActive = true

        let stack = UIStackView(arrangedSubviews: [marca, espacio, cajaCampo("USUARIO", txtUsuario), cajaCampo("CLAVE", txtClave), lblError, btnIngresar, lblO, btnCrear])
        stack.axis = .vertical
        stack.spacing = 22
        stack.setCustomSpacing(0, after: marca)
        stack.setCustomSpacing(12, after: btnIngresar)
        stack.setCustomSpacing(12, after: lblO)
        montarEnScroll(stack, arriba: 12)
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
