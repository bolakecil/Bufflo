import Foundation
import SwiftUI
import SwiftData

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

// MARK: - Struct untuk Grup Harian
struct DailyGroup: Identifiable {
    let id: Date // Start of day
    let date: Date
    var aggregatedItems: [DishDisplayItem] // Item yang sudah ditotal per hari
    var totalIncome: Int // Total pendapatan hari itu
    var salesCount: Int // Jumlah order hari itu
}

// MARK: - Struct untuk Grup Mingguan
struct WeeklyGroup: Identifiable {
    let id: Date // Start of week date sebagai ID unik
    let startDate: Date // Tanggal mulai minggu
    let endDate: Date // Tanggal akhir minggu (untuk display)
    var aggregatedItems: [DishDisplayItem] // Item yang sudah ditotal per minggu
    var totalIncome: Int // Total pendapatan minggu itu
    var salesCount: Int // Jumlah order minggu itu
}


struct SalesCalculator {

//    static func groupOrdersByDay(orders: [Order]) -> [DailyGroup] {
//        let calendar = Calendar.current
//
//        // Use Dictionary(grouping:by:) for efficient grouping
//        let groupedByDay = Dictionary(grouping: orders) { order -> Date in
//            // Normalize the date to the start of the day for consistent grouping
//            return calendar.startOfDay(for: order.date)
//        }
//
//        // Convert the dictionary into an array of DailyGroup structs
//        // and sort by date descending (most recent first)
//        let dailyGroups = groupedByDay.map { (date, ordersForDay) -> DailyGroup in
//            DailyGroup(id: date, date: date, orders: ordersForDay)
//        }.sorted { $0.date > $1.date } // Sort most recent day first
//
//        return dailyGroups
//    }
        
    static func colorForDish(name: String) -> Color {
         switch name {
             case "Nasi": return Color("Sand", default: .orange)
             case "Ayam": return Color("Red", default: .red)
             case "Ikan": return Color("Blue", default: .blue)
             case "Telor": return Color("Yellow", default: .yellow)
             case "Sayur": return Color("Green", default: .green)
             case "Other": return .purple
             default: return .gray
         }
     }
    
    /// Grup order per minggu kalender dan hitung total item per minggu.
        static func groupOrdersByWeekAndAggregateItems(orders: [Order]) -> [WeeklyGroup] {
            let calendar = Calendar.current // Gunakan locale yang sesuai jika perlu

            // 1. Grup order berdasarkan tanggal mulai minggu kalender
            let groupedByWeekStartDate = Dictionary(grouping: orders) { order -> Date in
                // Dapatkan interval minggu untuk tanggal order
                guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: order.date) else {
                    return calendar.startOfDay(for: order.date)
                }
                return weekInterval.start // Gunakan tanggal mulai minggu sebagai key
            }

            // 2. Proses setiap grup mingguan untuk agregasi item
            let weeklyAggregatedGroups = groupedByWeekStartDate.map { (weekStartDate, ordersForWeek) -> WeeklyGroup in

                // Hitung total income dan sales count untuk minggu ini
                let weeklyTotalIncome = ordersForWeek.reduce(0) { $0 + orderTotal($1) }
                let weeklySalesCount = ordersForWeek.count

                // Agregasi item (logika sama seperti harian)
                var itemTotals = [String: DishDisplayItem]() // Key: Nama item

                for order in ordersForWeek {
                    for item in order.items {
                        let name = item.name
                        let quantity = item.quantity
                        let color = colorForDish(name: name)

                        if var existingItem = itemTotals[name] {
                            existingItem.count += quantity
                            itemTotals[name] = existingItem
                        } else {
                            itemTotals[name] = DishDisplayItem(name: name, count: quantity, color: color)
                        }
                    }
                }
                
                // Konversi dictionary kembali ke array dan urutkan
                let aggregatedItemsArray = Array(itemTotals.values).sorted { $0.name < $1.name }
                
                // Dapatkan tanggal akhir minggu untuk display
                // (Hati-hati: end date dari dateInterval adalah awal dari interval berikutnya)
                let endDate: Date
                if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: weekStartDate),
                   let calculatedEndDate = calendar.date(byAdding: .day, value: -1, to: weekInterval.end) {
                    endDate = calculatedEndDate
                } else {
                    // Fallback jika interval tidak ditemukan lagi
                    endDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate) ?? weekStartDate // Default: tambah 6 hari
                }


                // Buat instance WeeklyGroup
                return WeeklyGroup(id: weekStartDate,
                                   startDate: weekStartDate,
                                   endDate: endDate,
                                   aggregatedItems: aggregatedItemsArray,
                                   totalIncome: weeklyTotalIncome,
                                   salesCount: weeklySalesCount)

            }.sorted { $0.startDate > $1.startDate } // Urutkan grup berdasarkan minggu (terbaru dulu)

            return weeklyAggregatedGroups
        }
    /// Grup order per hari dan hitung total item per hari.
       static func groupOrdersByDayAndAggregateItems(orders: [Order]) -> [DailyGroup] {
           let calendar = Calendar.current
           
           let groupedByDay = Dictionary(grouping: orders) { order -> Date in
               return calendar.startOfDay(for: order.date)
           }
           
           let dailyAggregatedGroups = groupedByDay.map { (dayStartDate, ordersForDay) -> DailyGroup in

               // Hitung total income dan sales count untuk hari ini
               let dailyTotalIncome = ordersForDay.reduce(0) { $0 + orderTotal($1) }
               let dailySalesCount = ordersForDay.count

               // Agregasi item
               var itemTotals = [String: DishDisplayItem]() // Key: Nama item

               for order in ordersForDay {
                   for item in order.items {
                       let name = item.name
                       let quantity = item.quantity
                       let color = colorForDish(name: name)

                       if var existingItem = itemTotals[name] {
                           // klo item dah ada, count
                           existingItem.count += quantity
                           itemTotals[name] = existingItem
                       } else {
                           // klo item baru, tambahin ke dictionary
                           itemTotals[name] = DishDisplayItem(name: name, count: quantity, color: color)
                       }
                   }
               }

               // Konversi dictionary kembali ke array dan urutkan
               let aggregatedItemsArray = Array(itemTotals.values).sorted { $0.name < $1.name }

               // Buat instance DailyGroup dengan item yg udah diagregasi
               return DailyGroup(id: dayStartDate,
                                 date: dayStartDate,
                                 aggregatedItems: aggregatedItemsArray,
                                 totalIncome: dailyTotalIncome,
                                 salesCount: dailySalesCount)

           }.sorted { $0.date > $1.date } // Urutkan grup berdasarkan hari (yg paling baru)

       return dailyAggregatedGroups
    }
    
    static func orderTotal(_ order: Order) -> Int {
        order.items.reduce(0) { $0 + ($1.price * $1.quantity) }
    }

    
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
        guard let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) else { return 0 }

        return orders
            .filter { $0.date >= monthAgo }
            .reduce(0) { total, order in
                total + orderTotal(order)
            }
    }


    /// Calculates the total income for this weeks.
    static func calculateIncomeThisWeek(orders: [Order]) -> Int {
        let calendar = Calendar.current
        let now = Date()
        // Get the date interval (start and end) of the week containing 'now'
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
            print("Error: Could not determine the current week interval.")
            return 0
        }
        let startOfWeek = weekInterval.start

        return orders
            // Filter orders that fall on or after the start of this week
            .filter { $0.date >= startOfWeek }
            // Optionally, you could add && $0.date < weekInterval.end if needed,
            // but usually filtering from the start is sufficient for "this week".
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
    
    
    /// Helper to get the start of the current calendar week
    static func startOfCurrentWeek() -> Date? {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
            return nil
        }
        return weekInterval.start
    }


//    /// Calculates the total amount for a single order.
//    static func orderTotal(_ order: Order) -> Int {
//        order.items.reduce(0) { $0 + ($1.price * $1.quantity) }
//    }

    /// Gets yesterday's date.
    static func yesterday() -> Date? {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())
    }
    
    
}
