import UIKit

// MARK: - Paleta vintage (café, celeste y crema)

extension UIColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8) & 0xFF) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

enum Paleta {
    static let fondo = UIColor(hex: 0xFFF0DE)        // crema
    static let tarjeta = UIColor(hex: 0xFFF8EE)
    static let borde = UIColor(hex: 0xEBD9C4)
    static let cafe = UIColor(hex: 0x694A47)         // café vintage
    static let cafeOscuro = UIColor(hex: 0x4B3432)
    static let azul = UIColor(hex: 0x96C1C5)         // celeste pastel
    static let azulFuerte = UIColor(hex: 0x5F9298)
    static let arena = UIColor(hex: 0xEBCFB2)
    static let latte = UIColor(hex: 0xD8BFA9)
    static let salvia = UIColor(hex: 0xC9D7CB)
    static let rosa = UIColor(hex: 0xE8C4BD)
    static let ambar = UIColor(hex: 0xD6A25A)
    static let rojo = UIColor(hex: 0xC2665D)
    static let texto = UIColor(hex: 0x4B3432)
    static let textoSuave = UIColor(hex: 0x9A7F7B)
}

// Letra con serifa para títulos (estilo vintage)
func fuenteSerif(_ tamano: CGFloat, _ peso: UIFont.Weight = .bold) -> UIFont {
    let base = UIFont.systemFont(ofSize: tamano, weight: peso)
    guard let descriptor = base.fontDescriptor.withDesign(.serif) else { return base }
    return UIFont(descriptor: descriptor, size: tamano)
}

// MARK: - Funciones de ayuda

func iniciales(_ texto: String?) -> String {
    let partes = (texto ?? "").split(separator: " ").prefix(2)
    return partes.compactMap { $0.first }.map { String($0) }.joined().uppercased()
}

func colorPara(_ texto: String?) -> UIColor {
    let colores: [UIColor] = [Paleta.azul, Paleta.arena, Paleta.salvia, Paleta.rosa, Paleta.latte]
    let suma = (texto ?? "").unicodeScalars.reduce(0) { $0 + Int($1.value) }
    return colores[suma % colores.count]
}

func colorStock(_ stock: Int64) -> UIColor {
    if stock > 10 { return Paleta.azulFuerte }
    if stock >= 6 { return Paleta.ambar }
    return Paleta.rojo
}

func colorCategoria(_ categoria: String) -> UIColor {
    switch categoria {
    case "VIP": return Paleta.cafe
    case "Frecuente": return Paleta.azulFuerte
    default: return Paleta.textoSuave
    }
}

func crearLabel(_ texto: String = "", tamano: CGFloat = 15, peso: UIFont.Weight = .regular, color: UIColor = Paleta.texto) -> UILabel {
    let label = UILabel()
    label.text = texto
    label.font = .systemFont(ofSize: tamano, weight: peso)
    label.textColor = color
    label.numberOfLines = 0
    return label
}

func botonPrincipal(_ titulo: String, color: UIColor = Paleta.cafe) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = titulo
    config.baseBackgroundColor = color
    config.baseForegroundColor = Paleta.fondo
    config.cornerStyle = .fixed
    config.background.cornerRadius = 14
    config.image = UIImage(systemName: "arrow.right.circle.fill")
    config.imagePlacement = .trailing
    config.imagePadding = 10
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
        var nuevo = atributos
        nuevo.font = fuenteSerif(18)
        return nuevo
    }
    let boton = UIButton(configuration: config)
    boton.heightAnchor.constraint(equalToConstant: 54).isActive = true
    return boton
}

// Botón de borde (secundario)
func botonBorde(_ titulo: String) -> UIButton {
    var config = UIButton.Configuration.bordered()
    config.title = titulo
    config.baseForegroundColor = Paleta.cafe
    config.background.backgroundColor = .clear
    config.background.strokeColor = Paleta.cafe
    config.background.strokeWidth = 1.5
    config.background.cornerRadius = 14
    let boton = UIButton(configuration: config)
    boton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    return boton
}

// Campo con título pequeño y una línea abajo (sin caja)
func cajaCampo(_ titulo: String, _ campo: UITextField, extra: UIView? = nil) -> UIView {
    let lblTitulo = crearLabel(titulo, tamano: 11, peso: .bold, color: Paleta.azulFuerte)
    campo.font = .systemFont(ofSize: 18)
    campo.textColor = Paleta.texto
    campo.tintColor = Paleta.cafe
    campo.autocapitalizationType = .none
    campo.autocorrectionType = .no

    let fila = UIStackView(arrangedSubviews: [campo])
    fila.spacing = 8
    if let extra = extra {
        fila.addArrangedSubview(extra)
        extra.setContentHuggingPriority(.required, for: .horizontal)
    }

    let linea = UIView()
    linea.backgroundColor = Paleta.cafe.withAlphaComponent(0.35)
    linea.heightAnchor.constraint(equalToConstant: 1.5).isActive = true

    let stack = UIStackView(arrangedSubviews: [lblTitulo, fila, linea])
    stack.axis = .vertical
    stack.spacing = 6
    return stack
}

// MARK: - Vistas reutilizables

class Tarjeta: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Paleta.tarjeta
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = Paleta.borde.cgColor
    }

    required init?(coder: NSCoder) { fatalError() }

    func agregar(_ vista: UIView, margen: CGFloat = 16) {
        vista.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vista)
        NSLayoutConstraint.activate([
            vista.topAnchor.constraint(equalTo: topAnchor, constant: margen - 2),
            vista.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(margen - 2)),
            vista.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margen),
            vista.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margen)
        ])
    }
}

// Etiqueta de color tipo "VIP", "40 u.", "Anulada"
class EtiquetaView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 12, weight: .semibold)
        textColor = .white
        textAlignment = .center
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError() }

    func poner(_ texto: String?, _ color: UIColor) {
        text = texto
        backgroundColor = color
        isHidden = texto == nil
    }

    override var intrinsicContentSize: CGSize {
        let tam = super.intrinsicContentSize
        return CGSize(width: tam.width + 16, height: 20)
    }
}

// Cuadrado redondeado con las iniciales
class AvatarView: UILabel {
    init(tamano: CGFloat = 40) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: tamano * 0.38, weight: .bold)
        textColor = .white
        textAlignment = .center
        layer.cornerRadius = tamano / 2
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: tamano).isActive = true
        heightAnchor.constraint(equalToConstant: tamano).isActive = true
    }

    required init?(coder: NSCoder) { fatalError() }

    func poner(_ texto: String, _ color: UIColor, colorTexto: UIColor = Paleta.cafeOscuro) {
        text = texto
        backgroundColor = color
        textColor = colorTexto
    }
}

// Fila de botones tipo "chip" que se puede deslizar de lado
class ChipsView: UIScrollView {
    var seleccionado = 0
    var alSeleccionar: ((Int) -> Void)?
    private let stack = UIStackView()
    private var botones: [UIButton] = []
    private var textos: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            stack.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func ponerOpciones(_ opciones: [String]) {
        botones.forEach { $0.removeFromSuperview() }
        botones = []
        textos = opciones
        for (i, _) in opciones.enumerated() {
            let boton = UIButton(type: .system)
            boton.tag = i
            boton.addTarget(self, action: #selector(tocar(_:)), for: .touchUpInside)
            stack.addArrangedSubview(boton)
            botones.append(boton)
        }
        if seleccionado >= opciones.count { seleccionado = 0 }
        pintar()
    }

    @objc func tocar(_ boton: UIButton) {
        seleccionado = boton.tag
        pintar()
        alSeleccionar?(boton.tag)
    }

    private func pintar() {
        for boton in botones {
            let activo = boton.tag == seleccionado
            var config = activo ? UIButton.Configuration.filled() : UIButton.Configuration.plain()
            config.title = textos[boton.tag]
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
            if activo {
                config.baseBackgroundColor = Paleta.cafe
                config.baseForegroundColor = Paleta.fondo
            } else {
                config.baseForegroundColor = Paleta.cafe
                config.background.backgroundColor = Paleta.tarjeta
                config.background.strokeColor = Paleta.borde
                config.background.strokeWidth = 1
            }
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
                var nuevo = atributos
                nuevo.font = .systemFont(ofSize: 14, weight: .medium)
                return nuevo
            }
            boton.configuration = config
        }
    }
}

// Celda tipo tarjeta usada en productos, clientes y ventas:
// |franja| [avatar] titulo / subtitulo ........ valor / detalle [etiqueta]
class FilaCell: UITableViewCell {
    let carta = Tarjeta()
    let franja = UIView()
    let avatar = AvatarView(tamano: 42)
    let lblTitulo = crearLabel(tamano: 16, peso: .semibold)
    let lblSubtitulo = crearLabel(tamano: 13, color: Paleta.textoSuave)
    let lblValor = crearLabel(tamano: 16, peso: .bold)
    let lblDetalle = crearLabel(tamano: 11, color: Paleta.textoSuave)
    let etiqueta = EtiquetaView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        lblTitulo.numberOfLines = 1
        lblSubtitulo.numberOfLines = 1
        lblValor.textAlignment = .right
        lblValor.font = fuenteSerif(16)
        lblDetalle.textAlignment = .right

        let textos = UIStackView(arrangedSubviews: [lblTitulo, lblSubtitulo])
        textos.axis = .vertical
        textos.spacing = 3

        let valores = UIStackView(arrangedSubviews: [lblValor, lblDetalle, etiqueta])
        valores.axis = .vertical
        valores.alignment = .trailing
        valores.spacing = 4
        valores.setContentHuggingPriority(.required, for: .horizontal)
        valores.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [avatar, textos, valores])
        fila.spacing = 12
        fila.alignment = .center

        carta.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carta)
        franja.translatesAutoresizingMaskIntoConstraints = false
        carta.addSubview(franja)
        carta.clipsToBounds = true
        fila.translatesAutoresizingMaskIntoConstraints = false
        carta.addSubview(fila)

        NSLayoutConstraint.activate([
            carta.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            carta.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            carta.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            carta.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            franja.topAnchor.constraint(equalTo: carta.topAnchor),
            franja.bottomAnchor.constraint(equalTo: carta.bottomAnchor),
            franja.leadingAnchor.constraint(equalTo: carta.leadingAnchor),
            franja.widthAnchor.constraint(equalToConstant: 7),
            fila.topAnchor.constraint(equalTo: carta.topAnchor, constant: 12),
            fila.bottomAnchor.constraint(equalTo: carta.bottomAnchor, constant: -12),
            fila.leadingAnchor.constraint(equalTo: franja.trailingAnchor, constant: 12),
            fila.trailingAnchor.constraint(equalTo: carta.trailingAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configurar(titulo: String?, subtitulo: String?, valor: String?, detalle: String? = nil, etiqueta texto: String? = nil, colorEtiqueta: UIColor = Paleta.textoSuave, tachado: Bool = false) {
        if tachado {
            lblTitulo.attributedText = NSAttributedString(string: titulo ?? "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            lblTitulo.textColor = Paleta.textoSuave
            lblValor.textColor = Paleta.textoSuave
        } else {
            lblTitulo.attributedText = nil
            lblTitulo.text = titulo
            lblTitulo.textColor = Paleta.texto
            lblValor.textColor = Paleta.cafe
        }
        lblSubtitulo.text = subtitulo
        lblValor.text = valor
        lblDetalle.text = detalle
        lblDetalle.isHidden = detalle == nil
        etiqueta.poner(texto, colorEtiqueta)
        // La franja toma el color de la etiqueta (stock, categoría o anulada)
        franja.backgroundColor = texto == nil ? Paleta.azul : colorEtiqueta
    }
}

// MARK: - Ayudas para las pantallas

extension UIViewController {
    var escena: SceneDelegate? {
        view.window?.windowScene?.delegate as? SceneDelegate
    }

    func alerta(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    // Pone un stack vertical dentro de un scroll (para formularios y paneles)
    func montarEnScroll(_ stack: UIStackView, arriba: CGFloat = 24) {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: arriba),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    // Texto gris pequeño que va debajo de una tabla
    func notaPie(_ texto: String) -> UIView {
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        let label = crearLabel(texto, tamano: 13, color: Paleta.textoSuave)
        label.frame = contenedor.bounds.insetBy(dx: 20, dy: 4)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contenedor.addSubview(label)
        return contenedor
    }
}

// Tarjeta con título pequeño, valor grande y detalle (Hoy, Mes, Vendido hoy...)
func tarjetaIndicador(_ titulo: String, fondo: UIColor = Paleta.tarjeta, oscura: Bool = false) -> (tarjeta: Tarjeta, valor: UILabel, detalle: UILabel) {
    let colorTexto = oscura ? Paleta.fondo : Paleta.texto
    let lblTitulo = crearLabel(titulo.uppercased(), tamano: 11, peso: .semibold, color: oscura ? Paleta.azul : Paleta.cafe)
    let lblValor = crearLabel("S/ 0.00", tamano: 24, peso: .bold, color: colorTexto)
    lblValor.font = fuenteSerif(24)
    lblValor.adjustsFontSizeToFitWidth = true
    lblValor.minimumScaleFactor = 0.6
    lblValor.numberOfLines = 1
    let lblDetalle = crearLabel("", tamano: 12, color: oscura ? Paleta.latte : Paleta.textoSuave)
    let stack = UIStackView(arrangedSubviews: [lblTitulo, lblValor, lblDetalle])
    stack.axis = .vertical
    stack.spacing = 4
    let tarjeta = Tarjeta()
    tarjeta.backgroundColor = fondo
    if fondo != Paleta.tarjeta { tarjeta.layer.borderWidth = 0 }
    tarjeta.agregar(stack, margen: 14)
    return (tarjeta, lblValor, lblDetalle)
}

extension FilaCell {
    // Fila de una venta. Las anuladas salen tachadas y con etiqueta
    func mostrarVenta(_ venta: Venta, conVendedor: Bool) {
        let detalle = "\(venta.producto?.nombre ?? "") × \(venta.cantidad)"
        let subtitulo = conVendedor
            ? "\(primerNombre(venta.vendedor?.nombre)) · \(detalle)"
            : "\(textoFecha(venta.fecha)) · \(detalle)"

        if conVendedor {
            avatar.poner(iniciales(venta.cliente?.nombre), venta.anulada ? Paleta.borde : colorPara(venta.cliente?.nombre))
        } else if venta.anulada {
            avatar.poner("✕", Paleta.rosa, colorTexto: Paleta.rojo)
        } else {
            avatar.poner("✓", Paleta.azul, colorTexto: Paleta.azulFuerte)
        }

        configurar(titulo: venta.cliente?.nombre,
                   subtitulo: subtitulo,
                   valor: soles(venta.total),
                   detalle: venta.anulada ? venta.motivoAnulacion : nil,
                   etiqueta: venta.anulada ? "Anulada" : nil,
                   colorEtiqueta: Paleta.rojo,
                   tachado: venta.anulada)
        selectionStyle = .none
    }
}


// Banner de color con ícono y dos líneas (va arriba de las listas)
class BannerView: Tarjeta {
    let lblTitulo = crearLabel(tamano: 17, peso: .bold)
    let lblDetalle = crearLabel(tamano: 13, color: Paleta.cafe)

    init(icono: String, fondo: UIColor = Paleta.azul) {
        super.init(frame: .zero)
        lblTitulo.font = fuenteSerif(19)
        backgroundColor = fondo
        layer.borderWidth = 0

        let imagen = UIImageView(image: UIImage(systemName: icono))
        imagen.tintColor = Paleta.cafe
        imagen.contentMode = .scaleAspectFit
        let circulo = UIView()
        circulo.backgroundColor = Paleta.tarjeta.withAlphaComponent(0.7)
        circulo.layer.cornerRadius = 22
        imagen.translatesAutoresizingMaskIntoConstraints = false
        circulo.translatesAutoresizingMaskIntoConstraints = false
        circulo.addSubview(imagen)
        NSLayoutConstraint.activate([
            circulo.widthAnchor.constraint(equalToConstant: 44),
            circulo.heightAnchor.constraint(equalToConstant: 44),
            imagen.centerXAnchor.constraint(equalTo: circulo.centerXAnchor),
            imagen.centerYAnchor.constraint(equalTo: circulo.centerYAnchor),
            imagen.widthAnchor.constraint(equalToConstant: 22),
            imagen.heightAnchor.constraint(equalToConstant: 22)
        ])

        let textos = UIStackView(arrangedSubviews: [lblTitulo, lblDetalle])
        textos.axis = .vertical
        textos.spacing = 2
        let fila = UIStackView(arrangedSubviews: [circulo, textos])
        fila.spacing = 12
        fila.alignment = .center
        agregar(fila, margen: 14)
    }

    required init?(coder: NSCoder) { fatalError() }
}

// Cabecera de lista: banner arriba y (opcional) chips abajo, con tamaño fijo
func cabeceraLista(banner: BannerView, chips: ChipsView?, ancho: CGFloat) -> UIView {
    let alto: CGFloat = chips == nil ? 92 : 140
    let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: ancho, height: alto))
    banner.frame = CGRect(x: 16, y: 8, width: ancho - 32, height: 72)
    banner.autoresizingMask = [.flexibleWidth]
    contenedor.addSubview(banner)
    if let chips = chips {
        chips.frame = CGRect(x: 0, y: 92, width: ancho, height: 36)
        chips.autoresizingMask = [.flexibleWidth]
        contenedor.addSubview(chips)
    }
    return contenedor
}

// Colores generales de la app: barras, pestañas y modo claro
func aplicarApariencia(_ window: UIWindow) {
    window.overrideUserInterfaceStyle = .light
    window.tintColor = Paleta.cafe

    let barra = UINavigationBarAppearance()
    barra.configureWithOpaqueBackground()
    barra.backgroundColor = Paleta.fondo
    barra.shadowColor = .clear
    barra.titleTextAttributes = [.foregroundColor: Paleta.cafe, .font: fuenteSerif(17)]
    barra.largeTitleTextAttributes = [.foregroundColor: Paleta.cafe, .font: fuenteSerif(34, .heavy)]
    UINavigationBar.appearance().standardAppearance = barra
    UINavigationBar.appearance().scrollEdgeAppearance = barra
    UINavigationBar.appearance().compactAppearance = barra

    let pestanas = UITabBarAppearance()
    pestanas.configureWithOpaqueBackground()
    pestanas.backgroundColor = Paleta.tarjeta
    pestanas.shadowColor = Paleta.borde
    for item in [pestanas.stackedLayoutAppearance, pestanas.inlineLayoutAppearance, pestanas.compactInlineLayoutAppearance] {
        item.selected.iconColor = Paleta.cafe
        item.selected.titleTextAttributes = [.foregroundColor: Paleta.cafe]
        item.normal.iconColor = Paleta.azulFuerte
        item.normal.titleTextAttributes = [.foregroundColor: Paleta.textoSuave]
    }
    UITabBar.appearance().standardAppearance = pestanas
    UITabBar.appearance().scrollEdgeAppearance = pestanas

    UISegmentedControl.appearance().selectedSegmentTintColor = Paleta.cafe
    UISegmentedControl.appearance().backgroundColor = Paleta.borde.withAlphaComponent(0.6)
    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Paleta.fondo], for: .selected)
    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Paleta.cafe], for: .normal)

    UITableView.appearance().backgroundColor = Paleta.fondo
    UIProgressView.appearance().progressTintColor = Paleta.azulFuerte
    UIProgressView.appearance().trackTintColor = Paleta.borde
}
