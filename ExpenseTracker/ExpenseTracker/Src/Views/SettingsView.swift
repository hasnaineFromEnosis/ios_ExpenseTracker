//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 28/3/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    CategoryManagementView()
                } label: {
                    getPrimaryTextView(label: "Category Management")
                }
            }
            .navigationTitle("Settings")
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
