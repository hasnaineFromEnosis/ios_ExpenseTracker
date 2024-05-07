//
//  AddCategoryView.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 7/5/24.
//

import SwiftUI

struct AddCategoryView: View {
    @StateObject var viewModel: AddCategoryViewModel = AddCategoryViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Title", text: $viewModel.categoryTitle)
            Button("Save", action: {
                if viewModel.createCategory() {
                    viewModel.clearState()
                    dismiss()
                }
            })
        }
        .alert(isPresented: $viewModel.showInvalidDataAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage)
            )
        }
    }
}

#Preview {
    AddCategoryView(viewModel: AddCategoryViewModel())
}
