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
    @State var messageText = ""
    
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
            
            TextField("Input your message", text: $messageText)
            Button(action: {
                self.model.session.sendMessage(["message" : self.messageText], replyHandler: nil) { (error) in
                    print(error.localizedDescription)
                }
            }) {
                Text("Send Message")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
