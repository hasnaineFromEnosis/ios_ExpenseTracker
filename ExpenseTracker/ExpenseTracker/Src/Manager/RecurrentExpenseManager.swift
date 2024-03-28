//
//  RecurrentExpenseManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 27/3/24.
//

import Foundation

class RecurrentExpenseManager {
    // MARK: - Singleton
    
    static let shared = RecurrentExpenseManager()
    private init() {}
    
    // MARK: - Methods
    
    /// Generates necessary recurrent expenses based on the provided expense data.
    ///
    /// - Parameter expense: The expense data.
    /// - Returns: An array of generated expense data.
    static func generateNecessaryRecurrentExpenses(for expense: ExpenseData) -> [ExpenseData] {
        let currentDate = Date()
        let lastPaidDate = expense.paidDate ?? expense.creationDate
        
        let calendar = Calendar.current
        let monthDiff = calendar.dateComponents([.month], from: lastPaidDate, to: currentDate).month ?? 0
        let day1 = calendar.component(.day, from: lastPaidDate)
        let day2 = calendar.component(.day, from: currentDate)
        
        let totalExpenseToCreate = monthDiff + (day1 > day2 ? 1 : 0)
        
        if totalExpenseToCreate == 0 {
            return []
        }
        
        var results: [ExpenseData] = []
        
        for _ in 1...totalExpenseToCreate {
            var newExpense = expense
            newExpense.id = UUID()
            newExpense.paidDate = nil
            results.append(newExpense)
        }
        
        return results
    }
}

