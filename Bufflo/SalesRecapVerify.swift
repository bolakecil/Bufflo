//
//  SalesRecapCheck.swift
//  Bufflo
//
//  Created by Jessica Lynn on 24/03/25.
//

import SwiftUI

struct SalesRecapVerify: View {
    let onSuccess: () -> Void
    
    var body: some View {
        NavigationStack{
            VStack{
                // password input
                
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
