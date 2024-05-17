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
        
        self.watchConnectivityManager.expenseOperationCallback = { [weak self] expenseData, operationType in
            switch operationType {
            case .create:
                self?.createExpense(expenseData: expenseData)
            case .update:
                self?.updateExpense(expenseData: expenseData)
            case .delete:
                self?.deleteExpense(expenseData: expenseData)
            case .synchronize:
                fatalError("Wrong operation for category")
            }
            
        }
        
        self.watchConnectivityManager.categoryOperationCallback = { [weak self] categoryData, operationType in
            switch operationType {
            case .create:
                self?.createCategory(categoryData: categoryData)
            case .delete:
                self?.deleteCategory(categoryData: categoryData)
            case .update, .synchronize:
                fatalError("Wrong operation for category")
            }
        }
        
        self.watchConnectivityManager.syncDataCallBack = { [weak self] lastSyncTime in
            DispatchQueue.global(qos: .background).async {
                self?.syncData(for: lastSyncTime)
            }
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
            self.watchConnectivityManager.sendData(data: expenseData.toDict(), operationType: .create)
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
            self.watchConnectivityManager.sendData(data: categoryData.toDict(), operationType: .create)
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
                let categoryData = CategoryData(title: "Others", isPredefined: true, sourceType: .other, creationDate: Date(), updateDate: Date())
                self.createCategory(categoryData: categoryData)
            }
        }
    }
    
    func updateExpense(expenseData: ExpenseData) {
        if expenseData.sourceType == .iOS {
            watchConnectivityManager.sendData(data: expenseData.toDict(), operationType: .update)
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
        firebaseManager.saveExpenseData(expense: expenseData)
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        if expenseData.sourceType == .iOS {
            watchConnectivityManager.sendData(data: expenseData.toDict(), operationType: .delete)
        }
        deletePaidExpenseLocally(withID: expenseData.id)
        deletePendingExpenseLocally(withID: expenseData.id)
        
        persistentStore.deleteExpense(expenseData: expenseData)
        firebaseManager.deleteExpenseData(expense: expenseData)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        if categoryData.sourceType == .iOS {
            watchConnectivityManager.sendData(data: categoryData.toDict(), operationType: .delete)
        }
        
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
        updatedExpense.sourceType = DataSourceType.iOS
        updatedExpense.updateDate = Date()
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
    
    private func syncData(for date: Date) {
        for paidExpense in self.paidExpensesList {
            if paidExpense.creationDate > date {
                self.watchConnectivityManager.sendData(data: paidExpense.toDict(), operationType: .create)
            } else if paidExpense.updateDate > date {
                self.watchConnectivityManager.sendData(data: paidExpense.toDict(), operationType: .update)
            }
        }
        
        for pendingExpense in self.pendingExpensesList {
            if pendingExpense.creationDate > date {
                self.watchConnectivityManager.sendData(data: pendingExpense.toDict(), operationType: .create)
            } else if pendingExpense.updateDate > date {
                self.watchConnectivityManager.sendData(data: pendingExpense.toDict(), operationType: .update)
            }
        }
        
        for baseRecurrentExpense in self.baseRecurrentExpenseList {
            if baseRecurrentExpense.creationDate > date {
                self.watchConnectivityManager.sendData(data: baseRecurrentExpense.toDict(), operationType: .create)
            } else if baseRecurrentExpense.updateDate > date {
                self.watchConnectivityManager.sendData(data: baseRecurrentExpense.toDict(), operationType: .update)
            }
        }
        
        for category in self.categoryList {
            if category.creationDate > date {
                self.watchConnectivityManager.sendData(data: category.toDict(), operationType: .create)
            }
        }
    }
}
