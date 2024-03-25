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
            paidExpensesList.append(entity)
        } else {
            pendingExpensesList.append(entity)
        }
    }
    
    func read() {
        self.pendingExpensesList = self.persistenceController.read(predicateFormat: "paidDate == nil")
        self.paidExpensesList = self.persistenceController.read(predicateFormat: "paidDate != nil")
    }
    
    func update(entity: ExpenseData,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil,
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil) {
        self.persistenceController.update(entity: entity,
                                          title: title,
                                          details: details,
                                          category: category, 
                                          amount: amount,
                                          type: type,
                                          creationDate: creationDate,
                                          paidDate: paidDate)
        self.updatePaidList(for: entity)
        self.updatePendingList(for: entity)
        
    }
    
    func markExpenseAsPaid(entity: ExpenseData) {
        entity.paidDate = Date()
        self.persistenceController.update(entity: entity, paidDate: entity.paidDate)
        if let id = entity.id {
            self.deletePendingExpense(withID: id)
            self.addPaidExpense(entity)
        }
    }
    
    func markExpenseAsPending(entity: ExpenseData) {
        entity.paidDate = nil
        self.persistenceController.markExpenseAsPending(entity: entity)
        if let id = entity.id {
            self.deletePaidExpense(withID: id)
            self.addPendingExpense(entity)
        }
    }
    
    func delete(entity: ExpenseData) {
        self.persistenceController.delete(entity: entity)
        if let id = entity.id {
            self.deletePaidExpense(withID: id)
            self.deletePendingExpense(withID: id)
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

}
