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
    
    static func getTypeFromValue(value: String) -> ExpenseType {
        return value == ExpenseType.random.rawValue ? .random : .recurrent
    }
}

enum TabViewType {
    case pendingExpenseView
    case paidExpenseView
    case settingsView
    case trendyView
}

enum DataSourceType: String {
    case iOS = "iOS"
    case watchOS = "WatchOS"
    case other = "other"
    
    static func getTypeFromValue(value: String?) -> DataSourceType? {
        guard let value = value else {
            return nil
        }
        if value == "iOS" {
            return .iOS
        } else if value == "WatchOS" {
            return .watchOS
        } else {
            return .other
        }
    }
}
