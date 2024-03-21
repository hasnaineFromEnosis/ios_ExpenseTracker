//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.expenseList) { expense in
                    NavigationLink {
                        ExpenseDetailView()
                            .navigationTitle(expense.title)
                            .environmentObject(ExpenseDetailViewModel(expenseData: expense))
                    } label: {
                        ExpenseRowView()
                            .environmentObject(ExpenseRowViewModel(expenseData: expense))
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteExpense(expenseData: expense)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle(viewModel.navigationTitle)
                
                if viewModel.viewType == ExpenseViewType.pendingExpenseView {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink {
                                CreateExpenseView()
                                    .environmentObject(CreateExpenseViewModel())
                            } label: {
                                PlusCircleView()
                            }
                            .padding()
                            .padding([.trailing, .bottom], 20)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseView()
        .environmentObject(ExpenseViewModel(viewType: .pendingExpenseView))
}
