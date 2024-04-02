//
//  TrendView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI

struct TrendView: View {
    @State private var selectedMonth = 1
    @State private var selectedYear = 2022
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                MonthPicker(month: $selectedMonth)
                YearPicker(year: $selectedYear)
            }
            Spacer()
        }
    }
}


#Preview {
    TrendView()
}
