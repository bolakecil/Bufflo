import SwiftUI
import SwiftData

struct Calculator: View {
    let rows = [GridItem(.fixed(2)), GridItem(.fixed(2))]

    var body: some View {
        NavigationStack {
            VStack {
                Grid {
                    GridRow {
                        ButtonView(colorMenu: "Sand", colorPicker: "SandPicker", menu: "Nasi", price: 8000)
                        ButtonView(colorMenu: "Red", colorPicker: "RedPicker", menu: "Ayam", price: 11000)
                    }
                    GridRow {
                        ButtonView(colorMenu: "Blue", colorPicker: "BluePicker", menu: "Ikan", price: 10000)
                        ButtonView(colorMenu: "Yellow", colorPicker: "YellowPicker", menu: "Telor", price: 5000)
                    }
                    GridRow {
                        ButtonView(colorMenu: "Green", colorPicker: "GreenPicker", menu: "Sayur", price: 3000)
                        LainnyaButton()
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(Text("Calculator"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleTextColor(.darkBlue)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(width: 300, height: 3)
                .padding(.top, 10)
            Spacer()
                
        }
    }
    
    func makeABox() -> some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 100, height: 100)
    }
}

#Preview {
    ContentView()
}
