import UIKit
import CoreData

// A7 · Ventas del equipo (supervisor): ve todas, filtra por vendedor y anula
class VentasEquipoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var ventas: [Venta] = []
    var vendedores: [Usuario] = []
    let tabla = UITableView(frame: .zero, style: .insetGrouped)
    let segPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    let chips = ChipsView()
    let buscador = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Ventas del equipo"
        let usuario = Sesion.shared.usuario
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: iniciales(usuario?.nombre), style: .plain, target: nil, action: nil)

        segPeriodo.selectedSegmentIndex = 0
        segPeriodo.addTarget(self, action: #selector(cargar), for: .valueChanged)
        chips.alSeleccionar = { [weak self] _ in self?.cargar() }
        chips.heightAnchor.constraint(equalToConstant: 36).isActive = true
        buscador.placeholder = "Buscar por cliente"
        buscador.searchBarStyle = .minimal
        buscador.delegate = self

        let segConMargen = UIStackView(arrangedSubviews: [segPeriodo])
        segConMargen.isLayoutMarginsRelativeArrangement = true
        segConMargen.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let buscadorConMargen = UIStackView(arrangedSubviews: [buscador])
        buscadorConMargen.isLayoutMarginsRelativeArrangement = true
        buscadorConMargen.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        let arriba = UIStackView(arrangedSubviews: [segConMargen, chips, buscadorConMargen])
        arriba.axis = .vertical
        arriba.spacing = 10
        arriba.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arriba)

        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(FilaCell.self, forCellReuseIdentifier: "fila")
        tabla.keyboardDismissMode = .onDrag
        tabla.tableFooterView = notaPie("El nombre del vendedor se lee de la relación venta ▸ vendedor. Desliza para anular.")
        tabla.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabla)

        NSLayoutConstraint.activate([
            arriba.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            arriba.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arriba.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.topAnchor.constraint(equalTo: arriba.bottomAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarVendedores()
        cargar()
    }

    func cargarVendedores() {
        let req: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        req.predicate = NSPredicate(format: "rol == %@", "Vendedor")
        req.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        vendedores = (try? BD.contexto.fetch(req)) ?? []
        chips.ponerOpciones(["Todos"] + vendedores.map { $0.nombre ?? "" })
    }

    @objc func cargar() {
        let req: NSFetchRequest<Venta> = Venta.fetchRequest()
        var filtros: [NSPredicate] = []
        if let periodo = predicadoPeriodo(segPeriodo.selectedSegmentIndex) {
            filtros.append(periodo)
        }
        // Filtro por la relación venta ▸ vendedor
        if chips.seleccionado > 0 {
            filtros.append(NSPredicate(format: "vendedor == %@", vendedores[chips.seleccionado - 1]))
        }
        let texto = buscador.text ?? ""
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto))
        }
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        req.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        ventas = (try? BD.contexto.fetch(req)) ?? []
        tabla.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "fila", for: indexPath) as! FilaCell
        celda.mostrarVenta(ventas[indexPath.row], conVendedor: true)
        return celda
    }

    // Deslizar para Anular (las anuladas ya no tienen botón)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard Sesion.shared.esSupervisor, !venta.anulada else { return nil }
        let anular = UIContextualAction(style: .destructive, title: "Anular") { _, _, listo in
            self.pedirAnulacion(venta) {
                self.cargar()
            }
            listo(true)
        }
        return UISwipeActionsConfiguration(actions: [anular])
    }
}
