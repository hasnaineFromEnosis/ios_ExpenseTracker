//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ExpenseView: View {
    private var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    var body: some View {
        self.color
    }
    
}

#Preview {
    ExpenseView(color: Color.green)
}
