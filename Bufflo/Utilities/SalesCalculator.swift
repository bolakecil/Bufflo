//
//  SalesCalculator.swift
//  Bufflo
//
//  Created by Muhammad Azmi on 07/04/25.
//


import Foundation
import SwiftData // If Order/OrderItem are defined here or needed

// Assume Order and OrderItem look something like this (adjust if needed):
/*
@Model
final class Order {
    var date: Date
    @Relationship(deleteRule: .cascade) var items: [OrderItem] = []

    init(date: Date = Date(), items: [OrderItem] = []) {
        self.date = date
        self.items = items
    }
}

@Model
final class OrderItem {
    var name: String
    var price: Int
    var quantity: Int

    init(name: String, price: Int, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
*/


struct SalesCalculator {

    /// Calculates the total income for a specific date from a list of orders.
    static func calculateIncome(for date: Date, orders: [Order]) -> Int {
        let calendar = Calendar.current
        return orders
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { total, order in
                total + orderTotal(order)
            }
    }

    /// Calculates the total income for the current month (last 30 days approx).
    static func calculateIncomeThisMonth(orders: [Order]) -> Int {
        let calendar = Calendar.current
        let now = Date()
        // Use start of the current month for a more accurate "This Month"
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else { return 0 }

        return orders
            .filter { $0.date >= startOfMonth } // Filter from the start of the current month
            .reduce(0) { total, order in
                total + orderTotal(order)
            }
    }
    
    /// Calculates the total income for the last 30 days.
    /// Kept if the original logic of "month ago" is preferred over "current calendar month".
    static func calculateIncomeLast30Days(orders: [Order]) -> Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) else { return 0 } // More precise 30 days

        return orders
            .filter { $0.date >= monthAgo }
            .reduce(0) { total, order in
                total + orderTotal(order)
            }
    }


    /// Calculates the total sales count for a specific date.
    static func calculateSalesCount(for date: Date, orders: [Order]) -> Int {
        let calendar = Calendar.current
        return orders
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .count
    }

    /// Calculates the difference between today's and yesterday's income.
    /// Returns a tuple: (sign: String, amount: Int) where sign is "+" or "-".
    static func calculateIncomeDifferenceFromYesterday(todayIncome: Int, yesterdayIncome: Int) -> (sign: String, amount: Int) {
        let difference = todayIncome - yesterdayIncome
        if difference >= 0 {
            return (sign: "chart.line.uptrend.xyaxis", amount: difference)
        } else {
            return (sign: "chart.line.downtrend.xyaxis", amount: abs(difference))
        }
    }

    /// Calculates the total amount for a single order.
    static func orderTotal(_ order: Order) -> Int {
        order.items.reduce(0) { $0 + ($1.price * $1.quantity) }
    }

    /// Gets yesterday's date.
    static func yesterday() -> Date? {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())
    }
}
