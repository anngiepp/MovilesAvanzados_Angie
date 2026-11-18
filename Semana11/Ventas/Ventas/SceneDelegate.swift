import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        aplicarApariencia(window!)
        DatosEjemplo.cargarSiHaceFalta()
        mostrarLogin()
        window?.makeKeyAndVisible()
    }

    func mostrarLogin() {
        cambiarPantalla(UINavigationController(rootViewController: LoginViewController()))
    }

    func mostrarApp() {
        cambiarPantalla(TabsViewController())
    }

    func cambiarPantalla(_ vc: UIViewController) {
        guard let window = window else { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        BD.guardar()
    }
}
