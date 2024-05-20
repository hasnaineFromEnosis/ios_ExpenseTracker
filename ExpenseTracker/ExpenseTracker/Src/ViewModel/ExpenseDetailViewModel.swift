//
//  ExpenseDetailViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class ExpenseDetailViewModel: ObservableObject {

    let dataManager = DataManager.shared
    
    // states
    @Published var expenseData: ExpenseData
    
    @Published var title: String = "Untitled"
    @Published var details: String = "Empty Details"
    @Published var amount: String = "0 taka"
    @Published var category: String = "Empty Category"
    @Published var type: String = ExpenseType.random.rawValue
    @Published var creationDate: String = ""
    @Published var paidDate: String? = nil
    
    @Published var buttonText: String = ""

    init(expenseData: ExpenseData) {
        self.expenseData = expenseData
        self.updateData()
    }
    
    func markAsPaidExpense() {
        expenseData.paidDate = Date()
        expenseData.sourceType = DataSourceType.getCurrentSource()
        expenseData.updateDate = Date()
        dataManager.updateExpense(expenseData: expenseData)
        updateData()
    }
    
    func markAsPendingExpense() {
        expenseData.paidDate = nil
        expenseData.sourceType = DataSourceType.getCurrentSource()
        expenseData.updateDate = Date()
        dataManager.updateExpense(expenseData: expenseData)
        updateData()
    }
    
    func isExpensePending() -> Bool {
        return expenseData.paidDate == nil
    }
    
    func paidWithdrawButtonPressed() {
        isExpensePending() ? markAsPaidExpense() : markAsPendingExpense()
    }
    
    // Private methods
    private func updateData() {
        title = expenseData.title
        details = expenseData.details
        amount = "\(expenseData.amount) taka"
        category = expenseData.category
        type = expenseData.type
        creationDate = formatDate(date: expenseData.creationDate)
        paidDate = expenseData.paidDate != nil ? formatDate(date: expenseData.paidDate!) : nil
        
        buttonText = isExpensePending() ? "Pay Expense" : "Withdraw Expense"
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: .complete,
                              time: .standard)
    }
}
