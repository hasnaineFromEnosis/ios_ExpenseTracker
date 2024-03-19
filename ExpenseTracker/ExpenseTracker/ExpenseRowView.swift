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
                    .fontWeight(.medium)
                    .font(.headline)
                
                Text(expense.category)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formatDate(date: expense.creationDate))
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(expense.amount) taka")
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                
                if let paidDate = expense.paidDate {
                    Text(formatDate(date: paidDate))
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
