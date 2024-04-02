//
//  BarChartView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI
import Charts

// 1. Data model
struct Revenue: Identifiable {
    let id = UUID()
    let period: String
    let amount: Double
}

// 2. Data as an array of Revenue objects
let revenueData: [Revenue] = [
    Revenue(period: "2022 Q1", amount: 125525.25),
    Revenue(period: "2022 Q2", amount: 154389.50),
    Revenue(period: "2022 Q3", amount: 131987.90),
    Revenue(period: "2022 Q4", amount: 178965.80)
]

// 1. Declare colors
let barColor1 = Color.accentColor
let barColor2 = Color(red: 0/255, green: 152/255, blue: 55/255)

struct BarChartView: View {
    var body: some View {
        // 1. Left-align the content
        VStack(alignment: .leading) {
            
            // 2. Add and style the Text property
            Text("Revenue per Quarter in 2022")
                .font(.system(size: 22, weight: .bold))
            
            
            Chart(revenueData) { item in
                BarMark(
                    x: .value("Period", item.period),
                    y: .value("Amount", item.amount)
                )
                .annotation(position: .top) {
                    Text(String(format: "$%.0f", item.amount))
                        .foregroundColor(Color.gray)
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(.linearGradient(
                    colors: [barColor1, barColor2],
                    startPoint: .bottom,
                    endPoint: .top
                ))
                .cornerRadius(10)
            }
            .frame(height: 400)
            .chartXAxisLabel("Period (Quarter)")
            .chartYAxisLabel("Revenue in USD")
        }
        .padding()
    }
}

#Preview {
    BarChartView()
}
