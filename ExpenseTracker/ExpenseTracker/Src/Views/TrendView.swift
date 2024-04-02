//
//  TrendView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 2/4/24.
//

import SwiftUI

struct TrendView: View {
    @StateObject var viewModel = TrendViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    MonthPicker(month: $viewModel.selectedMonth)
                    YearPicker(year: $viewModel.selectedYear)
                }
                Spacer()
                
                BarChartView(chartTitle: viewModel.barChartTitle, barChartData: viewModel.barChartData)
                
                Spacer()
            }
            .navigationTitle(viewModel.navTitle)
        }
    }
}

#Preview {
    TrendView()
}
