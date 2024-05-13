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
    private let watchConnectivityManager: WatchConnectivityManager
    
    private init() {
        self.persistentStore = PersistentStore()
        self.firebaseManager = FirebaseManager()
        self.watchConnectivityManager = WatchConnectivityManager()
        initializeData()
        
        // Assign a callback closure to handle received data
        self.watchConnectivityManager.createExpenseCallback = { [weak self] expenseData in
            self?.createExpense(expenseData: expenseData)
        }
        
        self.watchConnectivityManager.createCategoryCallback = { [weak self] categoryData in
            self?.createCategory(categoryData: categoryData)
        }
    }
    
    func initializeData() {
        fetchExpenses()
        fetchCategory()
    }
    
    func createExpense(expenseData: ExpenseData) {
        persistentStore.createExpense(expenseData: expenseData)
        firebaseManager.saveExpenseData(expense: expenseData)
        if expenseData.sourceType == .iOS {
            self.watchConnectivityManager.sendData(data: expenseData.toDict())
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
        if categoryData.sourceType == .iOS {
            self.watchConnectivityManager.sendData(data: categoryData.toDict())
        }
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
                let categoryData = CategoryData(title: "Others", isPredefined: true, sourceType: .other)
                self.createCategory(categoryData: categoryData)
            }
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
        firebaseManager.saveExpenseData(expense: expenseData)
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        deletePaidExpenseLocally(withID: expenseData.id)
        deletePendingExpenseLocally(withID: expenseData.id)
        
        persistentStore.deleteExpense(expenseData: expenseData)
        firebaseManager.deleteExpenseData(expense: expenseData)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        deleteCategoryLocally(withID: categoryData.id)
        
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
    
    private func mergeData<T: Identifiable & Equatable>(listA: [T], listB: [T], coreDataCreateFunction: (T) -> Void, firebaseCreateFunction: (T) -> Void) -> [T] {
        var idDictionary: [T.ID: Bool] = [:]
        var results: [T] = []
        
        for item in listA {
            idDictionary[item.id] = true
            results.append(item)
        }
        
        for item in listB {
            if idDictionary[item.id] == nil {
                coreDataCreateFunction(item)
                results.append(item)
            }
        }
        
        idDictionary.removeAll()
        for item in listB {
            idDictionary[item.id] = true
        }
        
        for item in listA {
            if idDictionary[item.id] == nil {
                firebaseCreateFunction(item)
            }
        }
        
        return results
    }

    private func mergeExpense(listA: [ExpenseData], listB: [ExpenseData]) -> [ExpenseData] {
        return mergeData(listA: listA, listB: listB, coreDataCreateFunction: { persistentStore.createExpense(expenseData: $0) }, firebaseCreateFunction: { firebaseManager.saveExpenseData(expense: $0) })
    }

    private func mergeCategory(listA: [CategoryData], listB: [CategoryData]) -> [CategoryData] {
        return mergeData(listA: listA, listB: listB, coreDataCreateFunction: { persistentStore.createCategory(categoryData: $0) }, firebaseCreateFunction: { firebaseManager.saveCategoryData(category: $0) })
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
