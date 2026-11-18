import UIKit
import CoreData

// Acceso corto al contexto de Core Data
enum BD {
    static var contexto: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    @discardableResult
    static func guardar() -> Bool {
        guard contexto.hasChanges else { return true }
        do {
            try contexto.save()
            return true
        } catch {
            print("Error al guardar: \(error)")
            contexto.rollback()
            return false
        }
    }
}

// Guarda quién está conectado mientras la app está abierta
class Sesion {
    static let shared = Sesion()
    var usuario: Usuario?

    var esSupervisor: Bool {
        usuario?.rol == "Supervisor"
    }
}
