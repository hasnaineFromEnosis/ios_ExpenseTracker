//
//  CreateExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class CreateExpenseViewModel: ObservableObject {
    
    let coreDataService: CoreDataManager = CoreDataManager.shared
    
    // states
    @Published var expenseTitle: String = ""
    @Published var expenseDetails: String = ""
    @Published var expenseCategory: String = ""
    @Published var expenseAmount: String = ""
    @Published var expenseType: ExpenseType = ExpenseType.random
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Data"
    @Published var alertMessage: String = "Please ensure that each field is filled out accurately."
    
    @Published var navigationTitle: String = "Create Expense"
    @Published var createExpenseButtonText: String = "Create New Expense"
    
    func validateData() -> Bool {
        if expenseTitle.isEmpty {
            showInvalidDataAlert = true
            return false
        }
        
        if expenseDetails.isEmpty {
            showInvalidDataAlert = true
            return false
        }
        
        if expenseCategory.isEmpty {
            showInvalidDataAlert = true
            return false
        }
        
        if expenseAmount.isEmpty {
            showInvalidDataAlert = true
            return false
        }
    
        return createExpense()
    }
    
    private func createExpense() -> Bool {
        if let expenseAmount = Int(expenseAmount) {
            coreDataService.create(title: expenseTitle,
                               details: expenseDetails,
                               category: expenseCategory,
                               amount: expenseAmount,
                               type: expenseType)
            
            clearState()
            return true
        }
        
        alertMessage = "Please enter a realistic amount of money."
        showInvalidDataAlert = true
        
        return false
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
