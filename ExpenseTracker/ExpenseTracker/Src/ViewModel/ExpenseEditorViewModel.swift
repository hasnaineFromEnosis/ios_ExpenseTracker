//
//  CreateExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import Foundation

enum ExpenseType: String, CaseIterable {
    case random = "Random"
    case recurrent = "Recurrent"
}

class ExpenseEditorViewModel: ObservableObject {
    
    let dataManager = DataManager.shared
    
    // states
    @Published var expenseTitle: String = ""
    @Published var expenseDetails: String = ""
    @Published var expenseCategory: String = ""
    @Published var expenseAmount: String = ""
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
        if let expenseData = expenseData {
            setupWithExistingExpenseData(expenseData)
        }
    }
    
    private func setupWithExistingExpenseData(_ expenseData: ExpenseData) {
        expenseTitle = expenseData.title
        expenseDetails = expenseData.details
        expenseCategory = expenseData.category
        expenseAmount = String(expenseData.amount)
        creationDate = expenseData.creationDate
        paidDate = expenseData.paidDate ?? Date()
        isExpensePaid = expenseData.paidDate != nil
        expenseType = expenseData.type == ExpenseType.recurrent.rawValue ? .recurrent : .random
        
        navigationTitle = "Update Expense"
        createExpenseButtonText = "Update"
    }
    
    func validateData() -> Bool {
        guard !expenseTitle.isEmpty, !expenseDetails.isEmpty, !expenseCategory.isEmpty, !expenseAmount.isEmpty else {
            showInvalidDataAlert = true
            return false
        }
        
        return expenseData != nil ? updateExpense() : createExpense()
    }
    
    func createExpense() -> Bool {
        guard let expenseAmount = Int(expenseAmount) else {
            showInvalidAmountAlert()
            return false
        }
        
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
    
    func updateExpense() -> Bool {
        guard var expenseData = expenseData, let amount = Int(expenseAmount) else {
            showInvalidAmountAlert()
            return false
        }
        
        expenseData.title = expenseTitle
        expenseData.details = expenseDetails
        expenseData.category = expenseCategory
        expenseData.amount = amount
        expenseData.type = expenseType.rawValue
        expenseData.creationDate = creationDate
        expenseData.paidDate = getPaidDate()
        
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
    
    private func showInvalidAmountAlert() {
        alertMessage = "Please enter a realistic amount of money."
        showInvalidDataAlert = true
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
