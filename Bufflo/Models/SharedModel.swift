
import Foundation
import SwiftUI // For Color if needed, but maybe not for seeding logic itself

// Use the existing MenuItem struct if defined globally, or define a simple one for seeding
struct SeedMenuItem {
    let name: String
    let price: Int
}

// Central list of items the seeder can pick from
let availableMenuItems: [SeedMenuItem] = [
    SeedMenuItem(name: "Nasi", price: 8000),
    SeedMenuItem(name: "Ayam", price: 11000),
    SeedMenuItem(name: "Ikan", price: 10000),
    SeedMenuItem(name: "Telor", price: 9000),
    SeedMenuItem(name: "Sayur", price: 5000),
    SeedMenuItem(name: "Tahu", price: 3000),
    SeedMenuItem(name: "Tempe", price: 3000),
    SeedMenuItem(name: "Bala-Bala", price: 2000),
    SeedMenuItem(name: "Bihun Goreng", price: 5000),
    SeedMenuItem(name: "Mie Goreng", price: 5000),
    SeedMenuItem(name: "Bakso", price: 3500),
    SeedMenuItem(name: "Rolade", price: 4000),
    // Add any other items you want in sample orders
]
