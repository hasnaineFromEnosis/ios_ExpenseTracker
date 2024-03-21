//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 21/3/24.
//

import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    @Published var pendingExpenseList: [ExpenseDataWrapper] = []
    @Published var paidExpenseList: [ExpenseDataWrapper] = []
    
    let dataService: PersistentContainer = PersistentContainer()
    
    private init() {
        getAllExpenseData()
    }
    
    private func getAllExpenseData() {
        let allExpenseData = dataService.read()
        
        pendingExpenseList.removeAll()
        paidExpenseList.removeAll()
        
        for expense in allExpenseData {
            let expenseData: ExpenseDataWrapper = ExpenseDataWrapper(expenseData: expense)
            
            if let _ = expenseData.paidDate {
                paidExpenseList.append(expenseData)
            } else {
                pendingExpenseList.append(expenseData)
            }
        }
    }
    
    func create(title: String, details: String, category: String, amount: Int, type: ExpenseType) {
        dataService.create(title: title,
                           details: details,
                           category: category,
                           amount: amount,
                           type: type)
        getAllExpenseData()
    }
    
    func read(viewType: ExpenseViewType) ->[ExpenseDataWrapper] {
        
        getAllExpenseData()
        
        switch(viewType) {
        case .paidExpenseView:
            return self.paidExpenseList
        case .pendingExpenseView:
            return self.pendingExpenseList
        }
    }
    
    func update(expenseData: ExpenseDataWrapper,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil,
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil) {
        if let entity = expenseData.entity {
            dataService.update(entity: entity, title: title, details: details, category: category, amount: amount, type: type, creationDate: creationDate, paidDate: paidDate)
        }
    }
    
    func markExpenseAsPending(expenseData: ExpenseDataWrapper) {
        if let entity = expenseData.entity {
            dataService.markExpenseAsPending(entity: entity)
        }
    }
    
    func delete(expenseData: ExpenseDataWrapper) {
        if let entity = expenseData.entity {
            dataService.delete(entity: entity)
        }
    }
    
}
