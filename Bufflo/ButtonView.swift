//
//  Button.swift
//  Bufflo
//
//  Created by Theodora Stefani Handojo on 26/03/25.
//

import SwiftUI

struct ButtonView: View {
    private var colorPicker : String = "SandPicker"
    private var colorMenu : String = "Sand"
    private var menu : String = "Nasi"
    private var price = 8000
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
                Text ("Rp \(price)")
                    .padding(.top,5)
                    .padding(.bottom,-2)
                    .foregroundStyle(.white)
                    .font(.system(size: 21, weight: .bold))
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                    .frame (width: 120, height: 30)
                    .foregroundColor(Color(colorPicker))
                    HStack{
                        Button(action: decreaseSum){
                            Text("-")
                                .foregroundStyle(.white)
                                .padding(.trailing, 28)
                                .padding(.bottom, 2)
                                .font(.system(size: 21, weight: .bold))
                        }
                        Text("\(sum)")
                            .foregroundStyle(.white)
                        Button(action:{
                            sum = sum + 1
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
        if (sum > 0){
            sum = sum - 1
        }
    }
}

#Preview {
    ButtonView()
}
