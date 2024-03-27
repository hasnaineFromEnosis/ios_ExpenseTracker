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
    @Published var appliedStartDate: Date? = nil
    @Published var appliedEndDate: Date? = nil
    
    @Published var shouldShowAlert = false
    @Published var alertTitle = "Invalid Date"
    @Published var alertMessage = "Start date should be set as before end date"
    
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
    
    func validateFilteringData() -> Bool {
        if isFilteredByDate == false {
            appliedStartDate = nil
            appliedEndDate = nil
            return true
        }
        if startDate > endDate {
            shouldShowAlert = true
            return false
        }
        
        appliedStartDate = startDate
        appliedEndDate = endDate
        return true
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        dataManager.delete(expnseData: expenseData)
    }
}
