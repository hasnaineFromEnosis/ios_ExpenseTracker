//
//  CreateExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class CreateExpenseViewModel: ObservableObject {
    
    let dataService = PersistentContainer.shared
    
    // states
    @Published var expenseTitle: String = ""
    @Published var expenseDetails: String = ""
    @Published var expenseCategory: String = ""
    @Published var expenseAmount: String = ""
    @Published var expenseType: ExpenseType = ExpenseType.random
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Data"
    @Published var alertMessage: String = "Please ensure that each field is filled out accurately."
    
    func validateData() {
        if expenseTitle.isEmpty {
            showInvalidDataAlert = true
            return
        }
        
        if expenseDetails.isEmpty {
            showInvalidDataAlert = true
            return
        }
        
        if expenseCategory.isEmpty {
            showInvalidDataAlert = true
            return
        }
        
        if expenseAmount.isEmpty {
            showInvalidDataAlert = true
            return
        }
        
        createExpense()
        return
    }
    
    func createExpense() {
        if let expenseAmount = Int(expenseAmount) {
            dataService.create(title: expenseTitle,
                               details: expenseDetails,
                               category: expenseCategory,
                               amount: expenseAmount,
                               type: expenseType)
            
            clearState()
        } else {
            alertMessage = "Please enter a realistic amount of money."
            showInvalidDataAlert = true
        }
    }
    
    func clearState() {
        expenseTitle = ""
        expenseDetails = ""
        expenseCategory = ""
        expenseAmount = ""
        expenseType = ExpenseType.random
        alertMessage = "Please ensure that each field is filled out accurately."
    }
}
