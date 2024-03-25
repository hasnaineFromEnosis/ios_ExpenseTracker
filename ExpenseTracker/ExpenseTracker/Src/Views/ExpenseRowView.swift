//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseRowView: View {
    
    @EnvironmentObject var viewModel: ExpenseRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(viewModel.title)
                    .fontWeight(.medium)
                    .font(.headline)
                
                Text(viewModel.category)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.creationDate)
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.amount)
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                
                if let paidDate = viewModel.paidDate {
                    Text(paidDate)
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    Group {
        ExpenseRowView()
            .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData()))
        Divider()
        ExpenseRowView()
            .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData(isPaid: true)))
    }
}

#Preview {
    ExpenseRowView()
        .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData(isPaid: true)))
}

#Preview {
    ExpenseRowView()
        .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData()))
}
