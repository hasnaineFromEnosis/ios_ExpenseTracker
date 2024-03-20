//
//  ExpenseData + Extension.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import SwiftUI

extension ExpenseData {
    func isExpensePending() -> Bool {
        return self.paidDate == nil
    }
    
    class func getRandomExpenseData(value: Int, isPaid: Bool = false, isRecurrent: Bool = false) -> ExpenseData {
        let expenseData: ExpenseData = ExpenseData()
        expenseData.title = "Dummy Title \(value)"
        expenseData.details = "Dummy Description \(value)"
        expenseData.amount = Int32.random(in: 1...1000)
        expenseData.category = "Dummy Category"
        expenseData.type = isRecurrent ? ExpenseType.recurrent.rawValue : ExpenseType.random.rawValue
        expenseData.creationDate = Date.distantPast
        expenseData.paidDate = isPaid ? Date.now : nil

        return expenseData
    }
}
