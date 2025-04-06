// BuffloApp.swift
import SwiftUI
import SwiftData

@main
struct BuffloApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Order.self, OrderItem.self)
            let context = container.mainContext
            DataSeeder.seedDataIfNeeded(modelContext: context)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
