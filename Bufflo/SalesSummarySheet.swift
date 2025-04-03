import SwiftUI

struct SalesSummarySheet: View {
    let orderQuantities: [String: Int]
    let additionalItems: [Item]
    let onConfirm: () -> Void

    let regularItems: [MenuItem] = [
        MenuItem(name: "Nasi", price: 8000, colorMenu: "Sand", colorPicker: "SandPicker"),
        MenuItem(name: "Ayam", price: 11000, colorMenu: "Red", colorPicker: "RedPicker"),
        MenuItem(name: "Ikan", price: 10000, colorMenu: "Blue", colorPicker: "BluePicker"),
        MenuItem(name: "Telor", price: 9000, colorMenu: "Yellow", colorPicker: "YellowPicker"),
        MenuItem(name: "Sayur", price: 5000, colorMenu: "Green", colorPicker: "GreenPicker")
    ]

//    var body: some View {
//        VStack {
//            Text("Order Summary")
//                .font(.system(size: 28, weight: .bold))
//                .padding(.bottom, 20)
//
//            // Regular items
//            ForEach(regularItems, id: \.name) { item in
//                let qty = orderQuantities[item.name, default: 0]
//                if qty > 0 {
//                    HStack {
//                        Text("\(item.name) x\(qty)")
//                        Spacer()
//                        Text("Rp \(item.price * qty)")
//                    }
//                    .font(.system(size: 22))
//                    .padding(.vertical, 3)
//                }
//            }
//
//            // Additional items
//            ForEach(additionalItems.filter { $0.count > 0 }) { item in
//                HStack {
//                    Text("\(item.name) x\(item.count)")
//                    Spacer()
//                    Text("Rp \(item.price * item.count)")
//                }
//                .font(.system(size: 22))
//                .padding(.vertical, 3)
//            }
//
//            Divider().padding(.vertical, 5)
//
//            HStack {
//                Text("Total")
//                    .font(.system(size: 18, weight: .medium))
//                Spacer()
//                Text("Rp \(calculateTotal())")
//                    .font(.system(size: 23, weight: .bold))
//            }
//
//            Spacer()
//
//            Button {
//                print("🔥 Button tapped in SalesSummarySheet")
//                onConfirm()
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundStyle(.blue)
//                        .frame(width: 200, height: 45)
//                    Text("Confirm")
//                        .font(.system(size: 19, weight: .bold))
//                        .foregroundColor(.white)
//                }
//            }
//            .buttonStyle(PlainButtonStyle())
//            .padding(.top, 10)
//        }
//        .padding(.top, 30)
//        .padding(.horizontal, 50)
//        .onAppear {
//            print("Sheet loaded")
//        }
//    }
    
    var body: some View {
        VStack {
            Text("Order Summary")

            Button("Confirm Test") {
                print("✅ Button tapped")
                onConfirm()
            }
        }
    }


    func calculateTotal() -> Int {
        let regularTotal = regularItems.reduce(0) {
            $0 + (orderQuantities[$1.name, default: 0] * $1.price)
        }

        let additionalTotal = additionalItems.reduce(0) {
            $0 + ($1.price * $1.count)
        }

        return regularTotal + additionalTotal
    }
}


#Preview {
    SalesSummarySheet(
        orderQuantities: ["Nasi": 2, "Ayam": 1],
        additionalItems: [Item(name: "Tahu", price: 3000, count: 3)],
        onConfirm: { print("Confirmed ✅") }
    )
}
