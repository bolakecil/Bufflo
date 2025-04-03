import SwiftUI

struct DishDisplayItem: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let color: Color
}

struct Sales: View {
    let items: [DishDisplayItem]
    let total: Int
    let time: Date


    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Rp \(total)")
                Text("\(time, style: .time) | \(time, style: .date)")
            }
            let columns =  Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(items.prefix(6)) { item in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 10, height: 10)
                        Text("x\(item.count)")
                            .font(.caption)
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    Sales(items: dishItems, total: calculatedTotal, timestamp: order.date)
//}
