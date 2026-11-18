import UIKit
import CoreData

// A4 · Clientes
// Los dos roles crean y editan; solo el supervisor borra.
class ClientesViewController: UITableViewController, UISearchResultsUpdating {

    var clientes: [Cliente] = []
    let buscador = UISearchController(searchResultsController: nil)
    let banner = BannerView(icono: "person.2.fill", fondo: Paleta.durazno)

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Clientes"
        tableView.register(FilaCell.self, forCellReuseIdentifier: "fila")

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.tableHeaderView = cabeceraLista(banner: banner, chips: nil, ancho: view.bounds.width)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregar))
        tableView.tableFooterView = notaPie("Categoría y \"comprado\" se calculan con las ventas no anuladas; no se guardan.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func cargar() {
        let req: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            req.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = (try? BD.contexto.fetch(req)) ?? []
        let vip = clientes.filter { categoria(de: $0) == "VIP" }.count
        let frecuentes = clientes.filter { categoria(de: $0) == "Frecuente" }.count
        banner.lblTitulo.text = "\(clientes.count) clientes"
        banner.lblDetalle.text = "\(vip) VIP · \(frecuentes) frecuentes"
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        let c = clientes[indexPath.row]
        let total = totalComprado(c)
        let cat = categoria(totalComprado: total)
        celda.avatar.poner(iniciales(c.nombre), colorPara(c.nombre))
        celda.configurar(titulo: c.nombre, subtitulo: c.documento, valor: soles(total), detalle: "comprado", etiqueta: cat, colorEtiqueta: colorCategoria(cat))
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        formulario(clientes[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { _, _, listo in
            self.borrar(self.clientes[indexPath.row])
            listo(true)
        }
        borrar.backgroundColor = Paleta.rojo
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    func borrar(_ cliente: Cliente) {
        // Delete rule Deny: si tiene ventas no se puede borrar
        if (cliente.ventas?.count ?? 0) > 0 {
            alerta("No se puede borrar", "\(cliente.nombre ?? "El cliente") tiene ventas registradas.")
            return
        }
        BD.contexto.delete(cliente)
        BD.guardar()
        cargar()
    }

    // MARK: - Crear y editar

    @objc func agregar() {
        formulario(nil)
    }

    func formulario(_ cliente: Cliente?) {
        let ventana = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente", message: nil, preferredStyle: .alert)
        ventana.addTextField { campo in
            campo.placeholder = "Nombre o razón social"
            campo.autocapitalizationType = .words
            campo.text = cliente?.nombre
        }
        ventana.addTextField { campo in
            campo.placeholder = "Documento (DNI o RUC)"
            campo.text = cliente?.documento
        }
        ventana.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ventana.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let campos = ventana.textFields ?? []
            let nombre = campos[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let documento = campos[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            guard !nombre.isEmpty, !documento.isEmpty else {
                self.alerta("Datos incompletos", "Escribe el nombre y el documento.")
                return
            }
            let c = cliente ?? Cliente(context: BD.contexto)
            c.nombre = nombre
            c.documento = documento
            BD.guardar()
            self.cargar()
        })
        present(ventana, animated: true)
    }
}
