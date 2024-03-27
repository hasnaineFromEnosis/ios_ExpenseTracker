//
//  CreateExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI
import Combine

struct ExpenseEditorView: View {
    
    @ObservedObject var viewModel: ExpenseEditorViewModel
    @Binding var selectedTab: ExpenseViewType
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Info") {
                    TextField("Title", text: $viewModel.expenseTitle)
                    TextField("Description", text: $viewModel.expenseDetails)
                }
                
                if !viewModel.blockEditingPaidDate() {
                    Section("Date") {
                        Toggle("Add Payment Date", isOn: $viewModel.isExpensePaid)
                        if viewModel.isExpensePaid {
                            DatePicker("Paid Date", selection: $viewModel.paidDate)
                        }
                    }
                }
                
                Section("Category") {
                    TextField("Category", text: $viewModel.expenseCategory)
                }
                
                Section("Expense Details") {
                    TextField("Amount (in taka)", text: $viewModel.expenseAmount)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.expenseAmount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.viewModel.expenseAmount = filtered
                            }
                        }
                    Picker("Expense Type", selection: $viewModel.expenseType) {
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showInvalidDataAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        if viewModel.validateData() {
                            if !viewModel.blockEditingPaidDate()
                                && !viewModel.isExpensePaid {
                                selectedTab = .paidExpenseView
                            } else {
                                selectedTab = .pendingExpenseView
                            }
                            
                            dismiss()
                        }
                    } label: {
                        Text(viewModel.createExpenseButtonText)
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseEditorView(viewModel: ExpenseEditorViewModel(), selectedTab: .constant(.paidExpenseView))
}
