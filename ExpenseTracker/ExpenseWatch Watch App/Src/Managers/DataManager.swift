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
        
        // Assign a callback closure to handle received data
        self.phoneConnectivityManager.dataReceivedCallback = { [weak self] expenseData in
            self?.createExpense(expenseData: expenseData, cameFromiPhone: true)
        }
    }
    
    func initializeData() {
        fetchExpenses()
        fetchCategory()
    }
    
    func createExpense(expenseData: ExpenseData, cameFromiPhone: Bool = false) {
        persistentStore.createExpense(expenseData: expenseData)
        if !cameFromiPhone {
            self.phoneConnectivityManager.sendData(data: expenseData)
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
            let categoryData = CategoryData(title: "Others", isPredefined: true)
            self.createCategory(categoryData: categoryData)
        }
    }
    
    func updateExpense(expenseData: ExpenseData) {
        if expenseData.isBaseRecurrent {
            updateBaseRecurrentExpenseListLocally(for: expenseData)
        } else {
            deleteExpenseLocally(expenseData: expenseData)
            if let paidDate = expenseData.paidDate {
                addPaidExpenseLocally(expenseData)
            } else {
                addPendingExpenseLocally(expenseData)
            }
        }
        
        persistentStore.updateExpense(expenseData: expenseData)
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        deletePaidExpenseLocally(withID: expenseData.id)
        deletePendingExpenseLocally(withID: expenseData.id)
        
        persistentStore.deleteExpense(expenseData: expenseData)
    }
    
    func deleteCategory(categoryData: CategoryData) {
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
        updateExpense(expenseData: updatedExpense)
    }
    
    private func deleteExpenseLocally(expenseData: ExpenseData) {
        self.deletePaidExpenseLocally(withID: expenseData.id)
        self.deletePendingExpenseLocally(withID: expenseData.id)
    }
    
    private func updatePendingListLocally(for updatedExpenseData: ExpenseData) {
        if let index = self.pendingExpensesList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.pendingExpensesList[index] = updatedExpenseData
        }
    }
    
    private func updatePaidListLocally(for updatedExpenseData: ExpenseData) {
        if let index = self.paidExpensesList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.paidExpensesList[index] = updatedExpenseData
        }
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

