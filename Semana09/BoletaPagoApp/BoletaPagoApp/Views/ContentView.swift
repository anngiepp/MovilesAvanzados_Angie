import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Boleta de ejemplo").font(.largeTitle).bold()
            Text("Del sueldo al neto").foregroundStyle(.secondary)
        }.padding()
    }
}
