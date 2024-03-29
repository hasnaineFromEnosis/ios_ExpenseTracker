//
//  SettingsViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 30/3/24.
//

import SwiftUI

struct SettingsData: Identifiable {
    let id: UUID
    let listName: String
    let listView: AnyView
    
    init(listName: String, listView: AnyView) {
        self.id = UUID()
        self.listName = listName
        self.listView = listView
    }
}

class SettingsViewModel: ObservableObject {
    
    var settingsDataList: [SettingsData] = []
    var navtitle: String = "Settings"
    
    init() {
        generateData()
    }
    
    private func generateData() {
        settingsDataList.append(SettingsData(listName: "Category Management", listView: AnyView(CategoryManagementView())))
    }
}
