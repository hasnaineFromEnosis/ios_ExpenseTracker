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
    
    init(color: Color, expenses: [Expense]) {
        self.color = color
        self.expenses = expenses
    }
    
    var body: some View {
        List(expenses) { expense in
            ExpenseRowView(expense: expense)
        }
    }
    
}

#Preview {
    ExpenseView(color: Color.green, expenses: [Expense.getRandomExpense(value: 1),
         Expense.getRandomExpense(value: 2, isPaid: true),
         Expense.getRandomExpense(value: 3)])
}
