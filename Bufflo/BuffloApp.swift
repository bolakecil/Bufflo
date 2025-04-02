import SwiftUI
import SwiftData
@main
struct BuffloApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Order.self, OrderItem.self])
    }
}
