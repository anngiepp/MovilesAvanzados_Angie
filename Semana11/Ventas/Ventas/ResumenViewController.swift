import UIKit
import CoreData

// A9 · Resumen del supervisor
class ResumenViewController: UIViewController {

    let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.title = "Resumen"
        stack.axis = .vertical
        stack.spacing = 14
        montarEnScroll(stack, arriba: 8)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        armarPanel()
    }

    // Se vuelve a armar cada vez que se abre la pestaña
    func armarPanel() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stack.addArrangedSubview(saludo())
        stack.addArrangedSubview(indicadores())
        stack.addArrangedSubview(grafico())
        stack.addArrangedSubview(ranking())
        stack.addArrangedSubview(stockBajo())
        stack.addArrangedSubview(cierre())
    }

    func saludo() -> UIView {
        let usuario = Sesion.shared.usuario
        let fecha = textoFecha(Date(), "EEEE d 'de' MMMM")
        let lblFecha = crearLabel(fecha.prefix(1).uppercased() + fecha.dropFirst(), tamano: 14, color: Paleta.textoSuave)
        let lblHola = crearLabel("Hola, \(primerNombre(usuario?.nombre))", tamano: 28, peso: .bold)
        let etiqueta = EtiquetaView()
        etiqueta.poner(usuario?.rol, Paleta.mentaFuerte)
        let fila = UIStackView(arrangedSubviews: [lblHola, etiqueta])
        fila.alignment = .center
        let vista = UIStackView(arrangedSubviews: [lblFecha, fila])
        vista.axis = .vertical
        vista.spacing = 2
        return vista
    }

    func indicadores() -> UIView {
        let hoy = inicioDelDia()
        let manana = Calendar.current.date(byAdding: .day, value: 1, to: hoy)!
        let ayer = Calendar.current.date(byAdding: .day, value: -1, to: hoy)!

        let vendidoHoy = sumaTotal(ventasValidas(desde: hoy, hasta: manana))
        let vendidoAyer = sumaTotal(ventasValidas(desde: ayer, hasta: hoy))
        let igvMes = ventasValidas(desde: inicioDelMes(), hasta: manana).reduce(0) { $0 + $1.igv }

        let ventasHoy = ventasValidas(desde: hoy, hasta: manana).count

        // Tarjeta principal café a todo lo ancho
        let tarjetaHoy = tarjetaIndicador("Vendido hoy", fondo: Paleta.cafe, oscura: true)
        tarjetaHoy.valor.font = .systemFont(ofSize: 34, weight: .heavy)
        tarjetaHoy.valor.text = soles(vendidoHoy)
        if vendidoAyer > 0 {
            let cambio = (vendidoHoy - vendidoAyer) / vendidoAyer * 100
            tarjetaHoy.detalle.text = String(format: "%@ %.0f%% vs ayer", cambio >= 0 ? "▲" : "▼", abs(cambio))
            tarjetaHoy.detalle.textColor = cambio >= 0 ? Paleta.menta : Paleta.rosa
        } else {
            tarjetaHoy.detalle.text = "Ayer no hubo ventas"
        }

        let tarjetaIGV = tarjetaIndicador("IGV del mes", fondo: Paleta.menta)
        tarjetaIGV.valor.text = soles(igvMes)
        tarjetaIGV.detalle.text = "Ventas no anuladas"

        let tarjetaCantidad = tarjetaIndicador("Ventas hoy", fondo: Paleta.durazno)
        tarjetaCantidad.valor.text = "\(ventasHoy)"
        tarjetaCantidad.detalle.text = "Sin contar anuladas"

        let fila = UIStackView(arrangedSubviews: [tarjetaIGV.tarjeta, tarjetaCantidad.tarjeta])
        fila.spacing = 12
        fila.distribution = .fillEqually

        let bloque = UIStackView(arrangedSubviews: [tarjetaHoy.tarjeta, fila])
        bloque.axis = .vertical
        bloque.spacing = 12
        return bloque
    }

    // Barras de los últimos 7 días (hoy es la última, en café)
    func grafico() -> UIView {
        let letras = ["D", "L", "M", "X", "J", "V", "S"]
        var valores: [Double] = []
        var etiquetas: [String] = []
        for i in (0..<7).reversed() {
            let dia = Calendar.current.date(byAdding: .day, value: -i, to: inicioDelDia())!
            let siguiente = Calendar.current.date(byAdding: .day, value: 1, to: dia)!
            valores.append(sumaTotal(ventasValidas(desde: dia, hasta: siguiente)))
            etiquetas.append(letras[Calendar.current.component(.weekday, from: dia) - 1])
        }

        let barras = BarrasView()
        barras.valores = valores
        barras.etiquetas = etiquetas
        barras.heightAnchor.constraint(equalToConstant: 130).isActive = true

        let contenido = UIStackView(arrangedSubviews: [crearLabel("Ventas de los últimos 7 días (S/)", tamano: 14, color: Paleta.textoSuave), barras])
        contenido.axis = .vertical
        contenido.spacing = 12
        let tarjeta = Tarjeta()
        tarjeta.agregar(contenido)
        return tarjeta
    }

    // Ranking de vendedores del mes usando la relación venta ▸ vendedor
    func ranking() -> UIView {
        let manana = Calendar.current.date(byAdding: .day, value: 1, to: inicioDelDia())!
        let ventasMes = ventasValidas(desde: inicioDelMes(), hasta: manana)

        var totales: [String: Double] = [:]
        for venta in ventasMes {
            let nombre = venta.vendedor?.nombre ?? "Sin vendedor"
            totales[nombre, default: 0] += venta.total
        }
        let ordenado = totales.sorted { $0.value > $1.value }
        let maximo = ordenado.first?.value ?? 1

        let contenido = UIStackView(arrangedSubviews: [crearLabel("Ranking de vendedores (mes)", tamano: 14, color: Paleta.textoSuave)])
        contenido.axis = .vertical
        contenido.spacing = 10

        if ordenado.isEmpty {
            contenido.addArrangedSubview(crearLabel("Todavía no hay ventas este mes.", tamano: 15))
        }
        for (nombre, total) in ordenado {
            let texto = NSMutableAttributedString(string: nombre, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .semibold)])
            texto.append(NSAttributedString(string: " · \(soles(total))", attributes: [.foregroundColor: Paleta.textoSuave]))
            let lbl = crearLabel(tamano: 15)
            lbl.attributedText = texto
            let barra = UIProgressView(progressViewStyle: .default)
            barra.progress = Float(total / maximo)
            barra.transform = CGAffineTransform(scaleX: 1, y: 2)
            contenido.addArrangedSubview(lbl)
            contenido.addArrangedSubview(barra)
            contenido.setCustomSpacing(6, after: lbl)
        }

        let tarjeta = Tarjeta()
        tarjeta.agregar(contenido)
        return tarjeta
    }

    func stockBajo() -> UIView {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        req.predicate = NSPredicate(format: "stock <= 5")
        req.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        let productos = (try? BD.contexto.fetch(req)) ?? []

        let contenido = UIStackView(arrangedSubviews: [crearLabel("Stock bajo (≤ 5)", tamano: 14, color: Paleta.textoSuave)])
        contenido.axis = .vertical
        contenido.spacing = 8

        if productos.isEmpty {
            contenido.addArrangedSubview(crearLabel("Todo el stock está bien.", tamano: 15))
        }
        for producto in productos {
            let lbl = crearLabel("\(producto.nombre ?? "") · \(producto.stock) u.", tamano: 16, peso: .semibold)
            let etiqueta = EtiquetaView()
            etiqueta.poner("Reponer", Paleta.rojo)
            let fila = UIStackView(arrangedSubviews: [lbl, etiqueta])
            fila.alignment = .center
            fila.spacing = 8
            contenido.addArrangedSubview(fila)
        }

        let tarjeta = Tarjeta()
        tarjeta.agregar(contenido)
        return tarjeta
    }
}

extension ResumenViewController {

    // Cierre de IGV del mes: IGV de ventas − crédito fiscal (dato del grupo B)
    func cierre() -> UIView {
        let manana = Calendar.current.date(byAdding: .day, value: 1, to: inicioDelDia())!
        let igvVentas = ventasValidas(desde: inicioDelMes(), hasta: manana).reduce(0) { $0 + $1.igv }
        let credito = creditoFiscalGuardado
        let resultado = cierreIGV(igvVentas: igvVentas, creditoFiscal: credito)

        let contenido = UIStackView(arrangedSubviews: [crearLabel("Cierre de IGV del mes", tamano: 14, color: Paleta.textoSuave)])
        contenido.axis = .vertical
        contenido.spacing = 8
        contenido.addArrangedSubview(filaCierre("IGV de ventas", soles(igvVentas)))
        contenido.addArrangedSubview(filaCierre("Crédito fiscal (compras, grupo B)", "− " + soles(credito)))

        let titulo = resultado.saldoAFavor ? "Saldo a favor" : "IGV por pagar"
        let filaTotal = filaCierre(titulo, soles(resultado.monto), negrita: true)
        let cajaTotal = Tarjeta()
        cajaTotal.backgroundColor = resultado.saldoAFavor ? Paleta.menta : Paleta.durazno
        cajaTotal.layer.borderWidth = 0
        cajaTotal.layer.shadowOpacity = 0
        cajaTotal.agregar(filaTotal, margen: 12)
        contenido.addArrangedSubview(cajaTotal)

        let btnCredito = UIButton(type: .system)
        btnCredito.setTitle(credito == 0 ? "Ingresar crédito fiscal" : "Cambiar crédito fiscal", for: .normal)
        btnCredito.contentHorizontalAlignment = .leading
        btnCredito.addTarget(self, action: #selector(pedirCredito), for: .touchUpInside)
        contenido.addArrangedSubview(btnCredito)

        let tarjeta = Tarjeta()
        tarjeta.agregar(contenido)
        return tarjeta
    }

    func filaCierre(_ texto: String, _ valor: String, negrita: Bool = false) -> UIView {
        let peso: UIFont.Weight = negrita ? .bold : .regular
        let lblTexto = crearLabel(texto, tamano: 15, peso: peso)
        let lblValor = crearLabel(valor, tamano: 15, peso: peso)
        lblValor.textAlignment = .right
        lblValor.setContentHuggingPriority(.required, for: .horizontal)
        let fila = UIStackView(arrangedSubviews: [lblTexto, lblValor])
        fila.spacing = 8
        return fila
    }

    @objc func pedirCredito() {
        let ventana = UIAlertController(title: "Crédito fiscal del mes", message: "Escribe el IGV de compras que trae el grupo B.", preferredStyle: .alert)
        ventana.addTextField { campo in
            campo.placeholder = "Ej. 2361.60"
            campo.keyboardType = .decimalPad
            if creditoFiscalGuardado > 0 { campo.text = String(format: "%.2f", creditoFiscalGuardado) }
        }
        ventana.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ventana.addAction(UIAlertAction(title: "Calcular", style: .default) { _ in
            let texto = (ventana.textFields?.first?.text ?? "").replacingOccurrences(of: ",", with: ".")
            guard let valor = Double(texto), valor >= 0 else {
                self.alerta("Monto inválido", "Escribe un número, por ejemplo 2361.60")
                return
            }
            creditoFiscalGuardado = valor
            self.armarPanel()
        })
        present(ventana, animated: true)
    }
}

// Gráfico de barras sencillo dibujado a mano
class BarrasView: UIView {
    var valores: [Double] = [] { didSet { setNeedsDisplay() } }
    var etiquetas: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard !valores.isEmpty else { return }
        let maximo = max(valores.max() ?? 0, 1)
        let ancho = rect.width / CGFloat(valores.count)
        let altoLetras: CGFloat = 18
        let altoMaximo = rect.height - altoLetras - 4
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: Paleta.textoSuave]

        for (i, valor) in valores.enumerated() {
            let alto = max(CGFloat(valor / maximo) * altoMaximo, 4)
            let barra = CGRect(x: CGFloat(i) * ancho + ancho * 0.15, y: altoMaximo - alto, width: ancho * 0.7, height: alto)
            let esHoy = i == valores.count - 1
            (esHoy ? Paleta.cafe : Paleta.menta).setFill()
            UIBezierPath(roundedRect: barra, cornerRadius: 4).fill()

            if i < etiquetas.count {
                let letra = etiquetas[i] as NSString
                let tam = letra.size(withAttributes: atributos)
                letra.draw(at: CGPoint(x: CGFloat(i) * ancho + (ancho - tam.width) / 2, y: rect.height - altoLetras), withAttributes: atributos)
            }
        }
    }
}
