//
//  CategoryManagementViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 30/3/24.
//

import UIKit

class CategoryManagementViewModel: ObservableObject {
    
    var toolbarPlusImageName: String = "plus"
    @Published var showAlert: Bool = false
    
    @Published var categoryTitle: String = ""
    
    private let dataManager = DataManager.shared
    
    var categoryDataList: [CategoryData] {
        dataManager.categoryList
    }
    
    func createCategory() {
        dataManager.createCategory(title: categoryTitle)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        dataManager.deleteCategory(categoryData: categoryData)
    }
    
    func clearState() {
        categoryTitle = ""
    }
}
