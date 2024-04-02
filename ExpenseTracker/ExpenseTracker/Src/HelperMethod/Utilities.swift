//
//  Utilities.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 3/4/24.
//

import Foundation

struct Utilities {
    static func getDataFromDate(component: Calendar.Component, date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: date)
    }
}
