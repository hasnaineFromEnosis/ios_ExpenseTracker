//
//  PhoneConnectivityManager.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import Foundation

import Foundation
import WatchConnectivity

class PhoneConnectivityManager: NSObject,  WCSessionDelegate {
    var session: WCSession
    
    let dataManager = DataManager.shared
    
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
            if let data = ExpenseData.fromDict(dict: message) {
                if data.paidDate != nil {
                    self.dataManager.paidExpensesList.append(data)
                } else {
                    self.dataManager.pendingExpensesList.append(data)
                }
            }
        }
    }
}
