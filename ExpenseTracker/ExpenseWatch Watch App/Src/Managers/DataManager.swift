//
//  DataManager.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 6/5/24.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var pendingExpensesList: [ExpenseData] = []
    @Published var paidExpensesList: [ExpenseData] = []
    @Published var baseRecurrentExpenseList: [ExpenseData] = []
    
    @Published var categoryList: [CategoryData] = []
    
    private let persistentStore: PersistentStore
    private let phoneConnectivityManager: PhoneConnectivityManager
    
    private init() {
        self.persistentStore = PersistentStore()
        self.phoneConnectivityManager = PhoneConnectivityManager()
        initializeData()
        
        self.phoneConnectivityManager.expenseOperationCallback = { [weak self] expenseData, operationType in
            switch operationType {
            case .create:
                self?.createExpense(expenseData: expenseData)
            case .update:
                self?.updateExpense(expenseData: expenseData)
            case .delete:
                self?.deleteExpense(expenseData: expenseData)
            }
            
        }
        
        self.phoneConnectivityManager.categoryOperationCallback = { [weak self] categoryData, operationType in
            switch operationType {
            case .create:
                self?.createCategory(categoryData: categoryData)
            case .update:
                fatalError("Wrong operation for category")
            case .delete:
                self?.deleteCategory(categoryData: categoryData)
            }
        }
    }
    
    func initializeData() {
        fetchExpenses()
        fetchCategory()
    }
    
    func createExpense(expenseData: ExpenseData) {
        persistentStore.createExpense(expenseData: expenseData)
        if expenseData.sourceType == .watchOS {
            self.phoneConnectivityManager.sendData(data: expenseData.toDict(), operationType: .create)
        }
        if expenseData.isBaseRecurrent {
            baseRecurrentExpenseList.append(expenseData)
            createRecurrentExpenses(from: expenseData)
            var updatedExpenseData = expenseData
            updatedExpenseData.isBaseRecurrent = false
            createExpense(expenseData: updatedExpenseData)
        } else {
            if expenseData.paidDate != nil {
                addPaidExpenseLocally(expenseData)
            } else {
                addPendingExpenseLocally(expenseData)
            }
        }
    }
    
    func createCategory(categoryData: CategoryData) {
        if categoryData.sourceType == .watchOS {
            self.phoneConnectivityManager.sendData(data: categoryData.toDict(), operationType: .create)
        }
        persistentStore.createCategory(categoryData: categoryData)
        categoryList.append(categoryData)
    }
    
    func fetchExpenses() {
        pendingExpensesList = persistentStore.fetchExpenses(predicateFormat: "paidDate == nil && isBaseRecurrent == false")
        paidExpensesList = persistentStore.fetchExpenses(predicateFormat: "paidDate != nil && isBaseRecurrent == false")
        baseRecurrentExpenseList = persistentStore.fetchExpenses(predicateFormat: "isBaseRecurrent == true")
    }
    
    func fetchCategory() {
        categoryList = persistentStore.fetchCategory()
        
        if self.categoryList.isEmpty {
            let categoryData = CategoryData(title: "Others",
                                            isPredefined: true,
                                            sourceType: .other,
                                            creationDate: Date(),
                                            updateDate: Date())
            self.createCategory(categoryData: categoryData)
        }
    }
    
    func updateExpense(expenseData: ExpenseData) {
        if expenseData.sourceType == .watchOS {
            phoneConnectivityManager.sendData(data: expenseData.toDict(), operationType: .update)
        }
        
        if expenseData.isBaseRecurrent {
            updateBaseRecurrentExpenseListLocally(for: expenseData)
        } else {
            deleteExpenseLocally(expenseData: expenseData)
            if expenseData.paidDate != nil {
                addPaidExpenseLocally(expenseData)
            } else {
                addPendingExpenseLocally(expenseData)
            }
        }
        
        persistentStore.updateExpense(expenseData: expenseData)
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        if expenseData.sourceType == .watchOS {
            phoneConnectivityManager.sendData(data: expenseData.toDict(), operationType: .delete)
        }
        
        deletePaidExpenseLocally(withID: expenseData.id)
        deletePendingExpenseLocally(withID: expenseData.id)
        
        persistentStore.deleteExpense(expenseData: expenseData)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        if categoryData.sourceType == .watchOS {
            phoneConnectivityManager.sendData(data: categoryData.toDict(), operationType: .delete)
        }
        
        deleteCategoryLocally(withID: categoryData.id)
        
        persistentStore.deleteCategory(categoryData: categoryData)
    }
    
    // MARK: Private Methods
    private func createRecurrentExpenses() {
        baseRecurrentExpenseList.forEach { createRecurrentExpenses(from: $0) }
    }
    
    private func createRecurrentExpenses(from baseExpense: ExpenseData) {
        let newExpenses = RecurrentExpenseManager.generateNecessaryRecurrentExpenses(for: baseExpense)
        newExpenses.forEach {
            createExpense(expenseData: $0)
        }
        var updatedExpense = baseExpense
        updatedExpense.paidDate = Date()
        updatedExpense.updateDate = Date()
        updateExpense(expenseData: updatedExpense)
    }
    
    private func deleteExpenseLocally(expenseData: ExpenseData) {
        self.deletePaidExpenseLocally(withID: expenseData.id)
        self.deletePendingExpenseLocally(withID: expenseData.id)
    }
    
    private func updateBaseRecurrentExpenseListLocally(for updatedExpenseData: ExpenseData) {
        if let index = self.baseRecurrentExpenseList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.baseRecurrentExpenseList[index] = updatedExpenseData
        }
    }
    
    private func deletePendingExpenseLocally(withID id: UUID) {
        if let index = self.pendingExpensesList.firstIndex(where: { $0.id == id }) {
            self.pendingExpensesList.remove(at: index)
        }
    }
    
    private func deletePaidExpenseLocally(withID id: UUID) {
        if let index = self.paidExpensesList.firstIndex(where: { $0.id == id }) {
            self.paidExpensesList.remove(at: index)
        }
    }
    
    private func deleteCategoryLocally(withID id: UUID) {
        if let index = self.categoryList.firstIndex(where: { $0.id == id }) {
            self.categoryList.remove(at: index)
        }
    }
    
    private func addPendingExpenseLocally(_ newExpense: ExpenseData) {
        self.pendingExpensesList.append(newExpense)
    }
    
    private func addPaidExpenseLocally(_ newExpense: ExpenseData) {
        self.paidExpensesList.append(newExpense)
    }
}

