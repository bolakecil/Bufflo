//
//  DataSeeder.swift
//  Bufflo
//
//  Created by Muhammad Azmi on 06/04/25.
//

import Foundation
import SwiftData

struct DataSeeder {
    
    private static let hasSeededKey = "isDataSeeded_v1"

    static func seedDataIfNeeded(modelContext: ModelContext) {
        if UserDefaults.standard.bool(forKey: hasSeededKey) {
            print("🌱 Data seeding previously completed. Skipping.")
            return
        }

        print("🌱 Starting data seeding...")

        let calendar = Calendar.current
        let endDateComponents = DateComponents(year: 2025, month: 4, day: 4, hour: 12) // April 4, 2025, noon
        guard let endDate = calendar.date(from: endDateComponents) else {
            print("❌ Error creating end date for seeding.")
            return
        }
        
        guard let startDate = calendar.date(byAdding: .day, value: -31, to: endDate) else {
            print("❌ Error creating start date for seeding.")
            return
        }
        let dateInterval = endDate.timeIntervalSince(startDate)

        // Generate 35 Sample Orders
        var ordersToInsert: [Order] = []
        for i in 1...35 {
            let randomInterval = TimeInterval.random(in: 0..<dateInterval)
            let randomDate = startDate.addingTimeInterval(randomInterval)
            
            var orderItems: [OrderItem] = []
            let numberOfItemTypes = Int.random(in: 1...5)
            let selectedMenuItems = availableMenuItems.shuffled().prefix(numberOfItemTypes)

            for menuItem in selectedMenuItems {
                let quantity = Int.random(in: 1...3)
                let orderItem = OrderItem(name: menuItem.name, price: menuItem.price, quantity: quantity)
                orderItems.append(orderItem)
            }

            if !orderItems.isEmpty {
                let newOrder = Order(date: randomDate, items: orderItems)
                ordersToInsert.append(newOrder)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                let formattedDateString = dateFormatter.string(from: randomDate)
                print("   - Generated Order \(i) with \(orderItems.count) item types for date \(formattedDateString)")
            } else {
                 print("   - Skipped Order \(i) generation (no items selected)")
            }
        }
        print("🌱 Inserting \(ordersToInsert.count) generated orders...")
        for order in ordersToInsert {
            modelContext.insert(order)
        }
        do {
            try modelContext.save()
            print("✅ Data seeding successful!")
            UserDefaults.standard.set(true, forKey: hasSeededKey)
        } catch {
            print("❌ Failed to save seeded data: \(error)")
        }
    }

    static func resetSeedingFlag() {
        UserDefaults.standard.removeObject(forKey: hasSeededKey)
        print("🚩 Seeding flag reset. Seeding will occur on next launch if needed.")
    }
}
