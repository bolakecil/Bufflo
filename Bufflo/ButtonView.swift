import SwiftUI

struct ButtonView: View {
    let item: MenuItem
    @Binding var qty: Int
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 13)
                .frame (width: 150, height: 165)
                .foregroundColor (Color(item.colorMenu))
            VStack{
                Image(item.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                Text ("Rp \(item.price)")
                    .padding(.top,5)
                    .padding(.bottom,-2)
                    .foregroundStyle(.white)
                    .font(.system(size: 21, weight: .bold))
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                    .frame (width: 120, height: 30)
                    .foregroundColor(Color(item.colorPicker))
                    HStack{
                        Button(action: decreaseSum){
                            Text("-")
                                .foregroundStyle(.white)
                                .padding(.trailing, 28)
                                .padding(.bottom, 2)
                                .font(.system(size: 21, weight: .bold))
                        }
                        Text("\(qty)")
                            .foregroundStyle(.white)
                        Button(action:{
                            qty = qty + 1
                        }){
                            Text("+")
                                .foregroundStyle(.white)
                                .padding(.leading, 22)
                                .padding(.bottom, 2)
                                .font(.system(size: 21, weight: .bold))
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    func decreaseSum(){
        if (qty > 0){
            qty = qty - 1
        }
    }
}
