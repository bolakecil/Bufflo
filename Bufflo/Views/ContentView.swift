import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var needsVerification = true

    var body: some View {
        NavigationStack {
            Calculator(needsVerification: $needsVerification)
        }
    }
}
#Preview {
    ContentView()
}