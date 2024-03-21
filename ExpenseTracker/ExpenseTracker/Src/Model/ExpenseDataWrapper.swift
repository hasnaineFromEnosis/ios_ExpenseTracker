//
//  ExpenseDataWrapper.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 21/3/24.
//

import Foundation

enum ExpenseType: String, CaseIterable {
    case random = "Random"
    case recurrent = "Recurrent"
}

struct ExpenseDataWrapper: Identifiable {
    
    let id: UUID
    let title: String
    let details: String
    let category: String
    
    let amount: Int
    let creationDate: Date
    var paidDate: Date?
    
    let type: ExpenseType
    
    let entity: ExpenseData?
    
    init(id: UUID, title: String, details: String, category: String, amount: Int, creationDate: Date, paidDate: Date?, type: ExpenseType) {
        self.id = id
        self.title = title
        self.details = details
        self.category = category
        self.amount = amount
        self.creationDate = creationDate
        self.paidDate = paidDate
        self.type = type
        
        self.entity = nil
    }
    
    init(expenseData: ExpenseData) {
        self.id = expenseData.id ?? UUID()
        self.title = expenseData.title ?? "Invalid Title"
        self.details = expenseData.details ?? "Invalid Details"
        self.category = expenseData.category ?? "Invalid Category"
        self.amount = Int(expenseData.amount)
        self.creationDate = expenseData.creationDate ?? Date()
        self.paidDate = expenseData.paidDate
        self.type = expenseData.type == ExpenseType.random.rawValue ? .random : .recurrent
        
        self.entity = expenseData
    }
    
    static func getRandomExpenseData(isPaid: Bool = false, isRecurrent: Bool = false) -> ExpenseDataWrapper {
        let id: UUID = UUID()
        let title: String = "Dummy Title"
        let details: String = "Dummy Details"
        let category: String = "Dummy Category"
        
        let amount: Int = Int.random(in: 100...1000000)
        let creationDate: Date = Date()
        let paidDate: Date? = isPaid ? Date.distantFuture : nil
        
        let type: ExpenseType  = isRecurrent ? .recurrent : .random
        
        return ExpenseDataWrapper(id: id,
                                  title: title,
                                  details: details,
                                  category: category,
                                  amount: amount,
                                  creationDate: creationDate,
                                  paidDate: paidDate,
                                  type: type)
    }
}
