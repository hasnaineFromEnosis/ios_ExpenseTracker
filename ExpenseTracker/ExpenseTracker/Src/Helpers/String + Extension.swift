//
//  String + Extension.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 9/4/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" 
        return dateFormatter.date(from: self)
    }
}
