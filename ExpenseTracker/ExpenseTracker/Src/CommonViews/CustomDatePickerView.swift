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
        Picker("", selection: $month) {
            ForEach(1..<13) { i in
                Text(calendar.monthSymbols[i-1]).tag(i)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .foregroundColor(.black) // Text color
        .frame(width: 150) // Set width
        .padding(.horizontal, 10) // Adjust padding
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.yellow) // Background color
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Add shadow
        )
    }
}

struct YearPicker: View {
    @Binding var year: Int
    let startYear: Int = 2000
    let endYear: Int = 2030
    
    var body: some View {
        Picker("", selection: $year) {
            ForEach(startYear...endYear, id: \.self) { year in
                Text(String(year)).tag(year)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .foregroundColor(.black) // Text color
        .frame(width: 150) // Set width
        .padding(.horizontal, 10) // Adjust padding
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.yellow) // Background color
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Add shadow
        )
    }
}

#Preview {
    MonthPicker(month: .constant(5))
}

#Preview {
    YearPicker(year: .constant(2024))
}
