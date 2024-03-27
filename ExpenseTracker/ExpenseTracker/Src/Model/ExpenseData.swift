//
//  ExpenseData.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 25/3/24.
//

import Foundation

struct ExpenseData: Identifiable, Hashable {
    var id: UUID
    var title: String
    var details: String
    var creationDate: Date
    var paidDate: Date?
    var amount: Int
    var category: String
    var type: String
    
    init() {
        self.id = UUID()
        self.title = "Dummy Title"
        self.details = "Dummy Description"
        self.amount = Int.random(in: 1...1000)
        self.category = "Dummy Category"
        self.type = ExpenseType.random.rawValue
        self.creationDate = Date.distantPast
        self.paidDate = nil
    }
    
    init(entity: ExpenseDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.details = entity.details ?? "Invalid details"
        self.creationDate = entity.creationDate ?? Date()
        self.paidDate = entity.paidDate
        self.amount = Int(entity.amount)
        self.category = entity.category ?? "Invalid category"
        self.type = entity.type ?? ExpenseType.random.rawValue
    }
    
    static func getRandomExpenseData(isPaid: Bool = false, isRecurrent: Bool = false) -> ExpenseData {
        var expenseData: ExpenseData = ExpenseData()
        expenseData.type = isRecurrent ? ExpenseType.recurrent.rawValue : ExpenseType.random.rawValue
        expenseData.paidDate = isPaid ? Date.now : nil

        return expenseData
    }
}
