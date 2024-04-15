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
    var isBaseRecurrent: Bool
    
    init(id: UUID = UUID(),
         title: String = "Dummy Title",
         details: String = "Dummy Description",
         amount: Int = Int.random(in: 1...1000),
         category: String = "Dummy Category",
         type: String = ExpenseType.random.rawValue,
         creationDate: Date = Date.distantPast,
         paidDate: Date? = nil,
         isBaseRecurrent: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.amount = amount
        self.category = category
        self.type = type
        self.creationDate = creationDate
        self.paidDate = paidDate
        self.isBaseRecurrent = isBaseRecurrent
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
        self.isBaseRecurrent = entity.isBaseRecurrent
    }
    
    static func randomExpenseData(isPaid: Bool = false, isRecurrent: Bool = false) -> ExpenseData {
        let type = isRecurrent ? ExpenseType.recurrent : ExpenseType.random
        let paidDate = isPaid ? Date() : nil
        return ExpenseData(type: type.rawValue, paidDate: paidDate)
    }
}
