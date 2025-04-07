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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Rp \(total)")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 2)
                Text("\(time, style: .time) | \(time, style: .date)")
                    .font(.system(size: 15, weight: .regular))
            }
            .padding(.trailing, 20)
            let columns =  Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
            Spacer()
            LazyVGrid(columns: columns, alignment: .leading, spacing: 6) {
                ForEach(items.prefix(6)) { item in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)
                        Text("x\(item.count)")
                            .font(.system(size: 15, weight: .regular))
                    }
                }
            }
        }
        .padding(.leading, 25)
        .padding(.top, 10)
        Divider()
            .padding(.top, 5)
            .padding(.horizontal, 17)
    }
}
