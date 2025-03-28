//
//  OtherMenu.swift
//  Bufflo
//
//  Created by Muhammad Azmi on 27/03/25.
//

import SwiftUI

struct OtherMenu: View {
    @State private var items = [
        Item(name: "Tahu", count: 0),
        Item(name: "Tempe", count: 0),
        Item(name: "Bala-Bala", count: 0),
        Item(name: "Bihun Goreng", count: 0),
        Item(name: "Mie Goreng", count: 0),
        Item(name: "Bakso", count: 0),
        Item(name: "Rolade", count: 0),
    ]

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
                
                // Confirm Button
                Button {
                    
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color.blue)
                            .frame(height: 50)
                            .cornerRadius(100)
                        Text("Confirm")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.bottom, 50)
                .shadow(radius: 5)
            }
            .navigationTitle("Other Menu")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Add back navigation action
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }
}


struct Item: Identifiable {
    let id = UUID()
    let name: String
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
    }
}



#Preview {
    OtherMenu()
}
