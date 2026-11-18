import UIKit

// Lista simple para elegir un cliente o un producto en Nueva venta
class SeleccionViewController: UITableViewController {

    var opciones: [String] = []
    var detalles: [String] = []
    var alElegir: ((Int) -> Void)?

    init(titulo: String, opciones: [String], detalles: [String]) {
        super.init(style: .insetGrouped)
        navigationItem.title = titulo
        self.opciones = opciones
        self.detalles = detalles
    }

    required init?(coder: NSCoder) { fatalError() }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        opciones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        celda.backgroundColor = Paleta.tarjeta
        celda.textLabel?.text = opciones[indexPath.row]
        celda.detailTextLabel?.text = detalles[indexPath.row]
        celda.detailTextLabel?.textColor = Paleta.textoSuave
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alElegir?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
