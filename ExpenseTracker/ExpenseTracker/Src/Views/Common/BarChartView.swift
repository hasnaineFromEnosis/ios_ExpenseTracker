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
    var amount: Int
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
        ScrollView(.vertical) {
            Chart(barChartData) { item in
                BarMark(
                    x: .value("Amount", item.amount),
                    y: .value("Category", item.category)
                )
                .annotation(position: .trailing) {
                    Text("৳\(Int(item.amount))")
                        .foregroundColor(.accentColor)
                        .font(.footnote)
                }
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [barColor1, barColor2]), startPoint: .bottomLeading, endPoint: .topTrailing))
                .cornerRadius(10)
            }
            .animation(.easeIn, value: 5)
            .frame(height: CGFloat(barChartData.count) * 50)
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
}

#Preview {
    BarChartView(chartTitle: "Preview Title", barChartData: [])
}

#Preview {
    BarChartView(chartTitle: "Preview Title", barChartData: [
        BarChartData(category: "Food", amount: 4),
        BarChartData(category: "Clothes", amount: 134389),
        BarChartData(category: "Home", amount: 131987)
    ])
}

#Preview {
    BarChartView(chartTitle: "Preview Title", barChartData: [
        BarChartData(category: "Food", amount: 125525),
        BarChartData(category: "Clothes", amount: 134389),
        BarChartData(category: "Home", amount: 131987),
        BarChartData(category: "Health", amount: 128965),
        BarChartData(category: "Education", amount: 123122),
        BarChartData(category: "Sports", amount: 79650),
        BarChartData(category: "Food 2", amount: 125525),
        BarChartData(category: "Clothes 2", amount: 134389),
        BarChartData(category: "Home 2", amount: 131987),
        BarChartData(category: "Health 2", amount: 128965),
        BarChartData(category: "Education 2", amount: 123122),
        BarChartData(category: "Sports 2", amount: 79650),
        BarChartData(category: "Food 3", amount: 125525),
        BarChartData(category: "Clothes 3", amount: 134389),
        BarChartData(category: "Home 3", amount: 131987),
        BarChartData(category: "Health 3", amount: 128965),
        BarChartData(category: "Education 3", amount: 123122),
        BarChartData(category: "Sports 5", amount: 79650),
        BarChartData(category: "Food 4", amount: 125525),
        BarChartData(category: "Clothes 5", amount: 134389),
        BarChartData(category: "Home 6", amount: 131987),
        BarChartData(category: "Health 7", amount: 128965),
        BarChartData(category: "Education 8", amount: 123122),
        BarChartData(category: "Sports 9", amount: 79650),
        BarChartData(category: "Food 6", amount: 125525),
        BarChartData(category: "Clothes 6", amount: 134389),
        BarChartData(category: "Home 8", amount: 131987),
        BarChartData(category: "Health 6", amount: 128965),
        BarChartData(category: "Education 6", amount: 123122),
        BarChartData(category: "Sports 6", amount: 79650),
        BarChartData(category: "Food 2 6", amount: 125525),
        BarChartData(category: "Clothes 2 6", amount: 134389),
        BarChartData(category: "Home 2 6 ", amount: 131987),
        BarChartData(category: "Health 2 6", amount: 128965),
        BarChartData(category: "Education 2 6", amount: 123122),
        BarChartData(category: "Sports 2 6", amount: 79650),
        BarChartData(category: "Food 3 6", amount: 125525),
        BarChartData(category: "Clothes 3 6", amount: 134389),
        BarChartData(category: "Home 3 6", amount: 131987),
        BarChartData(category: "Health 3 6", amount: 128965),
        BarChartData(category: "Education 3 6", amount: 123122),
        BarChartData(category: "Sports 3", amount: 79650),
        BarChartData(category: "Food 4 6", amount: 125525),
        BarChartData(category: "Clothes 5 6", amount: 134389),
        BarChartData(category: "Home 6 6", amount: 131987),
        BarChartData(category: "Health 7 6", amount: 128965),
        BarChartData(category: "Education 6 8", amount: 123122),
        BarChartData(category: "Sports 9 6", amount: 79650)
    ])
}

#Preview {
    BarChartView(chartTitle: "Preview Title", barChartData: [
        BarChartData(category: "Food", amount: 125525),
        BarChartData(category: "Clothes", amount: 134389),
        BarChartData(category: "Home", amount: 131987),
        BarChartData(category: "Health", amount: 128965),
        BarChartData(category: "Education", amount: 123122),
        BarChartData(category: "Sports", amount: 79650),
        BarChartData(category: "Food 2", amount: 125525),
        BarChartData(category: "Clothes 2", amount: 134389),
        BarChartData(category: "Home 2", amount: 131987),
        BarChartData(category: "Health 2", amount: 128965),
        BarChartData(category: "Education 2", amount: 123122),
        BarChartData(category: "Sports 2", amount: 79650)
    ])
}
