//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 28/3/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    getPrimaryTextView(label:  "Hello")
                    getHighlightedTextView(label: "\(authViewModel.displayName)")
                }
                
                Section {
                    ForEach(viewModel.settingsDataList) { settingData in
                        NavigationLink(destination: settingData.listView) {
                            getPrimaryTextView(label: settingData.listName)
                        }
                    }
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        getPrimaryTextView(label: "Sign Out")
                    }
                }
            }
            .navigationTitle(viewModel.navtitle)
        }
    }
    
    private func getPrimaryTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.regular)
            .font(.headline)
            .foregroundStyle(.foreground)
    }
    
    private func getHighlightedTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.bold)
            .font(.headline)
            .foregroundStyle(.accent)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationViewModel())
}
