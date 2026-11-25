//
//  Theme.swift
//  Semana13_MetodosAPI
//
//  Colores y estilos que se repiten en toda la app
//

import SwiftUI

extension Color {
    static let celeste = Color(red: 0.86, green: 0.92, blue: 0.97)
    static let rosa = Color(red: 0.97, green: 0.87, blue: 0.87)
    static let tinta = Color(red: 0.11, green: 0.11, blue: 0.12)
}

// Boton en forma de pildora (negro relleno o solo con borde)
struct PillButtonStyle: ButtonStyle {
    var filled = true
    var color: Color = .tinta

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(filled ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(filled ? color : Color.clear)
            .overlay(
                Capsule().stroke(color, lineWidth: filled ? 0 : 1.5)
            )
            .clipShape(Capsule())
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

// Puntitos de adorno
struct DotsPattern: View {
    var rows = 3
    var columns = 5

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { _ in
                HStack(spacing: 8) {
                    ForEach(0..<columns, id: \.self) { _ in
                        Circle()
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .foregroundColor(.tinta)
    }
}

// Circulo negro con la inicial del usuario
struct InitialCircle: View {
    let name: String
    var size: CGFloat = 40

    var body: some View {
        Text(String(name.prefix(1)))
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(Circle().fill(Color.tinta))
    }
}
