//
//  BarChartView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI
import Charts

// 1. Data model
struct BarChartData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct BarChartView: View {
    let barChartData: [BarChartData]
    let chartTitle: String
    let barColor1 = Color.accentColor
    let barColor2 = Color(red: 0/255, green: 152/255, blue: 55/255)
    
    init(chartTitle: String, barChartData: [BarChartData]) {
        self.barChartData = barChartData
        self.chartTitle = chartTitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if barChartData.isEmpty {
                noDataView
            } else {
                chartTitleView
                chartView
            }
        }
        .padding()
    }
    
    private var chartTitleView: some View {
        Text(chartTitle)
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var noDataView: some View {
        Text("No data available")
            .font(.title)
            .fontWeight(.bold)
    }
    
    private var chartView: some View {
        Chart(barChartData) { item in
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
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    BarChartView(chartTitle: "Preview Title", barChartData: [])
}

#Preview {
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
}
