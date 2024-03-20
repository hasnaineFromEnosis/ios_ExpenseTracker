//
//  PlusCircleView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 21/3/24.
//

import SwiftUI

struct PlusCircleView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.7))
            Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.foreground)
                
        }
        .frame(width: 60)
    }
}

#Preview {
    PlusCircleView()
}
