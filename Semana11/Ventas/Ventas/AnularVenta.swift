import UIKit

// A8 · Anular venta (solo supervisor)
// El motivo es obligatorio: el botón Anular está desactivado mientras esté vacío.
extension UIViewController {

    func pedirAnulacion(_ venta: Venta, alTerminar: @escaping () -> Void) {
        guard Sesion.shared.esSupervisor, !venta.anulada else { return }

        let resumen = "\(venta.cliente?.nombre ?? "") · \(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(soles(venta.total))\nEl stock se devolverá (+\(venta.cantidad))."
        let ventana = UIAlertController(title: "Anular venta", message: resumen, preferredStyle: .alert)

        let btnAnular = UIAlertAction(title: "Anular", style: .destructive) { [weak ventana] _ in
            let motivo = ventana?.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) ?? ""
            guard !motivo.isEmpty else { return }

            venta.anulada = true
            venta.motivoAnulacion = motivo
            // Devolver el stock
            if let producto = venta.producto {
                producto.stock += venta.cantidad
            }
            BD.guardar()
            alTerminar()
        }
        btnAnular.isEnabled = false

        ventana.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
            campo.autocapitalizationType = .sentences
            campo.addAction(UIAction { [weak campo] _ in
                let texto = campo?.text?.trimmingCharacters(in: .whitespaces) ?? ""
                btnAnular.isEnabled = !texto.isEmpty
            }, for: .editingChanged)
        }
        ventana.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ventana.addAction(btnAnular)
        present(ventana, animated: true)
    }
}
