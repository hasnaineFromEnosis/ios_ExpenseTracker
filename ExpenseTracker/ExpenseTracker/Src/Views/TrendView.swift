//
//  TrendView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI

struct TrendView: View {
    @State private var selectedMonth = 4
    @State private var selectedYear = 2024
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    MonthPicker(month: $selectedMonth)
                    YearPicker(year: $selectedYear)
                }
                Spacer()
                
                BarChartView(chartTitle: "Preview Title", barChartData: [
                    BarChartData(category: "Food", amount: 125525.25),
                    BarChartData(category: "Clothes", amount: 134389.50),
                    BarChartData(category: "Home", amount: 131987.90),
                    BarChartData(category: "Health", amount: 128965.80),
                    BarChartData(category: "Education", amount: 123122.80),
                    BarChartData(category: "Sports", amount: 79650.80),
                    BarChartData(category: "Food 2", amount: 125525.25),
                    BarChartData(category: "Clothes 2", amount: 134389.50),
                    BarChartData(category: "Home 2", amount: 131987.90),
                    BarChartData(category: "Health 2", amount: 128965.80),
                    BarChartData(category: "Education 2", amount: 123122.80),
                    BarChartData(category: "Sports 2", amount: 79650.80)
                ])
                
                Spacer()
            }
            .navigationTitle("Trend")
        }
    }
}


#Preview {
    TrendView()
}
