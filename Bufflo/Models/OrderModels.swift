import Foundation
import SwiftData

@Model
class Order {
    var id: UUID
    var date: Date
    var items: [OrderItem]
    
    init(id: UUID = .init(), date: Date = Date(), items: [OrderItem] = []) {
        self.id = id
        self.date = date
        self.items = items
    }
}

@Model
class OrderItem {
    var name: String
    var price: Int
    var quantity: Int
    
    init(name: String, price: Int, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
