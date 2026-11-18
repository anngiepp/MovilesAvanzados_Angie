import SwiftUI

// MARK: - Paleta vintage (café, celeste y crema)

extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
}

enum Paleta {
    static let fondo = Color(hex: 0xFFF0DE)       // crema
    static let tarjeta = Color(hex: 0xFFF8EE)
    static let borde = Color(hex: 0xEBD9C4)
    static let cafe = Color(hex: 0x694A47)        // café vintage
    static let azul = Color(hex: 0x96C1C5)        // celeste pastel
    static let azulFuerte = Color(hex: 0x5F9298)
    static let arena = Color(hex: 0xEBCFB2)
    static let salvia = Color(hex: 0xC9D7CB)
    static let rosa = Color(hex: 0xE8C4BD)
    static let latte = Color(hex: 0xD8BFA9)
    static let ambar = Color(hex: 0xD6A25A)
    static let rojo = Color(hex: 0xC2665D)
    static let texto = Color(hex: 0x4B3432)
    static let textoSuave = Color(hex: 0x9A7F7B)
}

extension Font {
    // Letra con serifa para títulos y montos
    static func serif(_ tamano: CGFloat, _ peso: Font.Weight = .bold) -> Font {
        .system(size: tamano, weight: peso, design: .serif)
    }
}

func colorPara(_ texto: String) -> Color {
    let colores = [Paleta.azul, Paleta.arena, Paleta.salvia, Paleta.rosa, Paleta.latte]
    let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
    return colores[suma % colores.count]
}

func colorStock(_ stock: Int) -> Color {
    if stock > 10 { return Paleta.azulFuerte }
    if stock >= 6 { return Paleta.ambar }
    return Paleta.rojo
}

func colorEstado(_ estado: String) -> Color {
    switch estado {
    case "Pendiente": return Paleta.ambar
    case "Rechazada": return Paleta.rojo
    default: return Paleta.azulFuerte
    }
}

// Convierte un String? en un Bool para mostrar alertas
func mostrar(_ texto: Binding<String?>) -> Binding<Bool> {
    Binding(get: { texto.wrappedValue != nil }, set: { if !$0 { texto.wrappedValue = nil } })
}

// MARK: - Modificadores

struct Tarjeta: ViewModifier {
    var fondo: Color

    func body(content: Content) -> some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(fondo, in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(fondo == Paleta.tarjeta ? Paleta.borde : .clear, lineWidth: 1))
    }
}

extension View {
    func tarjeta(_ fondo: Color = Paleta.tarjeta) -> some View {
        modifier(Tarjeta(fondo: fondo))
    }

    // Fila de lista sin fondo ni separador (la tarjeta pone el fondo)
    func filaLimpia() -> some View {
        self.listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
    }

    func fondoCrema() -> some View {
        self.scrollContentBackground(.hidden)
            .background(Paleta.fondo)
    }
}

// MARK: - Botones

struct BotonPrincipal: ButtonStyle {
    var color: Color = Paleta.cafe

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label.font(.serif(18))
            Spacer()
            Image(systemName: "arrow.right.circle.fill").font(.title3)
        }
        .foregroundStyle(Paleta.fondo)
        .padding(.horizontal, 20)
        .frame(height: 54)
        .background(color.opacity(configuration.isPressed ? 0.8 : 1), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct BotonBorde: ButtonStyle {
    var color: Color = Paleta.cafe

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color, lineWidth: 1.5))
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

// MARK: - Vistas reutilizables

struct Etiqueta: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color, in: Capsule())
    }
}

struct Avatar: View {
    let texto: String
    var color: Color = Paleta.azul
    var tamano: CGFloat = 42

    var body: some View {
        Text(texto)
            .font(.system(size: tamano * 0.36, weight: .bold))
            .foregroundStyle(Paleta.texto)
            .frame(width: tamano, height: tamano)
            .background(color, in: Circle())
    }
}

// Campo con título pequeño y una línea abajo
struct CampoSubrayado: View {
    let titulo: String
    @Binding var texto: String
    var placeholder = ""
    var seguro = false
    var aviso: String? = nil
    var colorAviso: Color = Paleta.azulFuerte

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.caption.bold()).foregroundStyle(Paleta.azulFuerte)
            HStack {
                Group {
                    if seguro {
                        SecureField(placeholder, text: $texto)
                    } else {
                        TextField(placeholder, text: $texto)
                    }
                }
                .font(.system(size: 18))
                .foregroundStyle(Paleta.texto)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                if let aviso = aviso {
                    Text(aviso).font(.footnote.bold()).foregroundStyle(colorAviso)
                }
            }
            Rectangle().fill(Paleta.cafe.opacity(0.35)).frame(height: 1.5)
        }
    }
}

// Banner de color con ícono y dos líneas
struct Banner: View {
    let icono: String
    let titulo: String
    let detalle: String
    var fondo: Color = Paleta.azul

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .font(.title3)
                .foregroundStyle(Paleta.cafe)
                .frame(width: 44, height: 44)
                .background(Paleta.tarjeta.opacity(0.7), in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo).font(.serif(19)).foregroundStyle(Paleta.texto)
                Text(detalle).font(.footnote).foregroundStyle(Paleta.cafe)
            }
            Spacer()
        }
        .tarjeta(fondo)
    }
}

// Fila tipo tarjeta con franja de color a la izquierda
struct FilaTarjeta<Derecha: View>: View {
    let iniciales: String
    var icono: String? = nil
    let colorAvatar: Color
    let titulo: String
    let subtitulo: String
    var nota: String? = nil
    var franja: Color = Paleta.azul
    @ViewBuilder let derecha: Derecha

    var body: some View {
        HStack(spacing: 12) {
            if let icono = icono {
                Image(systemName: icono)
                    .font(.headline)
                    .foregroundStyle(Paleta.texto)
                    .frame(width: 42, height: 42)
                    .background(colorAvatar, in: Circle())
            } else {
                Avatar(texto: iniciales, color: colorAvatar)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(titulo).font(.headline).foregroundStyle(Paleta.texto).lineLimit(1)
                Text(subtitulo).font(.footnote).foregroundStyle(Paleta.textoSuave).lineLimit(1)
                if let nota = nota {
                    Text(nota).font(.caption.bold()).foregroundStyle(Paleta.rojo).lineLimit(2)
                }
            }
            Spacer(minLength: 4)
            derecha
        }
        .padding(.vertical, 12)
        .padding(.leading, 19)
        .padding(.trailing, 14)
        .background(Paleta.tarjeta)
        .overlay(alignment: .leading) { franja.frame(width: 7) }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Paleta.borde, lineWidth: 1))
    }
}

// Avatar de la sesión con menú (nombre, rol y Cerrar sesión)
struct MenuCuenta: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        Menu {
            Text(sesion.usuario?.nombre ?? "")
            Text(sesion.usuario?.rol ?? "")
            Button("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                sesion.usuario = nil
            }
        } label: {
            Avatar(texto: iniciales(sesion.usuario?.nombre ?? ""), color: Paleta.azul, tamano: 36)
        }
    }
}

// Dos medias lunas apiladas (café adelante, celeste atrás)
struct Tazones: View {
    var body: some View {
        GeometryReader { geo in
            let ancho = geo.size.width
            let alto = geo.size.height
            ZStack {
                Ellipse()
                    .fill(Paleta.azul)
                    .frame(width: ancho * 1.9, height: alto * 2)
                    .position(x: ancho / 2, y: 0)
                Ellipse()
                    .fill(Paleta.cafe)
                    .frame(width: ancho * 2, height: alto * 1.8)
                    .position(x: ancho / 2, y: -alto * 0.1)
            }
        }
    }
}
