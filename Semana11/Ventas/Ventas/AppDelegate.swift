import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }

    // El nombre tiene que ser igual al del archivo Ventas.xcdatamodeld
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Ventas")
        container.loadPersistentStores { descripcion, error in
            if let error = error {
                fatalError("No se pudo cargar Core Data: \(error)")
            }
            print("Base de datos en: \(descripcion.url?.path ?? "")")
        }
        return container
    }()
}
