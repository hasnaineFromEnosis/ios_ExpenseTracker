//
//  CategoryManagementView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 29/3/24.
//

import SwiftUI

struct CategoryManagementView: View {
    
    @StateObject var viewModel = CategoryManagementViewModel()
    var body: some View {
        List(viewModel.categoryDataList) { categoryData in
            Text(categoryData.title)
                .swipeActions {
                    if !categoryData.isPredefined {
                        Button(role: .destructive) {
                            viewModel.deleteCategory(categoryData: categoryData)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
        }
        .navigationTitle("Category Management")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showAlert = true
                } label: {
                    Label("New", systemImage: viewModel.toolbarPlusImageName)
                }
                .alert(viewModel.categoryTitle, isPresented: $viewModel.showAlert, actions: {
                    TextField("Title", text: $viewModel.categoryTitle)
                    Button("Save", action: {
                        viewModel.createCategory()
                        viewModel.clearState()
                    })
                    Button("Cancel", role: .cancel, action: { viewModel.clearState() })
                }) {
                    Text("Create a new category")
                }
            }
        }
    }
}

#Preview {
    CategoryManagementView()
}
