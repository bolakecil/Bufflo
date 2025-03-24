import SwiftUI
import SwiftData

enum Tab {
    case customer
    case sales
}

struct ContentView: View {
    @State private var selectedTab: Tab = .customer
    @State private var salesRecapNeedsVerification = true
    
    var body: some View {
        TabView(selection: $selectedTab){
            Calculator()
                .tabItem{
                    Label("Customer", systemImage: "person.2.fill")
                }
                .tag(Tab.customer)
            needVerify(needVerification: $salesRecapNeedsVerification)
                .tabItem{
                    Label("Sales", systemImage: "cart.fill")
                }
                .tag(Tab.sales)
        }
        .onChange(of: selectedTab) { newTab in
            if newTab != .sales {
                salesRecapNeedsVerification = true
            }
        }
    }
}

#Preview {
    ContentView()
}
