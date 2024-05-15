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
    
    static func getCurrentSource() -> DataSourceType {
#if os(iOS)
        return DataSourceType.iOS
#elseif os(watchOS)
        return DataSourceType.watchOS
#endif
        return DataSourceType.other
    }
}

enum WCOperationType: String {
    case create = "create"
    case update = "update"
    case delete = "delete"
    
    static func getTypeFromValue(value: String?) -> WCOperationType? {
        guard let value = value else {
            return nil
        }
        
        if value == "create" {
            return .create
        } else if value == "update" {
            return .update
        } else if value == "delete" {
            return .delete
        }
        
        return nil
    }
}
