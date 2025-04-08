//
//  DailySalesSummaryRow.swift
//  Bufflo
//
//  Created by Muhammad Azmi on 08/04/25.
//

import Foundation
import SwiftUI

struct DailySalesSummaryRow: View {
    let date: Date
    let totalIncome: Int
    let salesCount: Int

    // Formatter for displaying the date clearly (e.g., "Apr 7")
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // Example: Apr 7
        return formatter
    }

    var body: some View {
        HStack {
            // Date and Sales Count
            VStack(alignment: .leading) {
                Text(date, formatter: dateFormatter)
                    .font(.system(size: 17, weight: .medium))
                Text("\(salesCount) Sale\(salesCount == 1 ? "" : "s")") // Handle pluralization
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }

            Spacer() // Pushes total income to the right

            // Total Income for the Day
            Text("Rp \(totalIncome)")
                .font(.system(size: 18, weight: .semibold))
        }
        .padding(.horizontal, 20) // Add horizontal padding
        .padding(.vertical, 8)   // Add vertical padding

        Divider() // Separator between days
            .padding(.horizontal, 17)
    }
}

#Preview {
    VStack {
        DailySalesSummaryRow(date: Date(), totalIncome: 150000, salesCount: 5)
        DailySalesSummaryRow(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, totalIncome: 95000, salesCount: 3)
    }
}
