//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation

enum ExpenseType: String, CaseIterable {
    case random = "Random"
    case recurrent = "Recurrent"
}

enum ExpenseViewType {
    case pendingExpenseView
    case paidExpenseView
}

class ExpenseViewModel: ObservableObject {
    // save fetched notes for view loading
    @Published var expenseData: [ExpenseData] = []
    
    let dataService = PersistentContainer.shared
    
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
        
        getAllExpenseData()
    }
    
    func getAllExpenseData() {
        let allExpenseData = dataService.read()
        
        expenseData.removeAll()
        
        for expense in allExpenseData {
            if viewType == .paidExpenseView,
               expense.paidDate != nil {
                expenseData.append(expense)
            } else if viewType == .pendingExpenseView,
                      expense.paidDate == nil {
                expenseData.append(expense)
            }
        }
    }
    
    func deleteNotes(expenseData: ExpenseData) {
        dataService.delete(entity: expenseData)
        getAllExpenseData()
    }
}

