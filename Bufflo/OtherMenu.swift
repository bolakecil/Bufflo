import SwiftUI

struct OtherMenu: View {
    @Binding var items: [Item]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    List {
                        ForEach(items.indices, id: \.self) { index in
                            HStack {
                                Text(items[index].name)
                                Spacer()
                                CustomStepper(value: $items[index].count)
                            }
                        }
                    }
                }
//                Button {
//                    
//                } label: {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundStyle(Color.blue)
//                            .frame(width: 300, height: 50)
//                        Text("Confirm")
//                            .font(.system(size: 19, weight: .bold))
//                            .foregroundColor(.white)
//                    }
//                }
//                .padding()
//                .padding(.bottom, 50)
//                .shadow(radius: 5)
                
            }
            .navigationTitle("Other Menu")
        }
        
    }
}


struct Item: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    var count: Int
}

struct CustomStepper: View {
    @Binding var value: Int
    var minValue: Int = 0
    var maxValue: Int? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            HStack {
                Button(action: {
                    value = max(minValue, value - 1)
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(value > minValue ? .black : .gray)
                        .contentShape(Rectangle())
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(value <= minValue)
                
                Text("\(value)")
                    .frame(width: 40)
                    .multilineTextAlignment(.center)
                Button(action: {
                    if let maxValue = maxValue {
                        value = min(maxValue, value + 1)
                    } else {
                        value += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .frame(width: 120, height: 40)
        //send instance ke calculator buat dihitung
//        func sendValue() -> {
//            
//        }
    }
}



//#Preview {
//    OtherMenu()
//}
