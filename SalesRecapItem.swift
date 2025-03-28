import SwiftUI

struct QuantityItem {
    var color: Color
    var quantity: Int
}

struct SalesRecapItem: View {
    let itemQuantities: [QuantityItem] = [
        QuantityItem(color: .blue, quantity: 15),
        QuantityItem(color: .green.opacity(0.5), quantity: 11),
        QuantityItem(color: .yellow, quantity: 5),
        QuantityItem(color: .orange, quantity: 11)
    ]
    
    // Split quantities into chunks of maximum 2 items
    private var chunks: [[QuantityItem]] {
        var result: [[QuantityItem]] = []
        for i in stride(from: 0, to: itemQuantities.count, by: 2) {
            let end = i + 2
            let chunk = Array(itemQuantities[i..<min(end, itemQuantities.count)])
            result.append(chunk)
        }
        return result
    }
    
    var body: some View {
        VStack {
            // Divider
//            RoundedRectangle(cornerRadius: 100)
//                .fill(Color.gray.opacity(0.5))
//                .frame(width: 320, height: 1)
            
            // Item Recap
            HStack {
                VStack(alignment: .leading) {
                    Text("Rp. 999.999.999")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.itemRecap)
                    
                    Spacer()
                    
                    Text("Senin | 17 Maret 2025")
                        .font(.system(size: 12))
                        .foregroundColor(Color.itemRecap)
                }
                
                Spacer()
                
                // Grouped quantity items
                HStack(alignment: .top, spacing: 16) {
                    ForEach(chunks.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            ForEach(chunks[index], id: \.color) { item in
                                QuantityItemView(item: item)
                            }
                        }
                    }
                }
                .padding(3)
            }
            .padding(20)
            .frame(height: 100)
            // Divider
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 320, height: 1)
        }
    }
}

struct QuantityItemView: View {
    var item: QuantityItem
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(item.color)
                .frame(width: 16, height: 16)
            
            Text("x \(item.quantity)")
                .font(.system(size: 14, weight: .semibold))
        }
    }
}

#Preview {
    SalesRecapItem()
}
