//
//  ViewModelWatch.swift
//  iWCRndWatch Watch App
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import Foundation
import WatchConnectivity

class ViewModelWatch : NSObject,  WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var messageText: modelData = modelData(msg1: "No", msg2: "Message")
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageText = modelData.fromDict(dict: message) ?? modelData(msg1: "Invalid", msg2: "Message")
        }
    }

    
}
