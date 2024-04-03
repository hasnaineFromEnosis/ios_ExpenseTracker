//
//  CategoryManagementViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 30/3/24.
//

import UIKit

class CategoryManagementViewModel: ObservableObject {
    
    private let dataManager = DataManager.shared
    
    @Published var categoryTitle: String = ""
    
    @Published var showCreateCategoryPopup: Bool = false
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Name"
    @Published var alertMessage: String = "A category with same name is already exist. Please choose a different name"
    
    var toolbarPlusImageName: String = "plus"
    
    var categoryDataList: [CategoryData] {
        dataManager.categoryList
    }
    
    func createCategory() {
        for category in categoryDataList {
            if category.title == categoryTitle {
                showInvalidDataAlert = true
                return
            }
        }
        
        dataManager.createCategory(title: categoryTitle, isPredefined: false)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        dataManager.deleteCategory(categoryData: categoryData)
    }
    
    func clearState() {
        categoryTitle = ""
    }
}
