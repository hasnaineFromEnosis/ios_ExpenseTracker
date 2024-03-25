//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(getExpenseList()) { expense in
                    NavigationLink {
                        ExpenseDetailView(viewModel: ExpenseDetailViewModel(expenseData: expense))
                    } label: {
                        ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: expense))
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.showAlert.toggle()
                        }) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle" + (viewModel.isFilteredByDate ?  ".fill" : ""))
                        }
                        .popover(isPresented: $viewModel.showAlert) {
                            Form() {
                                Section("Filter By Date") {
                                    Toggle("Filter By Date", isOn: $viewModel.isFilteredByDate)
                                    
                                    if viewModel.isFilteredByDate {
                                        DatePicker("Start Date", selection: $viewModel.startDate)
                                        DatePicker("End Date", selection: $viewModel.endDate)
                                    }
                                }
                            }
                        }
                    }
                }
                if viewModel.viewType == ExpenseViewType.pendingExpenseView {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink {
                                ExpenseEditorView(viewModel: ExpenseEditorViewModel())
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
    
    private func getExpenseList() -> [ExpenseData] {
        return viewModel.expenseData
    }
}

#Preview {
    ExpenseView(viewModel: ExpenseViewModel(viewType: .pendingExpenseView))
}
