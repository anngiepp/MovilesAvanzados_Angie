import UIKit
import CoreData

// A6 · Mis ventas (vendedor): solo ve las suyas y no puede anular
class MisVentasViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    var ventas: [Venta] = []
    let tabla = UITableView(frame: .zero, style: .plain)
    let segPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    let buscador = UISearchBar()
    let hoy = tarjetaIndicador("Hoy", fondo: Paleta.cafe, oscura: true)
    let mes = tarjetaIndicador("Mes", fondo: Paleta.azul)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Paleta.fondo
        navigationItem.title = "Mis ventas"
        let usuario = Sesion.shared.usuario
        let btnIniciales = UIBarButtonItem(title: iniciales(usuario?.nombre), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = btnIniciales

        segPeriodo.selectedSegmentIndex = 0
        segPeriodo.addTarget(self, action: #selector(cargar), for: .valueChanged)
        buscador.placeholder = "Buscar por cliente"
        buscador.searchBarStyle = .minimal
        buscador.delegate = self

        let indicadores = UIStackView(arrangedSubviews: [hoy.tarjeta, mes.tarjeta])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually

        let arriba = UIStackView(arrangedSubviews: [indicadores, segPeriodo, buscador])
        arriba.axis = .vertical
        arriba.spacing = 10
        arriba.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arriba)

        tabla.dataSource = self
        tabla.register(FilaCell.self, forCellReuseIdentifier: "fila")
        tabla.separatorStyle = .none
        tabla.backgroundColor = Paleta.fondo
        tabla.keyboardDismissMode = .onDrag
        tabla.tableFooterView = notaPie("Solo aparecen las ventas de este vendedor.")
        tabla.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabla)

        NSLayoutConstraint.activate([
            arriba.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            arriba.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            arriba.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabla.topAnchor.constraint(equalTo: arriba.bottomAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    @objc func cargar() {
        guard let usuario = Sesion.shared.usuario else { return }

        // Indicadores propios (sin anuladas)
        let manana = Calendar.current.date(byAdding: .day, value: 1, to: inicioDelDia())!
        let deHoy = ventasValidas(desde: inicioDelDia(), hasta: manana, vendedor: usuario)
        let delMes = ventasValidas(desde: inicioDelMes(), hasta: manana, vendedor: usuario)
        hoy.valor.text = soles(sumaTotal(deHoy))
        hoy.detalle.text = "\(deHoy.count) ventas"
        mes.valor.text = soles(sumaTotal(delMes))
        mes.detalle.text = "\(delMes.count) ventas"

        // Lista: predicate por vendedor + periodo + cliente
        let req: NSFetchRequest<Venta> = Venta.fetchRequest()
        var filtros = [NSPredicate(format: "vendedor == %@", usuario)]
        if let periodo = predicadoPeriodo(segPeriodo.selectedSegmentIndex) {
            filtros.append(periodo)
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
        celda.mostrarVenta(ventas[indexPath.row], conVendedor: false)
        return celda
    }
}
