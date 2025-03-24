//
//  needVerify.swift
//  Bufflo
//
//  Created by Jessica Lynn on 24/03/25.
//

import SwiftUI

struct needVerify: View {
    @Binding var needVerification: Bool
    @State private var isVerified: Bool = false
    
    var body: some View {
        if needVerification {
            SalesRecapVerify(onSuccess: {needVerification = false})
        }
        else {
            SalesRecap()
        }
    }
}
