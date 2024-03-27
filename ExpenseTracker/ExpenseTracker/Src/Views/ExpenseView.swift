//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @Binding var selectedTab: ExpenseViewType
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(getExpenseList()) { expense in
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
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.showFilteringPage.toggle()
                        }) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle" + (viewModel.isFiltered() ?  ".fill" : ""))
                        }
                        .popover(isPresented: $viewModel.showFilteringPage) {
                            FilteringView()
                                .environmentObject(viewModel)
                        }
                    }
                }
                if viewModel.viewType == ExpenseViewType.pendingExpenseView {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink {
                                ExpenseEditorView(viewModel: ExpenseEditorViewModel(), selectedTab: $selectedTab)
                            } label: {
                                PlusCircleView()
                            }
                            .padding()
                            .padding([.trailing, .bottom], 20)
                        }
                    }
                }
            }
        }
    }
    
    private func getExpenseList() -> [ExpenseData] {
        return viewModel.expenseData
    }
}

struct FilteringView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Filter By Date") {
                    Toggle("Filter By Date", isOn: $viewModel.isFilteredByDate)
                    
                    if viewModel.isFilteredByDate {
                        DatePicker("Start Date", selection: $viewModel.startDate)
                        DatePicker("End Date", selection: $viewModel.endDate)
                    }
                }
            }
            .onAppear(perform: {
                self.viewModel.initFilteredState()
            })
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
