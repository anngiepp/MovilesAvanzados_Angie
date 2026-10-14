//
//  ViewController.swift
//  Lab07_Ejercicio
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // lista de Profesores con los nombres de tus imágenes (Image01 a Image07)
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "Image01")),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "Image02")),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "Image03")),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "Image04")),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "Image05")),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "Image06")),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC", foto: UIImage(named: "Image07"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Métodos del data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // crear un objeto para que se muestre en la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
        cell.textLabel?.text = listaProfesores[indexPath.row].nombre
        cell.detailTextLabel?.text = String(listaProfesores[indexPath.row].cargo)
        cell.imageView?.image = listaProfesores[indexPath.row].foto!
        return cell
    }

}
