import SwiftUI

struct needVerify: View {
    @Binding var needVerification: Bool
    
    var body: some View {
        if needVerification {
            SalesRecapVerify(onSuccess: {needVerification = false})
        }
        else {
            SalesRecap()
        }
    }
}
