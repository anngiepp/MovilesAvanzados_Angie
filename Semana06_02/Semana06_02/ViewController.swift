import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfApellidos: UITextField!
    @IBOutlet weak var tfNombres: UITextField!
    @IBOutlet weak var tfDNI: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnContinuar(_ sender: UIButton) {
        let cliente = ClienteModel(apellidos: tfApellidos.text ?? "",
                                   nombres: tfNombres.text ?? "",
                                   dni: tfDNI.text ?? "")
        let pantalla = storyboard!.instantiateViewController(
            withIdentifier: "ViewControllerConfirmacion") as! ViewControllerConfirmacion
        pantalla.oCliente = cliente
        view.endEditing(true)
        present(pantalla, animated: true)
    }
}
