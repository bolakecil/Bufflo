
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
    
    /// Grup order per hari dengan item yang udah diagregasi
    private var dailyAggregatedGroups: [DailyGroup] {
        SalesCalculator.groupOrdersByDayAndAggregateItems(orders: allOrders)
    }
    
    /// properti untuk grup mingguan yang diagregasi
    private var weeklyAggregatedGroups: [WeeklyGroup] {
        SalesCalculator.groupOrdersByWeekAndAggregateItems(orders: allOrders)
    }

    
    // MARK: - Filtered Orders

    /// Filter order untuk 'Today'
    var filteredOrders: [Order] {
        let calendar = Calendar.current
        let now = Date()
        switch timeRange {
        case "Today":
            return allOrders.filter { calendar.isDate($0.date, inSameDayAs: now) }
        // Daily dan Weekly tidak menggunakan ini untuk daftar utama
        case "Daily", "Weekly":
            return []
        default:
            return allOrders.filter { calendar.isDate($0.date, inSameDayAs: now) }
        }
    }


    // Perbarui helper untuk cek data
    private var shouldShowList: Bool {
        switch timeRange {
        case "Today":
            return !filteredOrders.isEmpty
        case "Daily":
            return !dailyAggregatedGroups.isEmpty
        case "Weekly":
            return !weeklyAggregatedGroups.isEmpty
        default:
            return false
        }
    }
        
    let gridColumns = [GridItem(.adaptive(minimum: 80), spacing: 8)]
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // MARK: Top Summary Card
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.blueHome)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .frame(height: 210)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total Income This Week")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                                                
                        Text("Rp \(calculatedWeeklyIncome)")
                            .font(.system(size: 33, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
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
                                        Label("Rp \(incomeDifferenceFromYesterday.amount)", systemImage: incomeDifferenceFromYesterday.sign)
                                            .font(.system(size: 14, weight: .medium, design: .default))
                                            .foregroundColor(incomeDifferenceFromYesterday.sign == "chart.line.uptrend.xyaxis" ? .green.opacity(0.85) : .red.opacity(0.85))
                                            .labelStyle(.titleAndIcon)
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
                    ForEach(timeRanges, id: \.self) { range in
                        Text(range)
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.segmented)
                
                // MARK: Orders List Area (Conditional Display)
                if !shouldShowList {
                    Spacer()
                    Text("No Sales Data for \(timeRange)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) { // spacing 0 jika divider menangani jarak
                            switch timeRange {
                            case "Today":
                                // Tampilkan daftar order individual
                                ForEach(filteredOrders) { order in
                                    Sales(
                                        items: convertOrderItemsToDishDisplayItems(order.items), // Konversi tetap di sini
                                        total: SalesCalculator.orderTotal(order),
                                        time: order.date
                                    )
                                    // Padding udah diatur di dalam Sales view
                                }

                            case "Daily":
                                // Ini buat tampilan ringkasan harian yang sudah diagregasi
                                ForEach(dailyAggregatedGroups) { dayGroup in
                                    VStack(alignment: .leading, spacing: 8) { // VStack untuk header + grid
                                        // Header Harian
                                        HStack {
                                            VStack(alignment: .trailing){
                                                Text(dayGroup.date, style: .date)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing){
                                                 Text("Rp \(dayGroup.totalIncome)")
                                                      .font(.subheadline)
                                                      .foregroundColor(.black)
                                                  Text("\(dayGroup.salesCount) sales")
                                                     .font(.caption)
                                                     .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.top, 10) // Beri jarak di atas header

                                        // Grid untuk item yang sudah diagregasi
                                        // Gunakan convertOrderItemsToDishDisplayItems di sini jika ingin grouping "Other"
                                        let displayItems = convertOrderItemsToDishDisplayItems(dayGroup.aggregatedItems)

                                        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 8) {
                                            ForEach(displayItems.prefix(6)) { item in // Batasi jika perlu
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(item.color.opacity(0.8))
                                                        .frame(width: 10, height: 10)
                                                    Text("\(item.name) x\(item.count)") // Tampilkan nama dan total count
                                                        .font(.system(size: 13, weight: .regular))
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                }
                                            }
                                            
                                        }
                                        .padding(.horizontal) // Padding untuk grid

                                    } // End VStack Header+Grid
                                    .padding(10)

                                    // Divider antar hari
                                    if dayGroup.id != dailyAggregatedGroups.last?.id { // Jangan tampilkan divider setelah item terakhir
                                        Divider().padding(.horizontal, 17)
                                    }

                                } // End ForEach dailyAggregatedGroups
                            case "Weekly":
                                ForEach(weeklyAggregatedGroups) { weekGroup in
                                     VStack(alignment: .leading, spacing: 8) {
                                         // Header Mingguan
                                         HStack {
                                             // Format tanggal minggu
                                             VStack{
                                                 Text(formatWeekRange(start: weekGroup.startDate, end: weekGroup.endDate))
                                                     .font(.headline)
                                                     .fontWeight(.bold)
                                                 Spacer()
                                             }
                                             Spacer()
                                             VStack(alignment: .trailing){
                                                  Text("Rp \(weekGroup.totalIncome)")
                                                       .font(.subheadline)
                                                       .foregroundColor(.black)
                                                   Text("\(weekGroup.salesCount) sales")
                                                      .font(.caption)
                                                      .foregroundColor(.gray)
                                             }
                                         }
                                         .padding(.horizontal)
                                         .padding(.top, 10)

                                         // Grid Item Mingguan
                                         let displayItemsWeekly = convertOrderItemsToDishDisplayItems(weekGroup.aggregatedItems)
                                         LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 8) {
                                             ForEach(displayItemsWeekly.prefix(9)) { item in // Mungkin bisa tampilkan lebih banyak untuk mingguan?
                                                 HStack(spacing: 5) {
                                                     Circle()
                                                         .fill(item.color.opacity(0.8))
                                                         .frame(width: 10, height: 10)
                                                     Text("\(item.name) x\(item.count)")
                                                         .font(.system(size: 13, weight: .regular))
                                                         .lineLimit(1)
                                                         .truncationMode(.tail)
                                                 }
                                             }
                                         }
                                         .padding(.horizontal)

                                     } // End VStack Header+Grid
                                     .padding(10)

                                     // Divider antar minggu
                                     if weekGroup.id != weeklyAggregatedGroups.last?.id {
                                         Divider().padding(.horizontal, 17)
                                     }
                                } // End ForEach weeklyAggregatedGroups

                            default:
                                EmptyView()
                            }
                        }
                    } // End ScrollView
                } // End if/else for list display
                Spacer()
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

    // Fungsi ini sekarang bisa nerima [OrderItem] atau [DishDisplayItem]
    // klo nerima [DishDisplayItem], dia bakal mengelompokkan item "Other" dari hasil agregasi
    private func convertOrderItemsToDishDisplayItems(_ items: [DishDisplayItem]) -> [DishDisplayItem] {
       var regulars: [DishDisplayItem] = []
       var additionalTotal = 0

       for item in items {
           if isAdditional(item.name) {
               additionalTotal += item.count // Jumlah count dari item "Other"
           } else {
               regulars.append(item)
           }
       }

       if additionalTotal > 0 {
           regulars.append(DishDisplayItem(name: "Other", count: additionalTotal, color: SalesCalculator.colorForDish(name: "Other")))
       }
       // Urutin klo perlu setelah nambahin "Other"
       return regulars.sorted { $0.name < $1.name }
    }
    
    // Helper untuk format rentang minggu
    private func formatWeekRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // Format: Apr 7

        // Cek jika minggu berada dalam bulan & tahun yang sama
        let calendar = Calendar.current
        if calendar.isDate(start, equalTo: end, toGranularity: .month) &&
           calendar.isDate(start, equalTo: end, toGranularity: .year) {
            // Hanya tampilkan bulan sekali jika sama
            let endFormatter = DateFormatter()
            endFormatter.dateFormat = "d, yyyy" // Format: 13, 2025
            return "\(formatter.string(from: start)) - \(endFormatter.string(from: end))" // Contoh: Apr 7 - 13, 2025
        } else {
            // Tampilkan bulan & tahun lengkap jika berbeda
            formatter.dateFormat = "MMM d, yyyy" // Format: Apr 7, 2025
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))" // Contoh: Dec 29, 2024 - Jan 4, 2025
        }
    }

    // Overload untuk tipe [OrderItem] (buat Today/ sementar buat Weekly blm jadi soalnya hehe)
    private func convertOrderItemsToDishDisplayItems(_ orderItems: [OrderItem]) -> [DishDisplayItem] {
        var regulars: [DishDisplayItem] = []
        var additionalTotal = 0

        for item in orderItems {
            if isAdditional(item.name) {
                additionalTotal += item.quantity
            } else {
                regulars.append(
                    DishDisplayItem(name: item.name, count: item.quantity, color: SalesCalculator.colorForDish(name: item.name))
                )
            }
        }

        if additionalTotal > 0 {
            regulars.append(DishDisplayItem(name: "Other", count: additionalTotal, color: SalesCalculator.colorForDish(name: "Other")))
        }
        return regulars.sorted { $0.name < $1.name }
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
