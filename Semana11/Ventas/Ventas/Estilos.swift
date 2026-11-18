import UIKit

// MARK: - Funciones de ayuda

func iniciales(_ texto: String?) -> String {
    let partes = (texto ?? "").split(separator: " ").prefix(2)
    return partes.compactMap { $0.first }.map { String($0) }.joined().uppercased()
}

func colorPara(_ texto: String?) -> UIColor {
    let colores: [UIColor] = [.systemBlue, .systemPurple, .systemTeal, .systemPink, .systemIndigo, .systemOrange, .systemGreen]
    let suma = (texto ?? "").unicodeScalars.reduce(0) { $0 + Int($1.value) }
    return colores[suma % colores.count]
}

func colorStock(_ stock: Int64) -> UIColor {
    if stock > 10 { return .systemGreen }
    if stock >= 6 { return .systemOrange }
    return .systemRed
}

func colorCategoria(_ categoria: String) -> UIColor {
    switch categoria {
    case "VIP": return .systemPurple
    case "Frecuente": return .systemBlue
    default: return .systemGray
    }
}

func crearLabel(_ texto: String = "", tamano: CGFloat = 15, peso: UIFont.Weight = .regular, color: UIColor = .label) -> UILabel {
    let label = UILabel()
    label.text = texto
    label.font = .systemFont(ofSize: tamano, weight: peso)
    label.textColor = color
    label.numberOfLines = 0
    return label
}

func botonPrincipal(_ titulo: String, color: UIColor = .systemBlue) -> UIButton {
    var config = UIButton.Configuration.filled()
    config.title = titulo
    config.baseBackgroundColor = color
    config.cornerStyle = .large
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
        var nuevo = atributos
        nuevo.font = .systemFont(ofSize: 17, weight: .semibold)
        return nuevo
    }
    let boton = UIButton(configuration: config)
    boton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return boton
}

// Caja blanca con un título pequeño arriba y el campo de texto abajo
func cajaCampo(_ titulo: String, _ campo: UITextField, extra: UIView? = nil) -> UIView {
    let caja = Tarjeta()
    let lblTitulo = crearLabel(titulo, tamano: 11, peso: .medium, color: .secondaryLabel)
    campo.font = .systemFont(ofSize: 17)
    campo.autocapitalizationType = .none
    campo.autocorrectionType = .no

    let fila = UIStackView(arrangedSubviews: [campo])
    fila.spacing = 8
    if let extra = extra {
        fila.addArrangedSubview(extra)
        extra.setContentHuggingPriority(.required, for: .horizontal)
    }

    let stack = UIStackView(arrangedSubviews: [lblTitulo, fila])
    stack.axis = .vertical
    stack.spacing = 4
    caja.agregar(stack, margen: 14)
    return caja
}

// MARK: - Vistas reutilizables

class Tarjeta: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 14
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
        layer.cornerRadius = tamano * 0.25
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: tamano).isActive = true
        heightAnchor.constraint(equalToConstant: tamano).isActive = true
    }

    required init?(coder: NSCoder) { fatalError() }

    func poner(_ texto: String, _ color: UIColor, colorTexto: UIColor = .white) {
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
                config.baseBackgroundColor = .systemBlue
                config.baseForegroundColor = .white
            } else {
                config.baseForegroundColor = .label
                config.background.backgroundColor = .secondarySystemGroupedBackground
                config.background.strokeColor = .systemGray4
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

// Celda usada en productos, clientes y ventas:
// [avatar] titulo / subtitulo ........ valor / detalle [etiqueta]
class FilaCell: UITableViewCell {
    let avatar = AvatarView(tamano: 40)
    let lblTitulo = crearLabel(tamano: 16, peso: .semibold)
    let lblSubtitulo = crearLabel(tamano: 13, color: .secondaryLabel)
    let lblValor = crearLabel(tamano: 15, peso: .bold)
    let lblDetalle = crearLabel(tamano: 11, color: .secondaryLabel)
    let etiqueta = EtiquetaView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lblTitulo.numberOfLines = 1
        lblSubtitulo.numberOfLines = 1
        lblValor.textAlignment = .right
        lblDetalle.textAlignment = .right

        let textos = UIStackView(arrangedSubviews: [lblTitulo, lblSubtitulo])
        textos.axis = .vertical
        textos.spacing = 2

        let valores = UIStackView(arrangedSubviews: [lblValor, lblDetalle])
        valores.axis = .vertical
        valores.alignment = .trailing
        valores.setContentHuggingPriority(.required, for: .horizontal)
        valores.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [avatar, textos, valores, etiqueta])
        fila.spacing = 12
        fila.alignment = .center
        fila.setCustomSpacing(8, after: valores)
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configurar(titulo: String?, subtitulo: String?, valor: String?, detalle: String? = nil, etiqueta texto: String? = nil, colorEtiqueta: UIColor = .systemGray, tachado: Bool = false) {
        if tachado {
            lblTitulo.attributedText = NSAttributedString(string: titulo ?? "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            lblTitulo.textColor = .secondaryLabel
            lblValor.textColor = .secondaryLabel
        } else {
            lblTitulo.attributedText = nil
            lblTitulo.text = titulo
            lblTitulo.textColor = .label
            lblValor.textColor = .label
        }
        lblSubtitulo.text = subtitulo
        lblValor.text = valor
        lblDetalle.text = detalle
        lblDetalle.isHidden = detalle == nil
        etiqueta.poner(texto, colorEtiqueta)
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
        let label = crearLabel(texto, tamano: 13, color: .secondaryLabel)
        label.frame = contenedor.bounds.insetBy(dx: 20, dy: 4)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contenedor.addSubview(label)
        return contenedor
    }
}

// Tarjeta con título pequeño, valor grande y detalle (Hoy, Mes, Vendido hoy...)
func tarjetaIndicador(_ titulo: String) -> (tarjeta: Tarjeta, valor: UILabel, detalle: UILabel) {
    let lblTitulo = crearLabel(titulo, tamano: 13, color: .secondaryLabel)
    let lblValor = crearLabel("S/ 0.00", tamano: 24, peso: .bold)
    lblValor.adjustsFontSizeToFitWidth = true
    lblValor.minimumScaleFactor = 0.6
    lblValor.numberOfLines = 1
    let lblDetalle = crearLabel("", tamano: 12, color: .secondaryLabel)
    let stack = UIStackView(arrangedSubviews: [lblTitulo, lblValor, lblDetalle])
    stack.axis = .vertical
    stack.spacing = 4
    let tarjeta = Tarjeta()
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
            avatar.poner(iniciales(venta.cliente?.nombre), venta.anulada ? .systemGray3 : colorPara(venta.cliente?.nombre))
        } else if venta.anulada {
            avatar.poner("✕", UIColor.systemRed.withAlphaComponent(0.2), colorTexto: .systemRed)
        } else {
            avatar.poner("✓", .systemGreen)
        }

        configurar(titulo: venta.cliente?.nombre,
                   subtitulo: subtitulo,
                   valor: soles(venta.total),
                   detalle: venta.anulada ? venta.motivoAnulacion : nil,
                   etiqueta: venta.anulada ? "Anulada" : nil,
                   colorEtiqueta: .systemRed,
                   tachado: venta.anulada)
        selectionStyle = .none
    }
}
