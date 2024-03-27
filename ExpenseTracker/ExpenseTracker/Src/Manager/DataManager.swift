//
//  DataManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 22/3/24.
//

import Foundation

enum DataManagerType {
    case normal, preview
}

class DataManager: NSObject, ObservableObject {
    
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    
    @Published var pendingExpensesList: [ExpenseData] = []
    @Published var paidExpensesList: [ExpenseData] = []
    @Published var baseRecurrentExpenseList: [ExpenseData] = []
    
    private let persistenceController: PersistenceController
    
    private init(type: DataManagerType) {
        switch(type) {
        case .normal:
            self.persistenceController = PersistenceController()
        case .preview:
            self.persistenceController = PersistenceController(inMemory: true)
        }
        
        super.init()
        self.read()
        self.createRecurrentExpenses()
    }
    
    func create(title: String, details: String, category: String, amount: Int, creationDate: Date, paidDate: Date?, type: ExpenseType, isBaseRecurrent: Bool = false) {
        let entity = persistenceController.create(title: title,
                                                  details: details,
                                                  category: category,
                                                  amount: amount,
                                                  creationDate: creationDate,
                                                  paidDate: paidDate,
                                                  type: type,
                                                  isBaseRecurrent: isBaseRecurrent)
        
        if isBaseRecurrent {
            let baseRecurrentExpense: ExpenseData = ExpenseData(entity: entity)
            baseRecurrentExpenseList.append(baseRecurrentExpense)
            self.createSingleRecurrentExpense(from: baseRecurrentExpense)
            create(title: title,
                   details: details,
                   category: category,
                   amount: amount,
                   creationDate: creationDate,
                   paidDate: paidDate,
                   type: type,
                   isBaseRecurrent: false)
        } else {
            if let _ = paidDate {
                paidExpensesList.append(ExpenseData(entity: entity))
            } else {
                pendingExpensesList.append(ExpenseData(entity: entity))
            }
        }
    }
    
    func read() {
        let pendingData = self.persistenceController.read(predicateFormat: "paidDate == nil && isBaseRecurrent == false")
        let paidData = self.persistenceController.read(predicateFormat: "paidDate != nil && isBaseRecurrent == false")
        let baseRecurrentExpense = self.persistenceController.read(predicateFormat: "isBaseRecurrent == true")
        
        self.pendingExpensesList = convertEntityArrayToData(entities: pendingData)
        self.paidExpensesList = convertEntityArrayToData(entities: paidData)
        self.baseRecurrentExpenseList = convertEntityArrayToData(entities: baseRecurrentExpense)
    }
    
    func update(expenseData: ExpenseData,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil,
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil,
                isBaseRecurrent: Bool = false) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            self.persistenceController.update(entity: entity,
                                              title: title,
                                              details: details,
                                              category: category,
                                              amount: amount,
                                              type: type,
                                              creationDate: creationDate,
                                              paidDate: paidDate)
            if isBaseRecurrent {
                self.updateBaseRecurrentExpenseList(for: expenseData)
            } else {
                self.updatePaidList(for: expenseData)
                self.updatePendingList(for: expenseData)
                if let paidDate {
                    markExpenseAsPaid(expnseData: expenseData, paidDate: paidDate)
                } else {
                    markExpenseAsPending(expnseData: expenseData)
                }
            }
        }
    }
    
    func delete(expnseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            self.delete(entity: entity)
        }
    }
    
    func markExpenseAsPaid(expnseData: ExpenseData, paidDate: Date? = nil) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            entity.paidDate = paidDate == nil ? Date() : paidDate
            self.persistenceController.update(entity: entity, paidDate: entity.paidDate)
            self.deleteLocally(entity: entity)
            self.addPaidExpense(ExpenseData(entity: entity))
        }
    }
    
    func markExpenseAsPending(expnseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            entity.paidDate = nil
            self.persistenceController.markExpenseAsPending(entity: entity)
            self.deleteLocally(entity: entity)
            self.addPendingExpense(ExpenseData(entity: entity))
        }
    }
    
    private func createRecurrentExpenses() {
        for expense in baseRecurrentExpenseList {
            createSingleRecurrentExpense(from: expense)
        }
    }
    
    private func createSingleRecurrentExpense(from baseExpense: ExpenseData) {
        let newExpenses = RecurrentExpenseManager.generateNecessaryRecurrentExpenses(for: baseExpense)
        for newExpense in newExpenses {
            create(title: newExpense.title,
                    details: newExpense.details,
                    category: newExpense.category,
                    amount: newExpense.amount,
                    creationDate: newExpense.creationDate,
                    paidDate: nil,
                    type: ExpenseType.recurrent)
        }
        
        update(expenseData: baseExpense, paidDate: Date(), isBaseRecurrent: true)
    }
    
    
    private func delete(entity: ExpenseDataEntity) {
        if let id = entity.id {
            self.deletePaidExpense(withID: id)
            self.deletePendingExpense(withID: id)
        }
        self.persistenceController.delete(entity: entity)
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
    
    private func addPendingExpense(_ newExpense: ExpenseData) {
        self.pendingExpensesList.append(newExpense)
    }

    private func addPaidExpense(_ newExpense: ExpenseData) {
        self.paidExpensesList.append(newExpense)
    }
    
    private func getExpenseDataEntity(expenseData: ExpenseData) -> ExpenseDataEntity? {
        let predicate = NSPredicate(format: "id = %@", expenseData.id as CVarArg)
        let result = self.persistenceController.fetchFirst(ExpenseDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
    }
    
    private func convertEntityArrayToData(entities: [ExpenseDataEntity]) -> [ExpenseData] {
        var results: [ExpenseData] = []
        
        for entity in entities {
            results.append(ExpenseData(entity: entity))
        }
        
        return results
    }
}
