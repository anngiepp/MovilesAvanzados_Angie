import UIKit
import CoreData

// A3 · Productos
// Vendedor: solo consulta. Supervisor: crea, edita y borra.
class ProductosViewController: UITableViewController, UISearchResultsUpdating {

    var productos: [Producto] = []
    var categorias: [String] = []
    let chips = ChipsView()
    let buscador = UISearchController(searchResultsController: nil)

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Productos"
        tableView.register(FilaCell.self, forCellReuseIdentifier: "fila")

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        let cabecera = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 48))
        chips.frame = cabecera.bounds.insetBy(dx: 0, dy: 6)
        chips.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cabecera.addSubview(chips)
        tableView.tableHeaderView = cabecera
        chips.alSeleccionar = { [weak self] _ in self?.cargar() }

        if Sesion.shared.esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregar))
            tableView.tableFooterView = notaPie("Desliza a la izquierda para borrar. Toca un producto para editarlo.")
        } else {
            tableView.tableFooterView = notaPie("Vista de vendedor: solo consulta.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarCategorias()
        cargar()
    }

    func cargarCategorias() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        let todos = (try? BD.contexto.fetch(req)) ?? []
        categorias = Array(Set(todos.compactMap { $0.categoria })).sorted()
        chips.ponerOpciones(["Todos"] + categorias)
    }

    func cargar() {
        let req: NSFetchRequest<Producto> = Producto.fetchRequest()
        var filtros: [NSPredicate] = []

        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        if chips.seleccionado > 0 {
            filtros.append(NSPredicate(format: "categoria == %@", categorias[chips.seleccionado - 1]))
        }

        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        productos = (try? BD.contexto.fetch(req)) ?? []
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        let p = productos[indexPath.row]
        celda.avatar.poner(iniciales(p.nombre), colorPara(p.categoria))
        celda.configurar(titulo: p.nombre, subtitulo: p.categoria, valor: soles(p.precio), etiqueta: "\(p.stock) u.", colorEtiqueta: colorStock(p.stock))
        celda.accessoryType = .none
        celda.selectionStyle = Sesion.shared.esSupervisor ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if Sesion.shared.esSupervisor {
            formulario(productos[indexPath.row])
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { _, _, listo in
            self.borrar(self.productos[indexPath.row])
            listo(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    func borrar(_ producto: Producto) {
        // Delete rule Deny: si tiene ventas no se puede borrar
        if (producto.ventas?.count ?? 0) > 0 {
            alerta("No se puede borrar", "\(producto.nombre ?? "El producto") tiene ventas registradas.")
            return
        }
        BD.contexto.delete(producto)
        BD.guardar()
        cargarCategorias()
        cargar()
    }

    // MARK: - Crear y editar

    @objc func agregar() {
        formulario(nil)
    }

    func formulario(_ producto: Producto?) {
        let ventana = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto", message: nil, preferredStyle: .alert)
        ventana.addTextField { campo in
            campo.placeholder = "Nombre"
            campo.text = producto?.nombre
        }
        ventana.addTextField { campo in
            campo.placeholder = "Categoría (ej. Laptops)"
            campo.text = producto?.categoria
        }
        ventana.addTextField { campo in
            campo.placeholder = "Precio"
            campo.keyboardType = .decimalPad
            if let producto = producto { campo.text = String(format: "%.2f", producto.precio) }
        }
        ventana.addTextField { campo in
            campo.placeholder = "Stock"
            campo.keyboardType = .numberPad
            if let producto = producto { campo.text = "\(producto.stock)" }
        }
        ventana.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ventana.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let campos = ventana.textFields ?? []
            let nombre = campos[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let categoria = campos[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let precio = Double((campos[2].text ?? "").replacingOccurrences(of: ",", with: "."))
            let stock = Int64(campos[3].text ?? "")

            guard !nombre.isEmpty, !categoria.isEmpty, let precio = precio, precio > 0, let stock = stock, stock >= 0 else {
                self.alerta("Datos incompletos", "Revisa nombre, categoría, precio mayor a 0 y stock.")
                return
            }
            let p = producto ?? Producto(context: BD.contexto)
            p.nombre = nombre
            p.categoria = categoria
            p.precio = precio
            p.stock = stock
            BD.guardar()
            self.cargarCategorias()
            self.cargar()
        })
        present(ventana, animated: true)
    }
}
