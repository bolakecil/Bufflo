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
                    .padding(.horizontal, 50)
//                    .frame(width: 20, height: 20)
                //smntr gini, nnti bs dicakepin ky passcode
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
