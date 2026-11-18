import UIKit

// Las pestañas cambian según el rol de la sesión
class TabsViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Sesion.shared.esSupervisor {
            viewControllers = [
                pestana(ResumenViewController(), "Resumen", "chart.bar.fill"),
                pestana(VentasEquipoViewController(), "Ventas", "list.bullet.rectangle.fill"),
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(), "Clientes", "person.2.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        } else {
            viewControllers = [
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(), "Clientes", "person.2.fill"),
                pestana(NuevaVentaViewController(), "Venta", "cart.fill.badge.plus"),
                pestana(MisVentasViewController(), "Mis ventas", "doc.text.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        }
    }

    func pestana(_ vc: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return nav
    }
}
