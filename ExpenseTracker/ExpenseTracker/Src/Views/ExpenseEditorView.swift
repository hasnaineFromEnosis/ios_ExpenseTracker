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
    @Binding var selectedTab: TabViewType
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                expenseInfoSection
                dateSection
                categorySection
                expenseDetailsSection
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
                        handleDoneButtonTap()
                    } label: {
                        Text(viewModel.createExpenseButtonText)
                    }
                }
            }
        }
    }
    
    private var expenseInfoSection: some View {
        Section("Expense Info") {
            TextField("Title", text: $viewModel.expenseTitle)
            TextField("Description", text: $viewModel.expenseDetails)
        }
    }
    
    private var dateSection: some View {
        Section("Date") {
            DatePicker("Creation Date", selection: $viewModel.creationDate)
            if !viewModel.blockEditingPaidDate() {
                Toggle("Add Payment Date", isOn: $viewModel.isExpensePaid)
                if viewModel.isExpensePaid {
                    DatePicker("Paid Date", selection: $viewModel.paidDate)
                }
            }
        }
    }
    
    private var categorySection: some View {
        Section("Category") {
            Picker("Category", selection: $viewModel.expenseCategory) {
                ForEach(viewModel.categoryDataList, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
        }
    }
    
    private var expenseDetailsSection: some View {
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
    
    private func handleDoneButtonTap() {
        if viewModel.validateData() {
            if viewModel.blockEditingPaidDate() {
                selectedTab = .pendingExpenseView
            } else {
                selectedTab = viewModel.isExpensePaid
                    ? .paidExpenseView
                    : .pendingExpenseView
            }
            dismiss()
        }
    }
}

#Preview {
    ExpenseEditorView(viewModel: ExpenseEditorViewModel(), selectedTab: .constant(.paidExpenseView))
}

#Preview {
    ExpenseEditorView(viewModel: ExpenseEditorViewModel(expenseData: ExpenseData.randomExpenseData()), selectedTab: .constant(.paidExpenseView))
}
