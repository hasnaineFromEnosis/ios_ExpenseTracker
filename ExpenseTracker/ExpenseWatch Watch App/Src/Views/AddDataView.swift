//
//  AddDataView.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 7/5/24.
//

import SwiftUI

struct AddDataView: View {
    @Binding var selectedTab: TabViewType
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink(destination: ExpenseEditorView(viewModel: ExpenseEditorViewModel(), selectedTab: $selectedTab)) {
                    getPrimaryTextView(label: "Add Expense")
                }
                
                NavigationLink(destination: AddCategoryView(viewModel: AddCategoryViewModel())) {
                    getPrimaryTextView(label: "Add Category")
                }
                
            }
            .navigationTitle("Add Data")
        }
    }
    
    private func getPrimaryTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.regular)
            .font(.headline)
            .foregroundStyle(.foreground)
    }
}

#Preview {
    AddDataView(selectedTab: .constant(.paidExpenseView))
}
