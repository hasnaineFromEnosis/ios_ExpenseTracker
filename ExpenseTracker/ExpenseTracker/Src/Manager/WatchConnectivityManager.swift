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
    
    var dataReceivedCallback: ((ExpenseData) -> Void)?
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let data = ExpenseData.fromDict(dict: message) {
                // send this data to dataManager createExpense method
                self.dataReceivedCallback?(data)
            }
        }
    }
    
    func sendData(data: ExpenseData) {
        self.session.sendMessage(data.toDict(), replyHandler: nil) { (error) in
            print("Error message: \(error.localizedDescription)")
        }
    }
}
