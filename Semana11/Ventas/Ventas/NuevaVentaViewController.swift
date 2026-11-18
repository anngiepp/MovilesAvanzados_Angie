import UIKit
import CoreData

// A5 · Nueva venta (solo vendedor)
class NuevaVentaViewController: UITableViewController {

    var cliente: Cliente?
    var producto: Producto?
    var cantidad = 1

    let celdaCantidad = UITableViewCell(style: .default, reuseIdentifier: nil)
    let txtCantidad = UITextField()
    let stepper = UIStepper()

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nueva venta"
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView = crearBanner()
        armarCeldaCantidad()

        let pie = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        let btnRegistrar = botonPrincipal("Registrar venta")
        btnRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)
        btnRegistrar.translatesAutoresizingMaskIntoConstraints = false
        pie.addSubview(btnRegistrar)
        NSLayoutConstraint.activate([
            btnRegistrar.topAnchor.constraint(equalTo: pie.topAnchor, constant: 12),
            btnRegistrar.leadingAnchor.constraint(equalTo: pie.leadingAnchor, constant: 20),
            btnRegistrar.trailingAnchor.constraint(equalTo: pie.trailingAnchor, constant: -20)
        ])
        tableView.tableFooterView = pie
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizar()
    }

    // Vendedor de la sesión: automático, no se puede cambiar
    func crearBanner() -> UIView {
        let usuario = Sesion.shared.usuario
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 84))
        let tarjeta = Tarjeta()
        tarjeta.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)

        let avatar = AvatarView(tamano: 40)
        avatar.poner(iniciales(usuario?.nombre), .systemBlue)
        let lblNombre = crearLabel("\(usuario?.nombre ?? "") · \(usuario?.rol ?? "")", tamano: 15, peso: .semibold, color: .systemBlue)
        let lblNota = crearLabel("Sesión iniciada · la venta se registra a tu nombre", tamano: 12, color: .systemBlue)
        let textos = UIStackView(arrangedSubviews: [lblNombre, lblNota])
        textos.axis = .vertical
        textos.spacing = 2
        let fila = UIStackView(arrangedSubviews: [avatar, textos])
        fila.spacing = 12
        fila.alignment = .center
        tarjeta.agregar(fila, margen: 12)

        tarjeta.frame = contenedor.bounds.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        tarjeta.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contenedor.addSubview(tarjeta)
        return contenedor
    }

    func armarCeldaCantidad() {
        celdaCantidad.selectionStyle = .none
        txtCantidad.keyboardType = .numberPad
        txtCantidad.textAlignment = .center
        txtCantidad.font = .systemFont(ofSize: 17, weight: .semibold)
        txtCantidad.borderStyle = .roundedRect
        txtCantidad.widthAnchor.constraint(equalToConstant: 60).isActive = true
        txtCantidad.addTarget(self, action: #selector(cambioTexto), for: .editingChanged)

        stepper.minimumValue = 1
        stepper.maximumValue = 9999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioStepper), for: .valueChanged)

        let controles = UIStackView(arrangedSubviews: [txtCantidad, stepper])
        controles.spacing = 8
        controles.alignment = .center
        controles.frame = CGRect(x: 0, y: 0, width: 60 + 8 + 94, height: 32)
        celdaCantidad.accessoryView = controles
    }

    @objc func cambioTexto() {
        cantidad = Int(txtCantidad.text ?? "") ?? 0
        if cantidad > 0 { stepper.value = Double(cantidad) }
        actualizar(recargarCantidad: false)
    }

    @objc func cambioStepper() {
        cantidad = Int(stepper.value)
        actualizar()
    }

    func actualizar(recargarCantidad: Bool = true) {
        if recargarCantidad { txtCantidad.text = "\(cantidad)" }
        let stock = producto.map { "  (stock \($0.stock))" } ?? ""
        let texto = NSMutableAttributedString(string: "Cantidad")
        texto.append(NSAttributedString(string: stock, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.secondaryLabel]))
        celdaCantidad.textLabel?.attributedText = texto
        if recargarCantidad {
            tableView.reloadData()
        } else {
            // Mientras escribe la cantidad solo se recalcula el resumen
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }

    func calculoActual() -> Calculo {
        guard let producto = producto else { return Calculo(subtotal: 0, descuento: 0, igv: 0, total: 0) }
        let cat = cliente.map { categoria(de: $0) } ?? "Regular"
        return calcularVenta(cantidad: max(cantidad, 0), precio: producto.precio, categoria: cat)
    }

    // MARK: - Tabla

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 3 : 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Resumen (calculado)" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 2 {
            return celdaCantidad
        }
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        celda.textLabel?.font = .systemFont(ofSize: 17)

        if indexPath.section == 0 {
            celda.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                celda.textLabel?.text = "Cliente"
                celda.detailTextLabel?.text = cliente?.nombre ?? "Elegir"
            } else {
                celda.textLabel?.text = "Producto"
                celda.detailTextLabel?.text = producto?.nombre ?? "Elegir"
            }
            return celda
        }

        celda.selectionStyle = .none
        let calculo = calculoActual()
        switch indexPath.row {
        case 0:
            celda.textLabel?.text = "Subtotal"
            celda.detailTextLabel?.text = soles(calculo.subtotal)
        case 1:
            let esVIP = cliente.map { categoria(de: $0) } == "VIP"
            celda.textLabel?.text = esVIP ? "Descuento VIP 10%" : "Descuento"
            celda.detailTextLabel?.text = "− " + soles(calculo.descuento)
        case 2:
            celda.textLabel?.text = "IGV 18%"
            celda.detailTextLabel?.text = soles(calculo.igv)
        default:
            celda.textLabel?.text = "Total"
            celda.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            celda.detailTextLabel?.text = soles(calculo.total)
            celda.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            celda.detailTextLabel?.textColor = .label
        }
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 0 else { return }
        if indexPath.row == 0 { elegirCliente() }
        if indexPath.row == 1 { elegirProducto() }
    }

    func elegirCliente() {
        let req: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let lista = (try? BD.contexto.fetch(req)) ?? []
        let pantalla = SeleccionViewController(titulo: "Cliente",
                                               opciones: lista.map { $0.nombre ?? "" },
                                               detalles: lista.map { "\($0.documento ?? "") · \(categoria(de: $0))" })
        pantalla.alElegir = { [weak self] i in
            self?.cliente = lista[i]
            self?.actualizar()
        }
        navigationController?.pushViewController(pantalla, animated: true)
    }

    func elegirProducto() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        let lista = (try? BD.contexto.fetch(req)) ?? []
        let pantalla = SeleccionViewController(titulo: "Producto",
                                               opciones: lista.map { $0.nombre ?? "" },
                                               detalles: lista.map { "\(soles($0.precio)) · stock \($0.stock)" })
        pantalla.alElegir = { [weak self] i in
            self?.producto = lista[i]
            self?.actualizar()
        }
        navigationController?.pushViewController(pantalla, animated: true)
    }

    // MARK: - Registrar

    @objc func registrar() {
        view.endEditing(true)
        guard let cliente = cliente, let producto = producto else {
            alerta("Faltan datos", "Elige un cliente y un producto.")
            return
        }
        guard cantidad > 0 else {
            alerta("Cantidad inválida", "La cantidad debe ser mayor a 0.")
            return
        }
        // Regla de stock: si no alcanza, no se registra
        if cantidad > Int(producto.stock) {
            alerta("Stock insuficiente", "Solo hay \(producto.stock) unidades de \(producto.nombre ?? ""). La venta no se registró.")
            return
        }

        let calculo = calculoActual()
        let venta = Venta(context: BD.contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = calculo.descuento
        venta.igv = calculo.igv
        venta.total = calculo.total
        venta.anulada = false
        venta.vendedor = Sesion.shared.usuario
        venta.cliente = cliente
        venta.producto = producto
        producto.stock -= Int64(cantidad)

        if BD.guardar() {
            alerta("Venta registrada", "Total \(soles(calculo.total)). Stock de \(producto.nombre ?? ""): \(producto.stock) u.")
            self.cliente = nil
            self.producto = nil
            cantidad = 1
            stepper.value = 1
            actualizar()
        } else {
            alerta("Error", "No se pudo guardar la venta.")
        }
    }
}
