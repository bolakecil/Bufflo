import SwiftUI

struct SalesRecapVerify: View {
    @State private var pin: String = ""
    let onSuccess: () -> Void
    
    
    var body: some View {
        NavigationStack{
            VStack{
                SecureField("Enter PIN", text: $pin)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    //perlu bikin page buat set up pin??w
            }
            .navigationTitle("Verification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSuccess() //sets needVerification to false
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
