//
//  BarChartView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI
import Charts

// 1. Data model
struct TrendyData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

// 2. Data as an array of Revenue objects
let trendyData: [TrendyData] = [
    TrendyData(category: "Food", amount: 125525.25),
    TrendyData(category: "Clothes", amount: 134389.50),
    TrendyData(category: "Home", amount: 131987.90),
    TrendyData(category: "Health", amount: 128965.80),
    TrendyData(category: "Education", amount: 123122.80),
    TrendyData(category: "Sports", amount: 79650.80),
    TrendyData(category: "Food 2", amount: 125525.25),
    TrendyData(category: "Clothes 2", amount: 134389.50),
    TrendyData(category: "Home 2", amount: 131987.90),
    TrendyData(category: "Health 2", amount: 128965.80),
    TrendyData(category: "Education 2", amount: 123122.80),
    TrendyData(category: "Sports 2", amount: 79650.80)
]

struct BarChartView: View {
    let barColor1 = Color.accentColor
    let barColor2 = Color(red: 0/255, green: 152/255, blue: 55/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("R&D on Bar chart")
                .font(.title)
                .fontWeight(.bold)
            
            Chart(trendyData) { item in
                BarMark(
                    x: .value("Amount", item.amount),
                    y: .value("Category", item.category)
                )
                .annotation(position: .trailing) {
                    Text("৳\(Int(item.amount))")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [barColor1, barColor2]), startPoint: .bottomLeading, endPoint: .topTrailing))
                .cornerRadius(10)
            }
            .animation(.easeIn, value: 5)
            .frame(height: 400)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .chartXAxisLabel("Amount Spent")
            .chartYAxisLabel("Category")
            .aspectRatio(1, contentMode: .fit)
        }
        .padding()
    }
}

#Preview {
    BarChartView()
}
