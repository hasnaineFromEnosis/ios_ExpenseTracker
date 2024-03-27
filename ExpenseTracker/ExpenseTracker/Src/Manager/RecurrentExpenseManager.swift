//
//  RecurrentExpenseManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 27/3/24.
//

import Foundation

class RecurrentExpenseManager {
    
    static let shared = RecurrentExpenseManager()
    
    private init() { }
    
    static func generateNecessaryRecurrentExpense(for expense: ExpenseData) -> [ExpenseData] {
        let currentDate: Date = Date()
        let lastPaidDate: Date = expense.paidDate ?? expense.creationDate
        
        let calendar = Calendar.current
        let yearDiff = calendar.dateComponents([.year], from: lastPaidDate, to: currentDate).year ?? 0
        let monthDiff = calendar.dateComponents([.month], from: lastPaidDate, to: currentDate).month ?? 0
        
        var results: [ExpenseData] = []
        
        let totalExpenseToCreate = yearDiff * 12 + monthDiff
        
        for _ in 1...totalExpenseToCreate {
            var newExpense = expense
            newExpense.id = UUID()
            newExpense.paidDate = nil
            results.append(newExpense)
        }
        
        return results
    }
}
