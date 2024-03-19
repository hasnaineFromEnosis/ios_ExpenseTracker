//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation

enum ExpenseType: String, CaseIterable {
    case random = "Random"
    case recurrent = "Recurrent"
}

class ExpenseViewModel: ObservableObject {
    // save fetched notes for view loading
    @Published var expenseData: [ExpenseData] = []
    @Published var pendingExpenseData: [ExpenseData] = []
    @Published var paidExpenseData: [ExpenseData] = []
    
    let dataService = PersistentContainer.shared
    
    // states
    @Published var expenseTitle: String = ""
    @Published var expenseDetails: String = ""
    @Published var expenseCategory: String = ""
    @Published var expenseAmount: String = ""
    @Published var expenseType: ExpenseType = ExpenseType.random
    
    init() {
        getAllExpenseData()
        
        for expense in expenseData {
            if expense.paidDate != nil {
                paidExpenseData.append(expense)
            } else {
                pendingExpenseData.append(expense)
            }
        }
    }
    
    func getAllExpenseData() {
        expenseData = dataService.read()
    }
    
    func createExpense() {
        dataService.create(title: expenseTitle,
                           details: expenseDetails,
                           category: expenseCategory,
                           amount: Int(expenseAmount)!,
                           type: expenseType)
        getAllExpenseData()
        clearState()
    }
    
    func deleteNotes(expenseData: ExpenseData) {
        dataService.delete(entity: expenseData)
        getAllExpenseData()
    }
    
    func markAsPaidExpense(expenseData: ExpenseData) {
        dataService.update(entity: expenseData, paidDate: Date())
        getAllExpenseData()
    }
    
    
    func clearState() {
        expenseTitle = ""
        expenseDetails = ""
        expenseCategory = ""
        expenseAmount = ""
        expenseType = ExpenseType.random
    }
}

