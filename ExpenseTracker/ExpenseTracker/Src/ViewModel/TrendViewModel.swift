//
//  TrendViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 3/4/24.
//

import Foundation
import Combine

class TrendViewModel: ObservableObject {
    
    private let dataManager = DataManager.shared
    
    @Published var selectedMonth: Int = Utilities.getDataFromDate(component: .month, date: Date())
    @Published var selectedYear: Int = Utilities.getDataFromDate(component: .year, date: Date())
    
    @Published var navTitle: String = "Trend"
    
    @Published var barChartTitle: String = "Category-wise Expense"
    
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
    }
    
    var barChartData: [BarChartData] {
        var results: [BarChartData] = []
        
        var indexTracker = [String: Int]()
        
        for expense in filteredData {
            let category = expense.category
            let amount = expense.amount
            
            if let index = indexTracker[category] {
                results[index].amount += amount
            } else {
                indexTracker[category] = results.count
                results.append(BarChartData(category: category, amount: amount))
            }
        }
        
        return results
    }
    
    private var allExpenseData: [ExpenseData] {
        dataManager.paidExpensesList + dataManager.pendingExpensesList
    }
    
    private var filteredData: [ExpenseData] {
        allExpenseData.filter {
            let month = Utilities.getDataFromDate(component: .month, date: $0.creationDate)
            let year = Utilities.getDataFromDate(component: .year, date: $0.creationDate)
            
            return month == selectedMonth && year == selectedYear
        }
    }
}
