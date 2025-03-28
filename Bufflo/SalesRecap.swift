
import SwiftUI
import UIKit

struct SalesRecap: View {
    @State private var timeOfDay: String = "Morning"
    @State private var totalIncome: Int = 12000000
    @State private var todayIncome: Int = 1000000
    @State private var todaySales: Int = 16
    @State private var timeRange: String = "Today"
    
    
    private var timeRanges = ["Today", "This Week", "This Month"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.blueHome)
                        .padding(20)
                        .frame(height: 210)
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Total Income This Month")
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Text("Rp \(totalIncome)") //double?
                            .font(.system(size: 33, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        VStack{
                            HStack{
                                Text("Today's Income")
                                    .font(.system(size: 15, weight: .none, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Today's Sales")
                                    .font(.system(size: 15, weight: .none, design: .default))
                                    .foregroundColor(.white)
                            }
                            HStack{
                                HStack {
                                    Text("Rp \(todayIncome)")
                                        .font(.system(size: 17, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .foregroundColor(.green)
                                }
                                Spacer()
                                Text("\(todaySales)")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                        }
                    }.padding(.horizontal, 38)
                    
                }
                Picker("Time Range", selection: $timeRange) {
                    ForEach(timeRanges, id: \.self) {
                        Text($0)
                    }
                }
                .padding(.horizontal, 20)
                .pickerStyle(.segmented)
                .tint(.darkBlue)
                Group {
                    if timeRange == "Today" {
                        TodaySales()
                            .padding(.leading, 20)
                    } else if timeRange == "This Week" {
                        ThisWeekSales()
                            .padding(.leading, 20)
                    } else if timeRange == "This Month" {
                        ThisMonthSales()
                            .padding(.leading, 20)
                    }
                }
                Spacer()
            }
            .navigationTitle("Good \(timeOfDay)")
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleTextColor(.darkBlue)
        .onAppear {
            timeOfDay = updateTimeOfDay()
        }

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
