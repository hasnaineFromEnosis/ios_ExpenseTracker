//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation

enum ExpenseViewType {
    case pendingExpenseView
    case paidExpenseView
}

class ExpenseViewModel: ObservableObject {
    
    let coreDataService: CoreDataManager = CoreDataManager.shared
    
    // states
    @Published var navigationTitle: String
    @Published var viewType: ExpenseViewType
    
    init(viewType: ExpenseViewType) {
        self.viewType = viewType
        
        switch (viewType) {
        case .paidExpenseView:
            self.navigationTitle = "Paid Expenses"
        case.pendingExpenseView:
            self.navigationTitle = "Pending Expenses"
        }
    }
    
    func getExpenseData() -> [ExpenseDataWrapper] {
        switch(viewType) {
        case .paidExpenseView:
            return coreDataService.paidExpenseList
        case .pendingExpenseView:
            return coreDataService.pendingExpenseList
        }
    }
    
    func deleteExpense(expenseData: ExpenseDataWrapper) {
        coreDataService.delete(expenseData: expenseData)
    }
}

