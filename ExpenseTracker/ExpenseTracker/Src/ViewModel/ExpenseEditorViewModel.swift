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
    @Published var expenseTitle: String = ""
    @Published var expenseDetails: String = ""
    @Published var expenseCategory: String = "Others"
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
    
    var categoryDataList: [String] {
        getTitleFromCategoryData()
    }
    private var expenseData: ExpenseData?
    
    init(expenseData: ExpenseData? = nil) {
        self.expenseData = expenseData
        self.expenseCategory = self.categoryDataList.first ?? "Others"
        if let expenseData = expenseData {
            setupWithExistingExpenseData(expenseData)
        }
    }
    
    func validateData() -> Bool {
        guard !expenseTitle.isEmpty, !expenseDetails.isEmpty, !expenseCategory.isEmpty, !expenseAmount.isEmpty else {
            showInvalidDataAlert = true
            return false
        }
        
        return isCreatingView() ? createExpense() : updateExpense()
    }
    
    func createExpense() -> Bool {
        guard let expenseAmount = Int(expenseAmount) else {
            showInvalidAmountAlert()
            return false
        }
        
        var sourceType: DataSourceType = .other
        
#if os(iOS)
        sourceType = .iOS
#elseif os(watchOS)
        sourceType = .watchOS
#endif
        
        let newExpense = ExpenseData(title: expenseTitle,
                                     details: expenseDetails,
                                     amount: expenseAmount,
                                     category: expenseCategory,
                                     type: expenseType.rawValue,
                                     sourceType: sourceType, 
                                     creationDate: creationDate,
                                     paidDate: getPaidDate(),
                                     isBaseRecurrent: expenseType == .recurrent)
        
        dataManager.createExpense(expenseData: newExpense)
        
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
        
        dataManager.updateExpense(expenseData: expenseData)
        return true
    }
    
    func blockEditingPaidDate() -> Bool {
        return isCreatingView() && expenseType == .recurrent
    }
    
    // Private Methods
    
    private func setupWithExistingExpenseData(_ expenseData: ExpenseData) {
        expenseTitle = expenseData.title
        expenseDetails = expenseData.details
        expenseCategory = getProperCategoryData(for: expenseData.category)
        expenseAmount = String(expenseData.amount)
        creationDate = expenseData.creationDate
        paidDate = expenseData.paidDate ?? Date()
        isExpensePaid = expenseData.paidDate != nil
        expenseType = ExpenseType.getTypeFromValue(value: expenseData.type)
        
        navigationTitle = "Update Expense"
        createExpenseButtonText = "Update"
    }
    
    private func getProperCategoryData(for category: String) -> String {
        return categoryDataList.contains(category)
        ? category
        : categoryDataList.first ?? "Other"
    }
    
    private func showInvalidAmountAlert() {
        alertMessage = "Please enter a realistic amount of money."
        showInvalidDataAlert = true
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
    
    private func getTitleFromCategoryData() -> [String] {
        var results: [String] = []
        
        for categoryData in dataManager.categoryList {
            results.append(categoryData.title)
        }
        return results
    }
    
    private func clearState() {
        expenseTitle = ""
        expenseDetails = ""
        expenseCategory = self.categoryDataList.first ?? "Others"
        expenseAmount = ""
        alertMessage = "Please ensure that each field is filled out accurately."
    }
}
