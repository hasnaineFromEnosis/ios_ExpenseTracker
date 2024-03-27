//
//  CreateExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

class ExpenseEditorViewModel: ObservableObject {
    
    let dataManager = DataManager.shared
    
    // states
    @Published var expenseTitle: String = "Test Expense \(Int.random(in: 1...100))"
    @Published var expenseDetails: String = "Test Details"
    @Published var expenseCategory: String = "Test Categiry"
    @Published var expenseAmount: String = "\(Int.random(in: 100...100000000))"
    @Published var creationDate: Date = Date()
    @Published var paidDate: Date = Date()
    @Published var isExpensePaid: Bool = false
    @Published var expenseType: ExpenseType = ExpenseType.random
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Data"
    @Published var alertMessage: String = "Please ensure that each field is filled out accurately."
    
    @Published var navigationTitle: String = "Create Expense"
    @Published var createExpenseButtonText: String = "Create"
    
    private var expenseData: ExpenseData?
    
    init(expenseData: ExpenseData? = nil) {
        self.expenseData = expenseData
        if let expenseData {
            expenseTitle = expenseData.title
            expenseDetails = expenseData.details
            expenseCategory = expenseData.category
            expenseAmount = String(expenseData.amount)
            creationDate = expenseData.creationDate
            paidDate = expenseData.paidDate ?? Date()
            isExpensePaid = expenseData.paidDate != nil
            expenseType = expenseData.type == ExpenseType.recurrent.rawValue ? ExpenseType.recurrent : ExpenseType.random
            
            navigationTitle = "Update Expense"
            createExpenseButtonText = "Update"
        }
    }
    
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
        
        if expenseData != nil {
            return updateExpense()
        } else {
            return createExpense()
        }
    }
    
    private func createExpense() -> Bool {
        if let expenseAmount = Int(expenseAmount) {
            dataManager.create(title: expenseTitle,
                               details: expenseDetails,
                               category: expenseCategory,
                               amount: expenseAmount,
                               creationDate: creationDate,
                               paidDate: getPaidDate(),
                               type: expenseType,
                               isBaseRecurrent: expenseType == .recurrent)
            
            clearState()
            return true
        }
        
        alertMessage = "Please enter a realistic amount of money."
        showInvalidDataAlert = true
        
        return false
    }
    
    func updateExpense() -> Bool {
        if var expenseData,
           let amount = Int(expenseAmount) {
            expenseData.title = expenseTitle
            expenseData.details = expenseDetails
            expenseData.category = expenseCategory
            expenseData.amount = amount
            expenseData.type = expenseType.rawValue
            expenseData.creationDate = creationDate
            expenseData.paidDate = isExpensePaid ? paidDate : nil
            
            dataManager.update(expenseData: expenseData,
                               title: expenseTitle,
                               details: expenseDetails,
                               category: expenseCategory,
                               amount: amount,
                               type: expenseType,
                               creationDate: creationDate,
                               paidDate: expenseData.paidDate)
            return true
        }
        
        alertMessage = "Please enter a realistic amount of money."
        showInvalidDataAlert = true
        
        return false
    }
    
    func blockEditingPaidDate() -> Bool {
        return isCreatingView() && expenseType == .recurrent
    }
    
    private func isCreatingView() -> Bool {
        return expenseData == nil
    }
    
    private func getPaidDate() -> Date? {
        if !isExpensePaid || blockEditingPaidDate() {
            return nil
        }
        
        return paidDate
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
