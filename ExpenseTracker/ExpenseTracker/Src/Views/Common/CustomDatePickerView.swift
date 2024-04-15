//
//  CustomDatePickerView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 3/4/24.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var month: Int
    @Environment(\.calendar) var calendar
    
    var body: some View {
        Picker("Month", selection: $month) {
            ForEach(calendar.monthSymbols, id: \.self) { monthName in
                Text(monthName)
                    .tag(calendar.monthSymbols.firstIndex(of: monthName)! + 1)
            }
        }
        .pickerStyle(.menu) // Use the default menu picker style
        .foregroundColor(.black)
        .frame(width: 150)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.yellow)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct YearPicker: View {
    @Binding var year: Int
    let startYear = 2000
    let endYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        Picker("Year", selection: $year) {
            ForEach(startYear...endYear, id: \.self) { year in
                Text(String(year))
            }
        }
        .pickerStyle(.menu) // Use the default menu picker style
        .foregroundColor(.black)
        .frame(width: 150)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.yellow)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    MonthPicker(month: .constant(5))
}

#Preview {
    YearPicker(year: .constant(2024))
}
