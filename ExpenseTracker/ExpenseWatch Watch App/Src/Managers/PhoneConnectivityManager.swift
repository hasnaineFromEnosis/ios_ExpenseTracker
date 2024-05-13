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
    
    var createExpenseCallback: ((ExpenseData) -> Void)?
    var createCategoryCallback: ((CategoryData) -> Void)?
    
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
                self.createExpenseCallback?(data)
            } else if let data = CategoryData.fromDict(dict: message) {
                self.createCategoryCallback?(data)
            }
        }
    }
    
    func sendData(data: [String : Any]) {
        self.session.sendMessage(data, replyHandler: nil) { (error) in
            print("Error message: \(error.localizedDescription)")
        }
    }
}
