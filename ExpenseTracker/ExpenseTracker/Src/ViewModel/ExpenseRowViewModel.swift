//
//  ExpenseRowViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 21/3/24.
//

import Foundation

class ExpenseRowViewModel: ObservableObject {

    let coreDataService: CoreDataManager = CoreDataManager.shared
    
    // states
    @Published var expenseData: ExpenseDataWrapper
    
    @Published var title: String = "Untitled"
    @Published var amount: String = "0 taka"
    @Published var category: String = "Empty Category"
    @Published var creationDate: String = ""
    @Published var paidDate: String? = nil
    
    init(expenseData: ExpenseDataWrapper) {
        self.expenseData = expenseData
        self.updateData()
    }
    
    private func updateData() {
        self.title = expenseData.title
        self.amount = "\(expenseData.amount) taka"
        self.category = expenseData.category
        self.creationDate = formatDate(date: expenseData.creationDate)
        self.paidDate = expenseData.paidDate != nil ? formatDate(date: expenseData.paidDate!) : nil
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: Date.FormatStyle.DateStyle.abbreviated,
                              time: .omitted)
    }
}

