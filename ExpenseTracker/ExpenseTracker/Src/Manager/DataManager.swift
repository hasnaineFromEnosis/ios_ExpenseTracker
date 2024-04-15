//
//  DataManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 22/3/24.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var pendingExpensesList: [ExpenseData] = []
    @Published var paidExpensesList: [ExpenseData] = []
    @Published var baseRecurrentExpenseList: [ExpenseData] = []
    
    @Published var categoryList: [CategoryData] = []
    
    private let persistentStore: PersistentStore
    private let firebaseManager: FirebaseManager
    
    private init() {
        self.persistentStore = PersistentStore()
        self.firebaseManager = FirebaseManager()
        initializeData()
    }
    
    func initializeData() {
        fetchExpenses()
        fetchCategory()
    }
    
    func createExpense(expenseData: ExpenseData) {
        persistentStore.createExpense(expenseData: expenseData)
        firebaseManager.saveExpenseData(expense: expenseData)
        if expenseData.isBaseRecurrent {
            baseRecurrentExpenseList.append(expenseData)
            createRecurrentExpenses(from: expenseData)
            var updatedExpenseData = expenseData
            updatedExpenseData.isBaseRecurrent = false
            createExpense(expenseData: updatedExpenseData)
        } else {
            if expenseData.paidDate != nil {
                paidExpensesList.append(expenseData)
            } else {
                pendingExpensesList.append(expenseData)
            }
        }
    }
    
    func createCategory(categoryData: CategoryData) {
        persistentStore.createCategory(categoryData: categoryData)
        categoryList.append(categoryData)
        firebaseManager.saveCategoryData(category: categoryData)
    }
    
    func fetchExpenses() {
        pendingExpensesList = persistentStore.fetchExpenses(predicateFormat: "paidDate == nil && isBaseRecurrent == false")
        paidExpensesList = persistentStore.fetchExpenses(predicateFormat: "paidDate != nil && isBaseRecurrent == false")
        baseRecurrentExpenseList = persistentStore.fetchExpenses(predicateFormat: "isBaseRecurrent == true")
        
        
        firebaseManager.fetchExpenses { pendingExpensesList, paidExpensesList, baseRecurrentExpenseList in
            self.pendingExpensesList = self.mergeExpense(listA: self.pendingExpensesList, listB: pendingExpensesList)
            self.paidExpensesList = self.mergeExpense(listA: self.paidExpensesList, listB: paidExpensesList)
            self.baseRecurrentExpenseList = self.mergeExpense(listA: self.baseRecurrentExpenseList, listB: baseRecurrentExpenseList)
            
            self.createRecurrentExpenses()
        }
    }
    
    func fetchCategory() {
        categoryList = persistentStore.fetchCategory()
        
        firebaseManager.fetchCategories { categoryList in
            self.categoryList = self.mergeCategory(listA: self.categoryList, listB: categoryList)
            if self.categoryList.isEmpty {
                let categoryData = CategoryData(title: "Others", isPredefined: true)
                self.createCategory(categoryData: categoryData)
            }
        }
    }
    
    func updateExpense(expenseData: ExpenseData) {
        if expenseData.isBaseRecurrent {
            updateBaseRecurrentExpenseList(for: expenseData)
        } else {
            deleteLocally(expenseData: expenseData)
            if let paidDate = expenseData.paidDate {
                addPaidExpense(expenseData)
            } else {
                addPendingExpense(expenseData)
            }
        }
        
        persistentStore.updateExpense(expenseData: expenseData)
        firebaseManager.saveExpenseData(expense: expenseData)
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        deletePaidExpense(withID: expenseData.id)
        deletePendingExpense(withID: expenseData.id)
        
        persistentStore.deleteExpense(expenseData: expenseData)
        firebaseManager.deleteExpenseData(expense: expenseData)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        deleteCategory(withID: categoryData.id)
        persistentStore.deleteCategory(categoryData: categoryData)
        firebaseManager.deleteCategoryData(category: categoryData)
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
    
    private func mergeExpense(listA: [ExpenseData], listB: [ExpenseData]) -> [ExpenseData] {
        var idCoreData: [UUID: Bool] = [:]
        var results: [ExpenseData] = []
        
        for expense in listA {
            idCoreData[expense.id] = true
            results.append(expense)
        }
        
        for expense in listB {
            if idCoreData[expense.id] == nil {
                let _ = persistentStore.createExpense(expenseData: expense)
                results.append(expense)
            }
        }
        
        idCoreData.removeAll()
        
        for expense in listB {
            idCoreData[expense.id] = true
        }
        
        for expense in listA {
            if idCoreData[expense.id] == nil {
                firebaseManager.saveExpenseData(expense: expense)
            }
        }
        
        return results
    }
    
    private func mergeCategory(listA: [CategoryData], listB: [CategoryData]) -> [CategoryData] {
        var idCoreData: [UUID: Bool] = [:]
        var results: [CategoryData] = []
        
        for category in listA {
            idCoreData[category.id] = true
            results.append(category)
        }
        
        for category in listB {
            if idCoreData[category.id] == nil {
                let _ = persistentStore.createCategory(categoryData: category)
                
                results.append(category)
            }
        }
        
        idCoreData.removeAll()
        
        for category in listB {
            idCoreData[category.id] = true
        }
        
        for category in listA {
            if idCoreData[category.id] == nil {
                firebaseManager.saveCategoryData(category: category)
            }
        }
        
        return results
    }
    
    private func deleteLocally(expenseData: ExpenseData) {
        self.deletePaidExpense(withID: expenseData.id)
        self.deletePendingExpense(withID: expenseData.id)
    }
    
    private func updatePendingList(for updatedExpenseData: ExpenseData) {
        if let index = self.pendingExpensesList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.pendingExpensesList[index] = updatedExpenseData
        }
    }
    
    private func updatePaidList(for updatedExpenseData: ExpenseData) {
        if let index = self.paidExpensesList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.paidExpensesList[index] = updatedExpenseData
        }
    }
    
    private func updateBaseRecurrentExpenseList(for updatedExpenseData: ExpenseData) {
        if let index = self.baseRecurrentExpenseList.firstIndex(where: { $0.id == updatedExpenseData.id }) {
            self.baseRecurrentExpenseList[index] = updatedExpenseData
        }
    }
    
    private func deletePendingExpense(withID id: UUID) {
        if let index = self.pendingExpensesList.firstIndex(where: { $0.id == id }) {
            self.pendingExpensesList.remove(at: index)
        }
    }
    
    private func deletePaidExpense(withID id: UUID) {
        if let index = self.paidExpensesList.firstIndex(where: { $0.id == id }) {
            self.paidExpensesList.remove(at: index)
        }
    }
    
    private func deleteCategory(withID id: UUID) {
        if let index = self.categoryList.firstIndex(where: { $0.id == id }) {
            self.categoryList.remove(at: index)
        }
    }
    
    private func addPendingExpense(_ newExpense: ExpenseData) {
        self.pendingExpensesList.append(newExpense)
    }
    
    private func addPaidExpense(_ newExpense: ExpenseData) {
        self.paidExpensesList.append(newExpense)
    }
}
