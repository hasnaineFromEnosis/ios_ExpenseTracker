//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseRowView: View {
    private var expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(expense.title)
                    .fontWeight(.bold)
                    .font(.title2)
                
                Text(expense.category)
                    .fontWeight(.light)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formatDate(date: expense.creationDate))
                    .fontWeight(.light)
                    .font(.caption)
                
                Text("\(expense.amount) taka")
                    .fontWeight(.medium)
                    .font(.subheadline)
                
                if let paidDate = expense.paidDate {
                    Text(formatDate(date: paidDate))
                        .fontWeight(.light)
                        .font(.caption)
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        return date.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .omitted)
    }
}

#Preview {
    Group {
        ExpenseRowView(expense: Expense.getRandomExpense(value: 5))
        Divider()
        ExpenseRowView(expense: Expense.getRandomExpense(value: 6, isPaid: true))
    }
}

#Preview {
    ExpenseRowView(expense: Expense.getRandomExpense(value: 2, isPaid: true))
}

#Preview {
    ExpenseRowView(expense: Expense.getRandomExpense(value: 4))
}
