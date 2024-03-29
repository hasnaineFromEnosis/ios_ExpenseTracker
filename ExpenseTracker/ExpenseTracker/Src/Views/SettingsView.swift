//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 28/3/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.settingsDataList) { settingData in
                NavigationLink {
                    settingData.listView
                } label: {
                    getPrimaryTextView(label: settingData.listName)
                }
            }
            .navigationTitle(viewModel.navtitle)
        }
    }
    
    private func getPrimaryTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.regular)
            .font(.headline)
            .foregroundStyle(.accent)
    }
}

#Preview {
    SettingsView()
}
