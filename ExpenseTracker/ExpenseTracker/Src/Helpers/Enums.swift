//
//  Enums.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 10/4/24.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum ExpenseType: String, CaseIterable {
    case random = "Random"
    case recurrent = "Recurrent"
}

enum TabViewType {
    case pendingExpenseView
    case paidExpenseView
    case settingsView
    case trendyView
}
