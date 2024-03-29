//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published private var dataManager = DataManager.shared
    
    // States
    @Published var navigationTitle: String
    @Published var viewType: TabViewType
    @Published var showFilteringPage: Bool = false
    
    // Filer by date
    @Published var isFilteredByDate = false
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var appliedStartDate: Date? = nil
    @Published var appliedEndDate: Date? = nil
    
    // Alert
    @Published var shouldShowAlert = false
    @Published var alertTitle = "Invalid Date"
    @Published var alertMessage = "Start date should be set as before end date"
    
    private var anyCancellable: AnyCancellable? = nil
    
    init(viewType: TabViewType) {
        self.viewType = viewType
        
        switch viewType {
        case .paidExpenseView:
            self.navigationTitle = "Paid Expenses"
        case.pendingExpenseView:
            self.navigationTitle = "Pending Expenses"
        case .settingsView:
            fatalError("This is unexpexted call")
        }
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
    }
    
    var expenseData: [ExpenseData] {
        var expensesList: [ExpenseData] = []
        switch viewType {
        case .pendingExpenseView:
            expensesList = dataManager.pendingExpensesList
        case .paidExpenseView:
            expensesList = dataManager.paidExpensesList
        case .settingsView:
            fatalError("This is unexpexted call")
        }
        
        return expensesList.filter { filterList(expenseData: $0) }
    }
    
    func isFiltered() -> Bool {
        return appliedStartDate != nil && appliedEndDate != nil
    }
    
    private func filterList(expenseData: ExpenseData) -> Bool {
        guard let startDate = appliedStartDate, let endDate = appliedEndDate else {
            return true
        }
        return expenseData.creationDate >= startDate && expenseData.creationDate <= endDate
    }
    
    func validateFilteringData() -> Bool {
        guard isFilteredByDate else {
            clearFilteredState()
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
    
    private func clearFilteredState() {
        isFilteredByDate = false
        appliedStartDate = nil
        appliedEndDate = nil
    }
    
    func initFilteredState() {
        if let appliedEndDate,
           let appliedStartDate {
            isFilteredByDate = true
            startDate = appliedStartDate
            endDate = appliedEndDate
        } else {
            isFilteredByDate = false
            startDate = Date()
            endDate = Date()
        }
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        dataManager.delete(expenseData: expenseData)
    }
}
