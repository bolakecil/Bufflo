//
//  SalesRecap.swift
//  Bufflo
//
//  Created by Jessica Lynn on 24/03/25.
//

import SwiftUI

struct SalesRecap: View {
    @State private var timeOfDay: String = "Morning"
    @State private var totalIncome: Int = 12000000
    @State private var todayIncome: Int = 1000000
    @State private var todaySales: Int = 16
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.gray)
                        .padding(20)
                        .frame(height: 210)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total Income This Month")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Text("Rp \(totalIncome)") //double?
                            .font(.system(size: 33, weight: .bold, design: .default))
                        VStack{
                            HStack{
                                Text("Today's Income")
                                Spacer()
                                Text("Today's Sales")
                            }
                            HStack{
                                HStack {
                                    Text("Rp \(todayIncome)")
                                        .font(.system(size: 17, weight: .bold, design: .default))
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .foregroundColor(.green)
                                }
                                Spacer()
                                Text("\(todaySales)")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                            }
                        }
                    }.padding(.horizontal, 38)
                    
                }
//                UISegmentedControl(frame: <#T##CGRect#>)
                Spacer()
                //fill here
            }
            .navigationTitle("Good \(updateTimeOfDay())")
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func updateTimeOfDay() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        let hour = components.hour ?? 0
        
        if hour >= 0 && hour < 12 {
            timeOfDay = "Morning"
        } else if hour >= 12 && hour < 16 {
            timeOfDay = "Afternoon"
        } else {
            timeOfDay = "Evening"
        }
        return timeOfDay
    }
    
}

#Preview {
    SalesRecap()
}
