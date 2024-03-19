//
//  ExpenseData + Extension.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 20/3/24.
//

import SwiftUI

extension ExpenseData {
    func isExpensePending() -> Bool {
        return self.paidDate == nil
    }
}
