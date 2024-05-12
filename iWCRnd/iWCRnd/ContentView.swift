//
//  ContentView.swift
//  iWCRnd
//
//  Created by Shahwat Hasnaine on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    var model = ViewModelPhone()
    @State var reachable = "No"
    
    var body: some View {
        VStack{
            Text("Reachable \(reachable)")
            
            Button {
                if self.model.session.isReachable {
                    self.reachable = "Yes"
                    print("Yeah, reachable now")
                } else {
                    self.reachable = "No"
                    print("Not reachable. Sorry")
                }
                
            } label: {
                Text("Update")
            }
            
            Button(action: {
                self.model.sendData(data: modelData(msg1: "Hi", msg2: "Has9"))
            }) {
                Text("Send Message")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
