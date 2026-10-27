import SwiftUI

struct ContentView: View {
    @State private var formulario = FormularioBoleta()
    @State private var resultado: ResultadoBoleta?
    @State private var error = ""
    private let tinta = Color(red: 0.12, green: 0.20, blue: 0.32)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("SEMANA 09 · SWIFTUI").font(.caption).bold().foregroundStyle(.secondary)
                    Text("Boleta de ejemplo").font(.largeTitle).bold().foregroundStyle(tinta)
                    Text("Del sueldo al neto").font(.title3).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("Datos del mes").font(.title2).bold()
                    campo("Sueldo básico (S/)", texto: $formulario.sueldo)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Días laborados").font(.subheadline).bold()
                        TextField("1 a 30", text: $formulario.dias).keyboardType(.numberPad).textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("¿Tiene hijos?").font(.subheadline).bold()
                        Picker("¿Tiene hijos?", selection: $formulario.hijos) {
                            Text("No").tag(false)
                            Text("Sí").tag(true)
                        }.pickerStyle(.segmented)
                    }
                    Text("Sistema de pensiones: ONP (13%)").font(.subheadline)
                    Text("Usa punto o coma decimal, sin separadores de miles.").font(.caption).foregroundStyle(.secondary)
                    Button(action: calcular) {
                        Text("Calcular boleta").font(.headline).frame(maxWidth: .infinity).padding(.vertical, 8)
                    }.buttonStyle(.borderedProminent).tint(tinta)
                    if !error.isEmpty {
                        Text(error).foregroundStyle(.red).font(.subheadline).accessibilityIdentifier("errorValidacion")
                    }
                }.padding(18).background(Color.white).cornerRadius(18)
                if let r = resultado { boleta(r) }
                Text("RMV S/ 1,230 · Consulta: 27/10/2026\nModelo académico sin renta de quinta categoría ni bases mínimas de EsSalud.")
                    .font(.caption).foregroundStyle(.secondary)
            }.padding(20).frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
        }.background(Color(red: 0.95, green: 0.96, blue: 0.98))
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: formulario) { _, _ in resultado = nil; error = "" }
    }

    private func campo(_ titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.subheadline).bold()
            TextField("0.00", text: texto).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                .accessibilityLabel(titulo)
        }
    }

    private func fila(_ concepto: Concepto) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(concepto.nombre).frame(maxWidth: .infinity, alignment: .leading)
            Text(concepto.monto.soles).monospacedDigit().multilineTextAlignment(.trailing)
        }.font(.subheadline)
    }

    private func boleta(_ r: ResultadoBoleta) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("REMUNERACIONES").font(.headline).foregroundStyle(tinta)
                fila(r.remuneraciones[0]); fila(r.remuneraciones[1])
                fila(r.remuneraciones[2]); fila(r.remuneraciones[3])
                fila(Concepto(nombre: "Total remuneraciones", monto: r.totalRemuneraciones)).bold()
            }.padding(18).background(Color.white).cornerRadius(18)
            VStack(alignment: .leading, spacing: 12) {
                Text("RETENCIONES / DESCUENTOS").font(.headline).foregroundStyle(tinta)
                fila(r.descuentos[0]); fila(r.descuentos[1]); fila(r.descuentos[2])
                fila(r.descuentos[3]); fila(r.descuentos[4])
                fila(Concepto(nombre: "Total descuentos", monto: r.totalDescuentos)).bold()
            }.padding(18).background(Color.white).cornerRadius(18)
            VStack(alignment: .leading, spacing: 12) {
                Text("APORTACIONES DEL EMPLEADOR").font(.headline).foregroundStyle(tinta)
                fila(r.aportaciones[0])
                Text("Lo paga el empleador. No se resta de tu neto.").font(.caption).foregroundStyle(.secondary)
            }.padding(18).background(Color.white).cornerRadius(18)
            VStack(alignment: .leading, spacing: 8) {
                Text("NETO A PAGAR").font(.headline)
                Text(r.neto.soles).font(.largeTitle).bold().monospacedDigit().accessibilityIdentifier("neto")
                if r.neto < 0 { Text("El adelanto supera el saldo disponible.").font(.caption) }
            }.frame(maxWidth: .infinity, alignment: .leading).padding(20)
                .foregroundStyle(.white).background(tinta).cornerRadius(18)
        }
    }

    private func calcular() {
        resultado = nil
        do { resultado = try Boleta().calcular(formulario.datos()); error = "" }
        catch { self.error = error.localizedDescription }
    }
}
