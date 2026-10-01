import UIKit

class ClienteModel: NSObject {
    var apellidos: String = ""
    var nombres: String = ""
    var dni: String = ""
    
    override init() {
        super.init()
    }
    
    init(apellidos: String, nombres: String, dni: String) {
        self.apellidos = apellidos
        self.nombres = nombres
        self.dni = dni
    }
}
