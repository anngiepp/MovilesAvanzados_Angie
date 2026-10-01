import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfApellidos: UITextField!
    @IBOutlet weak var tfNombres: UITextField!
    @IBOutlet weak var tfDNI: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDatosIngresados" {
            let apellidos = tfApellidos.text ?? ""
            let nombres = tfNombres.text ?? ""
            let dni = tfDNI.text ?? ""

            let cliente = ClienteModel(apellidos: apellidos, nombres: nombres, dni: dni)

            if let destinoVC = segue.destination as? DatosIngresadosViewController {
                destinoVC.oCliente = cliente
            }
        }
    }
}
