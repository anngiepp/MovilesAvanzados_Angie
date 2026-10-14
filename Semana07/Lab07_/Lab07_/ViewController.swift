//
//  ViewController.swift
//  Lab07_
//
//  Created by Tecsup on 14/10/26.
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // definir los arreglos que carguen los nombres e imagenes
    var personasArreglo = ["Jaime Gomez", "Juan León", "Silvia Montoya ", "Theo Diaz", "Elliot Garamendi"]
    var personasImagenarreglo = ["Image 1", "Image 2", "Image 3", "Image 4", "Image 5"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personasArreglo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCell") as? PersonasTableViewCell
        cell?.personaNombre.text = "\(personasArreglo[indexPath.row])"
        cell?.PersonaImagen.image = UIImage(named: "\(personasImagenarreglo[indexPath.row])")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "El Docente que Selecciono es : ", message: "\(personasArreglo[indexPath.row])", preferredStyle: .alert)
        
        // Activar el botón OK
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alerta, animated: true, completion: nil)
    }

}
