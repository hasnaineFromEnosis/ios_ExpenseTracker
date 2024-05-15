//
//  CategoryManagementView.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 14/5/24.
//

import SwiftUI

struct CategoryManagementView: View {
    
    @StateObject var viewModel = CategoryManagementViewModel()
    var body: some View {
        NavigationView {
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
            .alert(isPresented: $viewModel.showInvalidDataAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
            .navigationTitle("Category Management")
        }
    }
}

#Preview {
    CategoryManagementView()
}
