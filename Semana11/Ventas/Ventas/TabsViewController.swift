import UIKit

// Pestañas según el rol, con un botón redondo en el centro para la acción principal
// Vendedor:   Catálogo · Clientes · (Vender) · Mis ventas · Perfil
// Supervisor: Ventas · Catálogo · (Resumen) · Clientes · Perfil
class TabsViewController: UITabBarController {

    let botonCentro = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        if Sesion.shared.esSupervisor {
            viewControllers = [
                pestana(VentasEquipoViewController(), "Ventas", "list.bullet.rectangle"),
                pestana(ProductosViewController(), "Catálogo", "shippingbox"),
                pestana(ResumenViewController(), "Resumen", nil),
                pestana(ClientesViewController(), "Clientes", "person.2"),
                pestana(CuentaViewController(), "Perfil", "person.crop.circle")
            ]
            armarBotonCentro("chart.bar.fill")
        } else {
            viewControllers = [
                pestana(ProductosViewController(), "Catálogo", "shippingbox"),
                pestana(ClientesViewController(), "Clientes", "person.2"),
                pestana(NuevaVentaViewController(), "Vender", nil),
                pestana(MisVentasViewController(), "Mis ventas", "doc.text"),
                pestana(CuentaViewController(), "Perfil", "person.crop.circle")
            ]
            armarBotonCentro("cart.fill.badge.plus")
        }
        // Se abre directo en la pestaña del centro
        selectedIndex = 2
    }

    func pestana(_ vc: UIViewController, _ titulo: String, _ icono: String?) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        let imagen = icono.map { UIImage(systemName: $0) } ?? nil
        nav.tabBarItem = UITabBarItem(title: titulo, image: imagen, tag: 0)
        return nav
    }

    func armarBotonCentro(_ icono: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        botonCentro.setImage(UIImage(systemName: icono, withConfiguration: config), for: .normal)
        botonCentro.tintColor = Paleta.fondo
        botonCentro.backgroundColor = Paleta.cafe
        botonCentro.layer.cornerRadius = 32
        botonCentro.layer.borderWidth = 5
        botonCentro.layer.borderColor = Paleta.fondo.cgColor
        botonCentro.addTarget(self, action: #selector(tocarCentro), for: .touchUpInside)
        tabBar.addSubview(botonCentro)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        botonCentro.frame = CGRect(x: tabBar.bounds.midX - 32, y: -26, width: 64, height: 64)
        tabBar.bringSubviewToFront(botonCentro)
    }

    @objc func tocarCentro() {
        selectedIndex = 2
    }
}
