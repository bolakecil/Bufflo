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

//    struct Item: Identifiable {
//        let id = UUID()
//        let name: String
//        let price: Int
//        var count: Int //aslinya pake ini tp skrg udh lupa gmn balikinnya heeheehee
//    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Order Summary")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

            ForEach(regularItems, id: \.name) { item in
                let qty = orderQuantities[item.name, default: 0]
                if qty > 0 {
                    HStack {
                        Text("\(item.name) x\(qty)")
                        Spacer()
                        Text("Rp \(item.price * qty)")
                    }
                    .font(.system(size: 20))
                    .padding(.vertical, 2)
                }
            }

            ForEach(additionalItems.filter { $0.count > 0 }) { item in
                HStack {
                    Text("\(item.name) x\(item.count)")
                    Spacer()
                    Text("Rp \(item.price * item.count)")
                }
                .font(.system(size: 20))
                .padding(.vertical, 2)
            }

            Divider().padding(.vertical, 10)

            HStack {
                Text("Total")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Text("Rp \(calculateTotal())")
                    .font(.system(size: 23, weight: .bold))
            }

            Spacer()

            HStack {
                Spacer()
                Button {
                    onConfirm()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue)
                            .frame(width: 200, height: 45)
                        Text("Confirm Order")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding(.top, 30)
        .padding(.horizontal, 40)
        .onAppear {
             print("SalesSummarySheet appeared")
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
