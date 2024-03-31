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
        List {

        }
        .navigationTitle("Category Management")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Label("Add New Category", systemImage: viewModel.toolbarPlusImageName)
            }
        }
    }
}

#Preview {
    CategoryManagementView()
}
