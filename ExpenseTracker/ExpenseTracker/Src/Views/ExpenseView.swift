//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    private var viewType: ExpenseViewType
    private var navTitle: String
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    init(viewType: ExpenseViewType, navTitle: String) {
        self.viewType = viewType
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            List(getExpenseList()) { expense in
                NavigationLink {
                    ExpenseDetailView()
                        .navigationTitle(expense.title!)
                        .environmentObject(ExpenseDetailViewModel(expenseData: expense))
                } label: {
                    ExpenseRowView(expense: expense)
                }
            }
            .navigationTitle(self.navTitle)
        }
    }
    
    private func getExpenseList() -> [ExpenseData] {
        switch(viewType) {
        case .pendingExpenseView:
            return expenseViewModel.pendingExpenseData
        case .paidExpenseView:
            return expenseViewModel.paidExpenseData
        case .createNewView:
            fatalError("ExpenseView: Something wrong with the codeflow")
        }
    }
}

#Preview {
    ExpenseView(viewType: .pendingExpenseView, navTitle: "Pending Expenses")
        .environmentObject(ExpenseViewModel())
}
