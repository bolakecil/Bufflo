import SwiftUI

struct SalesRecapVerify: View {
    @State private var pin: String = ""
    @State private var showAlert = false
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
                        if pin ==  "8888"{
                            onSuccess() //sets needVerification to false
                        } else {
                            showAlert=true
                        }
                    }
                    .alert(isPresented: $showAlert){
                        Alert(
                                    title: Text("Wrong PIN")
                                )
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
