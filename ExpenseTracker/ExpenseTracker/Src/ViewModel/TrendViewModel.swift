//
//  TrendViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 3/4/24.
//

import Foundation

class TrendViewModel: ObservableObject {
    
    @Published var selectedMonth: Int = 4
    @Published var selectedYear: Int = 2024
    
    @Published var navTitle: String = "Trend"
    
    @Published var barChartTitle: String = "Category-wise Expense"
    @Published var barChartData: [BarChartData] = [
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
    ]
}
