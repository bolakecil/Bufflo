import SwiftUI

struct LainnyaButton: View {
    private let colorMenu : String = "Purple"
    private let menu : String = "Lainnya"
    @State private var sum = 0
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 13)
                .frame (width: 150, height: 165)
                .foregroundColor (Color(colorMenu))
            VStack{
                Image(menu)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    LainnyaButton()
}
