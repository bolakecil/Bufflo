import SwiftUI
import SwiftData
import Foundation

struct MenuItem {
    let name: String
    let price: Int
    let colorMenu: String
    let colorPicker: String
}

struct Calculator: View {
    let rows = [GridItem(.fixed(2)), GridItem(.fixed(2))] //idk why this is 2
    @State private var navigate: Bool = false
    @State private var orderQuantities: [String: Int] = [:] //this is called a dictionary
    @State private var showSummarySheet: Bool = false
    let nasi = MenuItem(name: "Nasi", price: 8000, colorMenu: "Sand", colorPicker: "SandPicker")
    let ayam = MenuItem(name: "Ayam", price: 11000, colorMenu: "Red", colorPicker: "RedPicker")
    let ikan = MenuItem(name: "Ikan", price: 10000, colorMenu: "Blue", colorPicker: "BluePicker")
    let telor = MenuItem(name: "Telor", price: 9000, colorMenu: "Yellow", colorPicker: "YellowPicker")
    let sayur = MenuItem(name: "Sayur", price: 5000, colorMenu: "Green", colorPicker: "GreenPicker")
    var total: Int = 0
    @State var additionalItems: [Item] = [
        Item(name: "Tahu", price: 3000, count: 0),
        Item(name: "Tempe", price: 3000, count: 0),
        Item(name: "Bala-Bala", price: 2000, count: 0),
        Item(name: "Bihun Goreng", price: 5000, count: 0),
        Item(name: "Mie Goreng", price: 5000, count: 0),
        Item(name: "Bakso", price: 3500, count: 0),
        Item(name: "Rolade", price: 4000, count: 0),
    ]

    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Grid {
                    GridRow {
                        ButtonView(item: nasi, qty: binding(for: "Nasi"))
                        ButtonView(item: ayam, qty: binding(for: "Ayam"))
                    }
                    GridRow {
                        ButtonView(item: ikan, qty: binding(for: "Ikan"))
                        ButtonView(item: telor, qty: binding(for: "Telor"))
                    }
                    GridRow {
                        ButtonView(item: sayur, qty: binding(for: "Sayur"))
                        Button {
                            navigate = true
                        } label: {
                            LainnyaButton()
                        }
                        NavigationLink(
                            isActive: $navigate,
                            destination: {
                                OtherMenu(items: $additionalItems)
                            },
                            label: {
                                EmptyView()
                            }
                        )


                    }
                }
                .padding(.top, 12)
            }
            .navigationTitle(Text("Calculator"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleTextColor(.darkBlue)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(width: 300, height: 3)
                .padding(.top, 10)
            HStack() {
                Text("Total")
                    .font(.system(size: 22, weight: .none, design: .default))
                Spacer()
                Text("Rp \(countTotalPrice())")
                    .font(.system(size: 32, weight: .bold, design: .default))
            }
            .padding(.horizontal, 50)
            Button(
                action: {
                    showSummarySheet = true
                }
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.blue)
                        .frame(width: 200, height: 45)
                    Text("Confirm")
                        .font(.system(size: 19, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
                .padding(.top, -5)
            }

            Spacer()
        }
        .sheet(isPresented: $showSummarySheet) {
            SalesSummarySheet(
                orderQuantities: orderQuantities,
                additionalItems: additionalItems,
                onConfirm: {
                    print("Tapped confirm")
                    saveOrder()
                    resetOrder()
                    showSummarySheet = false
                }
            )
            .environment(\.modelContext, modelContext)
        }
    }
    func binding(for key: String) -> Binding<Int> {
        return Binding(
            get: { orderQuantities[key, default: 0] },
            set: { orderQuantities[key] = $0 }
        )
    }
    //help wtf
    //gpt said it manually tells compiler abt binding bcs swift cant figure out type from nested expression (inside GridRow)
    
    func countAdditionalTotal() -> Int {
        additionalItems.reduce(0) { total, item in
            total + (item.price * item.count)
        }
    }

    func countTotalPrice() -> Int {
        let nasiTotal = orderQuantities["Nasi", default: 0] * nasi.price
        let ayamTotal = orderQuantities["Ayam", default: 0] * ayam.price
        let ikanTotal = orderQuantities["Ikan", default: 0] * ikan.price
        let telorTotal = orderQuantities["Telor", default: 0] * telor.price
        let sayurTotal = orderQuantities["Sayur", default: 0] * sayur.price
        let additionalTotal = countAdditionalTotal()
        return nasiTotal + ayamTotal + ikanTotal + telorTotal + sayurTotal + additionalTotal
    } //ya ini manual, im tired
    
    func saveOrder() -> Void {
        var orderItems: [OrderItem] = []
        
        //regular item
        for menu in [nasi, ayam, ikan, telor, sayur] {
            let qty = orderQuantities[menu.name, default: 0]
            if qty > 0 {
                orderItems.append(OrderItem(name: menu.name, price: menu.price, quantity: qty))
            }
        }
        //additional
        for item in additionalItems where item.count > 0 {
            orderItems.append(OrderItem(name: item.name, price: item.price, quantity: item.count))
        }
        
        let order = Order(items: orderItems)
        modelContext.insert(order)
        
        do {
            try modelContext.save()
            print( "Order saved successfully!" )
        } catch {
            print("Failed to save order: \(error)")
        }
    }
    
    func resetOrder() -> Void {
        orderQuantities = [:] //reset regular
        for index in additionalItems.indices {
            additionalItems[index].count = 0
        } //according to gpt, swiftui allows modifying items in struct using .indices
        
    }
    
    
}

#Preview {
    ContentView()
}
