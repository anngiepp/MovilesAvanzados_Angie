import UIKit

class DatosIngresadosViewController: UIViewController {

    var oCliente: ClienteModel = ClienteModel()

    @IBOutlet weak var lblApellidos: UILabel!
    @IBOutlet weak var lblNombres: UILabel!
    @IBOutlet weak var lblDNI: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        lblApellidos.text = oCliente.apellidos
        lblNombres.text = oCliente.nombres
        lblDNI.text = oCliente.dni
    }
}
