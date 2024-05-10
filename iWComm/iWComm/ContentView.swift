//
//  ContentView.swift
//  iWComm
//
//  Created by Shahwat Hasnaine on 10/5/24.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @StateObject var counter = Counter()
    
    var labelStyle: some LabelStyle {
        #if os(watchOS)
        return IconOnlyLabelStyle()
        #else
        return DefaultLabelStyle()
        #endif
    }
    
    var body: some View {
        VStack {
            Text("\(counter.count)")
                .font(.largeTitle)
            
            HStack {
                Button {
                    counter.decrement()
                } label: {
                    Label("Decrement", systemImage: "minus.circle")
                }
                .padding()
                
                Button {
                    counter.increment()
                } label: {
                    Label("Increment", systemImage: "plus.circle.fill")
                }
                .padding()
            }
            .font(.headline)
            .labelStyle(labelStyle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

