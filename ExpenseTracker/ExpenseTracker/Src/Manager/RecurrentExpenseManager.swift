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
        let monthDiff = calendar.dateComponents([.month], from: lastPaidDate, to: currentDate).month ?? 0
        let day1 = calendar.component(.day, from: lastPaidDate)
        let day2 = calendar.component(.day, from: currentDate)
        
        let totalExpenseToCreate = monthDiff + day1 > day2 ? 1 : 0
        
        var results: [ExpenseData] = []
        
        if totalExpenseToCreate > 0 {
            for _ in 1...totalExpenseToCreate {
                var newExpense = expense
                newExpense.id = UUID()
                newExpense.paidDate = nil
                results.append(newExpense)
            }
        }
        
        return results
    }
}
