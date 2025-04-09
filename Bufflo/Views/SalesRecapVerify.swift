import SwiftUI

struct SalesRecapVerify: View {
    @State private var pin: String = ""
    @State private var showAlert = false
    let onSuccess: () -> Void
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("This screen is protected")
                    .font(.headline)
                    .foregroundColor(.gray)
                SecureField("Enter PIN", text: $pin)
                    .keyboardType(.default)
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
                        if pin ==  "bb"{
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
