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
        createRecurrentExpenses()
    }
    
    func createExpense(title: String, details: String, category: String, amount: Int, creationDate: Date, paidDate: Date?, type: ExpenseType, isBaseRecurrent: Bool = false) {
        let entity = persistentStore.createExpense(title: title,
                                                   details: details,
                                                   category: category,
                                                   amount: amount,
                                                   creationDate: creationDate,
                                                   paidDate: paidDate,
                                                   type: type,
                                                   isBaseRecurrent: isBaseRecurrent)
        let expenseData = ExpenseData(entity: entity)
        firebaseManager.saveExpenseData(expense: expenseData)
        if isBaseRecurrent {
            baseRecurrentExpenseList.append(expenseData)
            createRecurrentExpenses(from: expenseData)
            createExpense(title: title,
                   details: details,
                   category: category,
                   amount: amount,
                   creationDate: creationDate,
                   paidDate: paidDate,
                   type: type,
                   isBaseRecurrent: false)
        } else {
            if paidDate != nil {
                paidExpensesList.append(expenseData)
            } else {
                pendingExpensesList.append(expenseData)
            }
        }
    }
    
    func createCategory(title: String, isPredefined: Bool) {
        let entity = persistentStore.createCategory(title: title, isPredefined: isPredefined)
        let categoryData = CategoryData(entity: entity)
        categoryList.append(categoryData)
        firebaseManager.saveCategoryData(category: categoryData)
    }
    
    func fetchExpenses() {
        pendingExpensesList = convertExpenseEntityArrayToData(entities: persistentStore.fetchExpenses(predicateFormat: "paidDate == nil && isBaseRecurrent == false"))
        paidExpensesList = convertExpenseEntityArrayToData(entities: persistentStore.fetchExpenses(predicateFormat: "paidDate != nil && isBaseRecurrent == false"))
        baseRecurrentExpenseList = convertExpenseEntityArrayToData(entities: persistentStore.fetchExpenses(predicateFormat: "isBaseRecurrent == true"))
    }
    
    func fetchCategory() {
        categoryList = convertCategoryEntityArrayToData(entities: persistentStore.fetchCategory())
        
        if categoryList.isEmpty {
            createCategory(title: "Others", isPredefined: true)
        }
    }
    
    func updateExpense(expenseData: ExpenseData,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil,
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil,
                isBaseRecurrent: Bool = false) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            persistentStore.updateExpense(entity: entity,
                                          title: title,
                                          details: details,
                                          category: category,
                                          amount: amount,
                                          type: type,
                                          creationDate: creationDate,
                                          paidDate: paidDate)
            if isBaseRecurrent {
                updateBaseRecurrentExpenseList(for: expenseData)
            } else {
                updatePaidList(for: expenseData)
                updatePendingList(for: expenseData)
                if let paidDate = paidDate {
                    markExpenseAsPaid(expenseData: expenseData, paidDate: paidDate)
                } else {
                    markExpenseAsPending(expenseData: expenseData)
                }
            }
        }
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            deleteExpense(entity: entity)
        }
    }
    
    func deleteCategory(categoryData: CategoryData) {
        if let entity = getCategoryDataEntity(categoryData: categoryData) {
            deleteCategory(entity: entity)
        }
    }
    
    func markExpenseAsPaid(expenseData: ExpenseData, paidDate: Date? = nil) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            entity.paidDate = paidDate ?? Date()
            persistentStore.updateExpense(entity: entity, paidDate: entity.paidDate)
            deleteLocally(entity: entity)
            addPaidExpense(ExpenseData(entity: entity))
        }
    }
    
    func markExpenseAsPending(expenseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            entity.paidDate = nil
            persistentStore.markExpenseAsPending(entity: entity)
            deleteLocally(entity: entity)
            addPendingExpense(ExpenseData(entity: entity))
        }
    }
    
    // MARK: Private Methods
    
    private func createRecurrentExpenses() {
        baseRecurrentExpenseList.forEach { createRecurrentExpenses(from: $0) }
    }
    
    private func createRecurrentExpenses(from baseExpense: ExpenseData) {
        let newExpenses = RecurrentExpenseManager.generateNecessaryRecurrentExpenses(for: baseExpense)
        newExpenses.forEach {
            createExpense(title: $0.title,
                   details: $0.details,
                   category: $0.category,
                   amount: $0.amount,
                   creationDate: $0.creationDate,
                   paidDate: nil,
                   type: ExpenseType.recurrent)
        }
        updateExpense(expenseData: baseExpense, paidDate: Date(), isBaseRecurrent: true)
    }
    
    private func deleteExpense(entity: ExpenseDataEntity) {
        if let id = entity.id {
            deletePaidExpense(withID: id)
            deletePendingExpense(withID: id)
        }
        persistentStore.deleteExpense(entity: entity)
    }
    
    private func deleteCategory(entity: CategoryDataEntity) {
        if let id = entity.id {
            deleteCategory(withID: id)
        }
        persistentStore.deleteCategory(entity: entity)
    }
    
    private func deleteLocally(entity: ExpenseDataEntity) {
        if let id = entity.id {
            self.deletePaidExpense(withID: id)
            self.deletePendingExpense(withID: id)
        }
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
    
    private func getExpenseDataEntity(expenseData: ExpenseData) -> ExpenseDataEntity? {
        let predicate = NSPredicate(format: "id = %@", expenseData.id as CVarArg)
        let result = self.persistentStore.fetchFirst(ExpenseDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(let error):
            print("Error fetching ExpenseDataEntity: \(error)")
            return nil
        }
    }
    
    private func getCategoryDataEntity(categoryData: CategoryData) -> CategoryDataEntity? {
        let predicate = NSPredicate(format: "id = %@", categoryData.id as CVarArg)
        let result = self.persistentStore.fetchFirst(CategoryDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(let error):
            print("Error fetching CategoryDataEntity: \(error)")
            return nil
        }
    }
    
    private func convertExpenseEntityArrayToData(entities: [ExpenseDataEntity]) -> [ExpenseData] {
        return entities.map(ExpenseData.init)
    }
    
    private func convertCategoryEntityArrayToData(entities: [CategoryDataEntity]) -> [CategoryData] {
        return entities.map(CategoryData.init)
    }
}
