import SwiftUI

// Komen dulu coba pake hasher
// Assume DishDisplayItem is defined as provided:
// struct DishDisplayItem: Identifiable {
//     let id = UUID()
//     let name: String
//     let count: Int
//     let color: Color
// }


struct DishDisplayItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var count: Int // <<< Ubah dari let ke var
    let color: Color

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DishDisplayItem, rhs: DishDisplayItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct Sales: View {
    let items: [DishDisplayItem]
    let total: Int
    let time: Date

    // Define columns for the grid - adaptive might be more flexible
    // let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 8)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                // Left side: Total and Time
                VStack(alignment: .leading) {
                    Text("Rp \(total)")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom, 1)
                    Text("\(time, style: .time) | \(time.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 15)

                Spacer()

                // Right side: Dish Items Grid
                LazyVGrid(columns: columns, alignment: .leading, spacing: 6) {
                    // Display up to 6 items
                    ForEach(items.prefix(6)) { item in
                        HStack(spacing: 5) {
                            Circle()
                                .fill(item.color.opacity(0.8))
                                .frame(width: 10, height: 10)

                            // Display Dish Name and Count
                            Text("\(item.name) x\(item.count)")
                                .font(.system(size: 13, weight: .regular))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
                 .frame(maxWidth: .infinity, alignment: .leading)
                // .frame(maxWidth: 200)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            // Divider below the content
            Divider()
                .padding(.horizontal, 7)
                
        } // End main VStack
        .padding(.horizontal, 17)
    }
}

// MARK: - Preview
#Preview {
    let sampleItems = [
        DishDisplayItem(name: "Nasi", count: 2, color: Color("Sand", default: .orange)),
        DishDisplayItem(name: "Ayam Goreng", count: 1, color: Color("Red", default: .red)),
        DishDisplayItem(name: "Ikan Bakar", count: 1, color: Color("Blue", default: .blue)),
        DishDisplayItem(name: "Telor Dadar", count: 2, color: Color("Yellow", default: .yellow)),
        DishDisplayItem(name: "Sayur Asem", count: 1, color: Color("Green", default: .green)),
        DishDisplayItem(name: "Sambal", count: 3, color: .purple),
        DishDisplayItem(name: "Kerupuk", count: 2, color: .gray) // maksimal 6 harusnya ini gk nampil sih
    ]

    return ScrollView {
        VStack {
             Sales(items: sampleItems, total: 125000, time: Date())
             Sales(items: sampleItems.prefix(3).map { $0 }, total: 55000, time: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!)
             Sales(items: [DishDisplayItem(name: "Nasi", count: 1, color: Color("Sand", default: .orange))], total: 15000, time: Calendar.current.date(byAdding: .hour, value: -4, to: Date())!)
        }
    }

}

extension Color {
    init(_ name: String, default defaultColor: Color) {
        #if DEBUG
        self.init(name, bundle: nil)
        #else
        self.init(name)
        #endif
    }
}
