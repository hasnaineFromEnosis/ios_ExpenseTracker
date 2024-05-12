//
//  WatchConnectivityManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject,  WCSessionDelegate {
    
    var session: WCSession
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sendData(data: ExpenseData) {
        self.session.sendMessage(data.toDict(), replyHandler: nil) { (error) in
            print("Error message: \(error.localizedDescription)")
        }
    }
}
