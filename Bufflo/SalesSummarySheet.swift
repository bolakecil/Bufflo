// SalesSummarySheet.swift - RESTORE THE BODY
import SwiftUI

struct SalesSummarySheet: View {
    let orderQuantities: [String: Int]
    let additionalItems: [Item] // Assuming Item struct is defined elsewhere
    let onConfirm: () -> Void

    // Keep your MenuItem definition for price lookup if needed,
    // or better, pass the calculated total directly.
    let regularItems: [MenuItem] = [ // Keep this for easy access to price info
        MenuItem(name: "Nasi", price: 8000, colorMenu: "Sand", colorPicker: "SandPicker"),
        MenuItem(name: "Ayam", price: 11000, colorMenu: "Red", colorPicker: "RedPicker"),
        MenuItem(name: "Ikan", price: 10000, colorMenu: "Blue", colorPicker: "BluePicker"),
        MenuItem(name: "Telor", price: 9000, colorMenu: "Yellow", colorPicker: "YellowPicker"),
        MenuItem(name: "Sayur", price: 5000, colorMenu: "Green", colorPicker: "GreenPicker")
    ]

//    // Define Item struct if not globally available
//    struct Item: Identifiable {
//        let id = UUID()
//        let name: String
//        let price: Int
//        var count: Int // Make sure this matches definition in Calculator
//    }

    var body: some View {
        // --- Use the detailed body ---
        VStack(alignment: .leading) { // Align leading for better readability
            Text("Order Summary")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity) // Center align title
                .padding(.bottom, 20)

            // Regular items
            ForEach(regularItems, id: \.name) { item in
                let qty = orderQuantities[item.name, default: 0]
                if qty > 0 {
                    HStack {
                        Text("\(item.name) x\(qty)")
                        Spacer()
                        Text("Rp \(item.price * qty)")
                    }
                    .font(.system(size: 20)) // Slightly smaller font maybe
                    .padding(.vertical, 2)
                }
            }

            // Additional items
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

            Spacer() // Pushes button to bottom

            HStack { // Center the button
                Spacer()
                Button {
                    print("✅ Confirm button tapped in SalesSummarySheet")
                    onConfirm() // Triggers save/reset in Calculator
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue) // Use standard blue or your custom color
                            .frame(width: 200, height: 45)
                        Text("Confirm Order") // More descriptive text
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                // .buttonStyle(PlainButtonStyle()) // Often not needed unless customizing heavily
                Spacer()
            }
            .padding(.bottom, 20) // Add some padding at the bottom
        }
        .padding(.top, 30)
        .padding(.horizontal, 40) // Adjust padding as needed
        .onAppear {
             print("SalesSummarySheet appeared")
        }
        // You DON'T typically need to pass modelContext here
        // because it only calls onConfirm, which executes in Calculator's context.
    }

    // calculateTotal function remains the same - it calculates based on passed-in state
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

// Preview needs the Item struct definition if it's local
//#Preview {
//    SalesSummarySheet(
//        orderQuantities: ["Nasi": 2, "Ayam": 1],
//        additionalItems: [SalesSummarySheet.Item(name: "Tahu", price: 3000, count: 3)], // Use qualified name if needed
//        onConfirm: { print("Preview Confirmed ✅") }
//    )
//}
