
import SwiftUI
import SwiftData

@Query(sort: \Order.date, order: .reverse) private var allOrders: [Order]


struct SalesRecap: View {
    // Use the query specific to this view instance
    @Query(sort: \Order.date, order: .reverse) private var allOrders: [Order]
    
    @State private var timeOfDay: String = "Morning"
    @State private var timeRange: String = "Today" // Default selection
    // Update the time range options
    private var timeRanges = ["Today", "Daily", "Weekly"]

    // MARK: - Calculated Properties using SalesCalculator

    // Use the corrected weekly income calculation
    private var calculatedWeeklyIncome: Int {
        SalesCalculator.calculateIncomeThisWeek(orders: allOrders)
    }

    // Keep Today's calculation
    private var calculatedTodayIncome: Int {
        SalesCalculator.calculateIncome(for: Date(), orders: allOrders)
    }

    // Keep Yesterday's calculation
    private var calculatedYesterdayIncome: Int {
        guard let yesterday = SalesCalculator.yesterday() else { return 0 }
        return SalesCalculator.calculateIncome(for: yesterday, orders: allOrders)
    }

    // Keep Today's Sales Count
    private var calculatedTodaySalesCount: Int {
        SalesCalculator.calculateSalesCount(for: Date(), orders: allOrders)
    }

    // Keep Income Difference calculation
    private var incomeDifferenceFromYesterday: (sign: String, amount: Int) {
        SalesCalculator.calculateIncomeDifferenceFromYesterday(
            todayIncome: calculatedTodayIncome,
            yesterdayIncome: calculatedYesterdayIncome
        )
    }
    
    // Groups all orders by day for the "Daily" view.
    private var dailyGroupedOrders: [DailyGroup] {
        SalesCalculator.groupOrdersByDay(orders: allOrders)
    }
    
    
    // MARK: - Filtered Orders

    var filteredOrders: [Order] {
       let calendar = Calendar.current
       let now = Date()

        switch timeRange {
        case "Today":
            return allOrders.filter { calendar.isDate($0.date, inSameDayAs: now) }
        case "Weekly":
            guard let startOfWeek = SalesCalculator.startOfCurrentWeek() else { return [] }
            return allOrders.filter { $0.date >= startOfWeek }
        case "Daily":
            // For "Daily", we use `dailyGroupedOrders`, so this property isn't directly used for the list.
            // Return an empty array or `allOrders` if needed for other logic, but the list uses the grouped data.
            return [] // Or return allOrders if some other part depends on it, but the list won't use it like this.
        default:
            return allOrders.filter { calendar.isDate($0.date, inSameDayAs: now) }
        }
    }

    // Helper to determine if the list should be shown based on the selected range
    private var shouldShowList: Bool {
        switch timeRange {
        case "Today", "Weekly":
            return !filteredOrders.isEmpty
        case "Daily":
            return !dailyGroupedOrders.isEmpty
        default:
            return false
        }
    }
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // MARK: Top Summary Card
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.blueHome) // Ensure .blueHome is defined
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .frame(height: 210) // Consider making height dynamic if content varies

                    VStack(alignment: .leading, spacing: 10) {
                        // Title changed to Weekly
                        HStack {
                            Text("Total Income This Week")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        // Value changed to calculatedWeeklyIncome
                        Text("Rp \(calculatedWeeklyIncome)")
                            .font(.system(size: 33, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                        // Daily Summary (Today vs Yesterday) - Remains the same
                        VStack(spacing: 5){
                            HStack{
                                Text("Today's Income")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                                Text("Today's Sales")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            HStack{
                                HStack(alignment: .lastTextBaseline, spacing: 5){
                                    Text("Rp \(calculatedTodayIncome)")
                                        .font(.system(size: 17, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                    
                                    // Display Difference from Yesterday using Label
                                    if calculatedYesterdayIncome > 0 || calculatedTodayIncome > 0 {
                                        Label("Rp \(incomeDifferenceFromYesterday.amount)", systemImage: incomeDifferenceFromYesterday.sign) // Use the symbol name directly
                                            .font(.system(size: 14, weight: .medium, design: .default))
                                            .foregroundColor(incomeDifferenceFromYesterday.sign == "chart.line.uptrend.xyaxis" ? .green.opacity(0.85) : .red.opacity(0.85)) // Color based on symbol
                                            .labelStyle(.titleAndIcon) // Ensure icon is shown
                                    }
                                }
                                Spacer()
                                Text("\(calculatedTodaySalesCount)")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 38)
                    .padding(.bottom, 10)
                }

                // MARK: Time Range Picker
                Picker("Time Range", selection: $timeRange) {
                    // Use the updated timeRanges array
                    ForEach(timeRanges, id: \.self) { range in
                        Text(range)
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.segmented)
                
                // MARK: Orders List Area (Conditional Display)
                if !shouldShowList {
                    // Display "No Data" message if relevant list is empty
                    Spacer()
                    Text("No Sales Data for \(timeRange)")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    // Display the appropriate list based on timeRange
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) { // Added spacing between days/items
                            switch timeRange {
                            case "Today", "Weekly":
                                // Display flat list for Today and Weekly
                                ForEach(filteredOrders) { order in
                                    Sales(
                                        items: convertOrderItemsToDishDisplayItems(order.items),
                                        total: SalesCalculator.orderTotal(order),
                                        time: order.date
                                    )
                                    .padding(.horizontal)
                                }
                                
                            case "Daily":
                                // Display grouped list for Daily
                                ForEach(dailyGroupedOrders) { dayGroup in
                                    Section {
                                        ForEach(dayGroup.orders) { order in
                                            Sales(
                                                items: convertOrderItemsToDishDisplayItems(order.items),
                                                total: SalesCalculator.orderTotal(order),
                                                time: order.date // Show individual order time
                                            )
                                            .padding(.horizontal)
                                        }
                                    } header: {
                                        // Header for each day group
                                        HStack {
                                            Text(dayGroup.date, style: .date) // Format date nicely (e.g., "April 9, 2025")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                            Spacer()
                                            // Optionally show daily total/count in header
                                            VStack(alignment: .trailing){
                                                 Text("Rp \(dayGroup.totalIncome)")
                                                      .font(.subheadline)
                                                      .foregroundColor(.secondary)
                                                  Text("\(dayGroup.salesCount) sales")
                                                     .font(.caption)
                                                     .foregroundColor(.gray)
                                            }
                                             
                                        }
                                        .padding(.horizontal)
                                        .padding(.top, 10) // Add padding above headers
                                    }
                                } // End ForEach dailyGroupedOrders

                            default:
                                // Should not happen
                                EmptyView()
                            }
                        }
                        .padding(.top, 5) // Reduce top padding for ScrollView content
                    } // End ScrollView
                } // End if/else for list display
                Spacer() // Pushes content up if list is short
            }
            .navigationTitle("Good \(timeOfDay)")
            .navigationBarBackButtonHidden(true)
            .onAppear {
                timeOfDay = updateTimeOfDay()
                // print("Orders fetched: \(allOrders.count)") // Optional debug
            }
        }
    }
    
    func updateTimeOfDay() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        let hour = components.hour ?? 0

        if hour >= 0 && hour < 12 {
            return "Morning"
        } else if hour >= 12 && hour < 16 {
            return "Afternoon"
        } else {
            return "Evening"
        }
        
    }

    func convertOrderItemsToDishDisplayItems(_ orderItems: [OrderItem]) -> [DishDisplayItem] {
        var regulars: [DishDisplayItem] = []
        var additionalTotal = 0

        for item in orderItems {
            if isAdditional(item.name) {
                additionalTotal += item.quantity
            } else {
                regulars.append(
                    DishDisplayItem(name: item.name, count: item.quantity, color: colorForDish(name: item.name))
                )
            }
        }

        if additionalTotal > 0 {
            regulars.append(DishDisplayItem(name: "Other", count: additionalTotal, color: .purple))
        }

        return regulars
    }

    func isAdditional(_ name: String) -> Bool {
        let regularDishNames = ["Nasi", "Ayam", "Ikan", "Telor", "Sayur"]
        return !regularDishNames.contains(name)
    }

    func colorForDish(name: String) -> Color {
        switch name {
        case "Nasi": return Color("Sand")
        case "Ayam": return Color("Red")
        case "Ikan": return Color("Blue")
        case "Telor": return Color("Yellow")
        case "Sayur": return Color("Green")
        default: return .purple 
        }
    }
    
    
}

#Preview {
    SalesRecap()
}
