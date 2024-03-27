//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation
import Combine

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
    
    @Published private var dataManager = DataManager.shared
    
    // states
    @Published var navigationTitle: String
    @Published var viewType: ExpenseViewType
    @Published var showFilteringPage: Bool = false
    
    // Filer by date
    @Published var isFilteredByDate = false
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    var anyCancellable: AnyCancellable? = nil
    
    init(viewType: ExpenseViewType) {
        self.viewType = viewType
        
        switch viewType {
        case .paidExpenseView:
            self.navigationTitle = "Paid Expenses"
        case.pendingExpenseView:
            self.navigationTitle = "Pending Expenses"
        }
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
    }
    
    var expenseData: [ExpenseData] {
        switch viewType {
        case .pendingExpenseView:
            dataManager.pendingExpensesList.filter {
                if isFilteredByDate {
                    return ($0.creationDate >= startDate && $0.creationDate <= endDate)
                }
                
                return true
            }
        case .paidExpenseView:
            dataManager.paidExpensesList.filter {
                if isFilteredByDate {
                    return ($0.creationDate >= startDate && $0.creationDate <= endDate)
                }
                
                return true
            }
        }
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        dataManager.delete(expnseData: expenseData)
    }
}
