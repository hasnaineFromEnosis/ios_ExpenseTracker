//
//  ContentView.swift
//  iWCRndWatch Watch App
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModelWatch()
    var body: some View {
        Text("Hello, World!")
        Text(self.model.messageText)
    }
}

#Preview {
    ContentView()
}
