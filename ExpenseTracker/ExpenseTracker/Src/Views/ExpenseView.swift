//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Binding var selectedTab: TabViewType
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.expenseData) { expense in
                    NavigationLink {
                        ExpenseDetailView(viewModel: ExpenseDetailViewModel(expenseData: expense), selectedTab: $selectedTab)
                    } label: {
                        ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: expense))
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteExpense(expenseData: expense)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .animation(.easeInOut)
                .navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        filterButton
                    }
                }
                if viewModel.viewType == .pendingExpenseView {
                    floatingButton
                }
            }
        }
    }
    
    private var filterButton: some View {
        Button(action: {
            viewModel.showFilteringPage.toggle()
        }) {
            Label("Filter", systemImage: viewModel.isFiltered()
                  ? "line.3.horizontal.decrease.circle.fill"
                  : "line.3.horizontal.decrease.circle")
        }
        .popover(isPresented: $viewModel.showFilteringPage) {
            FilteringView()
                .environmentObject(viewModel)
        }
    }
    
    private var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: ExpenseEditorView(viewModel: ExpenseEditorViewModel(), selectedTab: $selectedTab)) {
                    PlusCircleView()
                }
                .padding()
                .padding([.trailing, .bottom], 20)
            }
        }
    }
}

struct FilteringView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filter By Date")) {
                    Toggle("Enable Filtering", isOn: $viewModel.isFilteredByDate.animation())
                    
                    if viewModel.isFilteredByDate {
                        DatePicker("Start Date", selection: $viewModel.startDate)
                        DatePicker("End Date", selection: $viewModel.endDate)
                    }
                }
            }
            .onAppear {
                viewModel.initFilteredState()
            }
            .navigationTitle("Filtering")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.validateFilteringData() {
                            dismiss()
                        }
                    } label: {
                        Text("Done")
                    }
                }
            }
            .alert(isPresented: $viewModel.shouldShowAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
        }
    }
}

#Preview {
    FilteringView()
        .environmentObject(ExpenseViewModel(viewType: .paidExpenseView))
}

#Preview {
    ExpenseView(viewModel: ExpenseViewModel(viewType: .pendingExpenseView), selectedTab: .constant(.pendingExpenseView))
}
