import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfApellidos: UITextField!
    @IBOutlet weak var tfNombres: UITextField!
    @IBOutlet weak var tfDNI: UITextField!
    @IBOutlet weak var formularioScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tfApellidos.delegate = self
        tfNombres.delegate = self
        tfDNI.delegate = self
        let barra = UIToolbar()
        barra.sizeToFit()
        barra.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Listo", style: .plain, target: self,
                            action: #selector(cerrarTeclado))
        ]
        tfDNI.inputAccessoryView = barra
        NotificationCenter.default.addObserver(self, selector: #selector(ajustarTeclado(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        let toque = UITapGestureRecognizer(target: self, action: #selector(cerrarTeclado))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
    }

    @IBAction func btnContinuar(_ sender: UIButton) {
        let apellidos = (tfApellidos.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombres = (tfNombres.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (tfDNI.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if apellidos.isEmpty || nombres.isEmpty || dni.isEmpty {
            mostrarError("Completa los apellidos, nombres y DNI.")
            return
        }
        if dni.count != 8 || !dni.allSatisfy({ "0123456789".contains($0) }) {
            mostrarError("El DNI debe tener exactamente 8 dígitos.")
            return
        }
        let cliente = ClienteModel(apellidos: apellidos, nombres: nombres, dni: dni)
        let pantalla = storyboard!.instantiateViewController(
            withIdentifier: "ViewControllerConfirmacion") as! ViewControllerConfirmacion
        pantalla.oCliente = cliente
        view.endEditing(true)
        present(pantalla, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func ajustarTeclado(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let teclado = view.convert(frame, from: nil)
        let solapamiento = formularioScrollView.frame.intersection(teclado)
        let margen = solapamiento.isNull ? 0 : solapamiento.height
        formularioScrollView.contentInset.bottom = margen
        formularioScrollView.verticalScrollIndicatorInsets.bottom = margen
        if let campo = [tfApellidos, tfNombres, tfDNI].compactMap({ $0 }).first(where: { $0.isFirstResponder }) {
            let area = campo.convert(campo.bounds, to: formularioScrollView).insetBy(dx: 0, dy: -20)
            formularioScrollView.scrollRectToVisible(area, animated: true)
        }
    }

    private func mostrarError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Revisa los datos", message: mensaje,
                                      preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    @objc private func cerrarTeclado() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfApellidos {
            tfNombres.becomeFirstResponder()
        } else {
            tfDNI.becomeFirstResponder()
        }
        return true
    }
}
