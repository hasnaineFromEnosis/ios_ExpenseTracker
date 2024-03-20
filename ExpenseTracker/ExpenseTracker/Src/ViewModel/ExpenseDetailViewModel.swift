//
//  ExpenseDetailViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class ExpenseDetailViewModel: ObservableObject {

    let dataService = PersistentContainer.shared
    
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
        dataService.update(entity: expenseData, paidDate: Date())
        updateData()
        
    }
    
    func markAsPendingExpense() {
        dataService.markExpenseAsPending(entity: expenseData)
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
        self.title = expenseData.title ?? "Untitled"
        self.details = expenseData.details ?? "Empty Details"
        self.amount = "\(expenseData.amount) taka"
        self.category = expenseData.category ?? "Empty Category"
        self.type = expenseData.type ?? ExpenseType.random.rawValue
        self.creationDate = ""
        self.paidDate = nil
        self.buttonText = ""
        
        self.creationDate = formatDate(date: expenseData.creationDate ?? Date.distantPast)
        self.paidDate = expenseData.paidDate != nil ? formatDate(date: expenseData.paidDate!) : nil
        
        self.buttonText = isExpensePending() ? "Pay Expense" : "Withdraw Expense"
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: .complete,
                              time: .standard)
    }
}
