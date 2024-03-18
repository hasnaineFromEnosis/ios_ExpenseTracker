//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation

enum ExpenseType {
    case random
    case recurrent
}

class Expense: Identifiable {
    var id: UUID
    var title: String
    var description: String
    var amount: Int
    var category: String
    var type: ExpenseType
    var creationDate: Date
    var paidDate: Date?
    
    init(title: String, description: String, amount: Int, category: String, type: ExpenseType, creationDate: Date, paidDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.amount = amount
        self.category = category
        self.type = type
        self.creationDate = creationDate
        self.paidDate = paidDate
    }
    
    class func getRandomExpense(value: Int, isPaid: Bool = false, isRecurrent: Bool = false) -> Expense {
        return Expense(title: "Dummy Title \(value)",
                       description: "Dummy Description \(value)",
                       amount: Int.random(in: 1...1000),
                       category: "Dummy Category", 
                       type: isRecurrent ? ExpenseType.recurrent : ExpenseType.random,
                       creationDate: Date.distantPast,
                       paidDate: isPaid ? Date.now : nil
        )
    }
    
    func markAsPaid() {
        assert(isExpensePending())
        self.paidDate = Date.now
    }
    
    func isExpensePending() -> Bool {
        return self.paidDate == nil
    }
    
}
