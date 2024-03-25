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
    }
    
    func create(title: String, details: String, category: String, amount: Int, creationDate: Date, paidDate: Date?, type: ExpenseType) {
        let entity = persistenceController.create(title: title,
                                     details: details,
                                     category: category,
                                     amount: amount,
                                     creationDate: creationDate,
                                     paidDate: paidDate,
                                     type: type)
        if let _ = paidDate {
            paidExpensesList.append(ExpenseData(entity: entity))
        } else {
            pendingExpensesList.append(ExpenseData(entity: entity))
        }
    }
    
    func read() {
        let pendingData = self.persistenceController.read(predicateFormat: "paidDate == nil")
        let paidData = self.persistenceController.read(predicateFormat: "paidDate != nil")
        
        self.pendingExpensesList = convertEntityArrayToData(entities: pendingData)
        self.paidExpensesList = convertEntityArrayToData(entities: paidData)
    }
    
    func update(expenseData: ExpenseData,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil,
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil) {
        if let entity = getExpenseDataEntity(expenseData: expenseData) {
            self.persistenceController.update(entity: entity,
                                              title: title,
                                              details: details,
                                              category: category,
                                              amount: amount,
                                              type: type,
                                              creationDate: creationDate,
                                              paidDate: paidDate)
            self.updatePaidList(for: expenseData)
            self.updatePendingList(for: expenseData)
        }
    }
    
    func markExpenseAsPaid(expnseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            entity.paidDate = Date()
            self.persistenceController.update(entity: entity, paidDate: entity.paidDate)
            if let id = entity.id {
                self.deletePendingExpense(withID: id)
                self.addPaidExpense(ExpenseData(entity: entity))
            }
        }
    }
    
    func markExpenseAsPending(expnseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            entity.paidDate = nil
            self.persistenceController.markExpenseAsPending(entity: entity)
            if let id = entity.id {
                self.deletePaidExpense(withID: id)
                self.addPendingExpense(ExpenseData(entity: entity))
            }
        }
    }
    
    func delete(expnseData: ExpenseData) {
        if let entity = getExpenseDataEntity(expenseData: expnseData) {
            self.persistenceController.delete(entity: entity)
            if let id = entity.id {
                self.deletePaidExpense(withID: id)
                self.deletePendingExpense(withID: id)
            }
        }
    }
    
    private func updatePendingList(for updatedExpenseData: ExpenseData) {
        for var expenseData in self.pendingExpensesList {
            if expenseData.id == updatedExpenseData.id {
                expenseData = updatedExpenseData
                return
            }
        }
    }

    private func updatePaidList(for updatedExpenseData: ExpenseData) {
        for var expenseData in self.paidExpensesList {
            if expenseData.id == updatedExpenseData.id {
                expenseData = updatedExpenseData
                return
            }
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
