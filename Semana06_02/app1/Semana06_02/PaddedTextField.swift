import UIKit

// El campo se coloca y conecta en Main.storyboard; esta clase solo añade margen interior.
class PaddedTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
