//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation

struct Expense: Identifiable {
    
    enum ExpenseType {
        case random
        case recurrent
    }
    
    var id: UUID
    var title: String
    var description: String
    var amount: Int
    var category: String
    var type: ExpenseType
    var date: Date?
    
    init(title: String, description: String, amount: Int, category: String, type: ExpenseType, date: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
    }
    
    mutating func markAsPaid() {
        assert(isExpensePending())
        self.date = Date.now
    }
    
    func isExpensePending() -> Bool {
        return self.date == nil
    }
    
}
