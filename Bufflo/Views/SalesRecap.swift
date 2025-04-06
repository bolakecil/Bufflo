
import SwiftUI
import SwiftData

@Query(sort: \Order.date, order: .reverse) private var allOrders: [Order]


struct SalesRecap: View {
    @Query(sort: \Order.date, order: .reverse) private var allOrders: [Order]
    @State private var timeOfDay: String = "Morning"
    @State private var timeRange: String = "Today"
    private var timeRanges = ["Today", "This Week", "This Month"]

    private var calculatedTotalIncomeThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return 0 }

        return allOrders
            .filter { $0.date >= monthAgo }
            .reduce(0) { total, order in
                total + order.items.reduce(0) { $0 + ($1.price * $1.quantity) }
            }
    }

    private var calculatedTodayIncome: Int {
        let calendar = Calendar.current
        return allOrders
            .filter { calendar.isDateInToday($0.date) }
            .reduce(0) { total, order in
                total + order.items.reduce(0) { $0 + ($1.price * $1.quantity) }
            }
    }

    private var calculatedTodaySalesCount: Int {
        let calendar = Calendar.current
        return allOrders
            .filter { calendar.isDateInToday($0.date) }
            .count
    }
    
    var filteredOrders: [Order] {
        let calendar = Calendar.current
        let now = Date()

        switch timeRange {
            case "Today":
                return allOrders.filter { calendar.isDateInToday($0.date) }
            case "This Week":
                guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
                return allOrders.filter { $0.date >= weekAgo }
            case "This Month":
                guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return [] }
                return allOrders.filter { $0.date >= monthAgo }
            default:
                return allOrders
            }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.blueHome)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .frame(height: 210)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total Income This Month")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        Text("Rp \(calculatedTotalIncomeThisMonth)")
                            .font(.system(size: 33, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        VStack{
                            HStack{
                                Text("Today's Income")
                                    .font(.system(size: 15, weight: .none, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Today's Sales")
                                    .font(.system(size: 15, weight: .none, design: .default))
                                    .foregroundColor(.white)
                            }
                            HStack{
                                Text("Rp \(calculatedTodayIncome)")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(calculatedTodaySalesCount)")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                        }
                    }.padding(.horizontal, 38)

                }
                Picker("Time Range", selection: $timeRange) {
                    ForEach(timeRanges, id: \.self) {
                        Text($0)
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.segmented)
                
                if filteredOrders.isEmpty{
                    Text("No Data")
                        .font(.system(size: 22, weight: .medium, design: .default))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 160)
                } else {
                    ScrollView{
                        VStack(alignment: .leading, spacing: 10){
                            ForEach(filteredOrders){ order in
                                Sales(
                                    items: convertOrderItemsToDishDisplayItems(order.items),
                                    total: order.items.reduce(0) { $0 + $1.price * $1.quantity },
                                    time: order.date
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Good \(timeOfDay)")
            .navigationBarBackButtonHidden(true)
            .onAppear {
                timeOfDay = updateTimeOfDay()
                print("Orders fetched: \(allOrders.count)")
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
