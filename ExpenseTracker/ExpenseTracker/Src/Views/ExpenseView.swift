//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    private var color: Color
    private var expenses: [Expense]
    private var navTitle: String
    
    init(color: Color, expenses: [Expense], navTitle: String) {
        self.color = color
        self.expenses = expenses
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            List(expenses) { expense in
                NavigationLink {
                    ExpenseDetailView(expense: expense)
                        .navigationTitle(expense.title)
                } label: {
                    ExpenseRowView(expense: expense)
                }
            }
            .navigationTitle(self.navTitle)
        }
    }
    
}

#Preview {
    ExpenseView(color: Color.green, expenses: [Expense.getRandomExpense(value: 1),
         Expense.getRandomExpense(value: 2, isPaid: true),
         Expense.getRandomExpense(value: 3)],
            navTitle: "Pending Expense"
    )
}
