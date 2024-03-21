//
//  ExpenseDetailViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class ExpenseDetailViewModel: ObservableObject {

    let coreDataService: CoreDataManager = CoreDataManager.shared
    
    // states
    @Published var expenseData: ExpenseDataWrapper
    
    @Published var title: String = "Untitled"
    @Published var details: String = "Empty Details"
    @Published var amount: String = "0 taka"
    @Published var category: String = "Empty Category"
    @Published var type: String = ExpenseType.random.rawValue
    @Published var creationDate: String = ""
    @Published var paidDate: String? = nil
    
    @Published var buttonText: String = ""

    
    init(expenseData: ExpenseDataWrapper) {
        self.expenseData = expenseData
        self.updateData()
    }
    
    func markAsPaidExpense() {
        expenseData.paidDate = Date()
        coreDataService.markExpenseAsPaid(expenseData: expenseData)
        updateData()
    }
    
    func markAsPendingExpense() {
        expenseData.paidDate = nil
        coreDataService.markExpenseAsPending(expenseData: expenseData)
        updateData()
    }
    
    func isExpensePending() -> Bool {
        return expenseData.paidDate == nil
    }
    
    func paidWithdrawButtonPressed() {
        if isExpensePending() {
            markAsPaidExpense()
        } else {
            markAsPendingExpense()
        }
    }
    
    private func updateData() {
        self.title = expenseData.title
        self.details = expenseData.details
        self.amount = "\(expenseData.amount) taka"
        self.category = expenseData.category
        self.type = expenseData.type.rawValue
        
        self.creationDate = formatDate(date: expenseData.creationDate)
        self.paidDate = expenseData.paidDate != nil ? formatDate(date: expenseData.paidDate!) : nil
        
        self.buttonText = isExpensePending() ? "Pay Expense" : "Withdraw Expense"
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: .complete,
                              time: .standard)
    }
}
