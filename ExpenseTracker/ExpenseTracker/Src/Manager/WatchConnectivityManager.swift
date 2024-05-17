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
    
    var expenseOperationCallback: ((ExpenseData, WCOperationType) -> Void)?
    var categoryOperationCallback: ((CategoryData, WCOperationType) -> Void)?
    var syncDataCallBack: ((Date) -> Void)?
    
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
            guard let operationType = WCOperationType.getTypeFromValue(value: message["operationType"] as? String) else {
                return
            }
            
            if operationType == .synchronize,
               let lastSyncTime = message[Const.lastSynchronizeKey] as? Date {
                self.syncDataCallBack?(lastSyncTime)
            }
            
            if let data = ExpenseData.fromDict(dict: message) {
                self.expenseOperationCallback?(data, operationType)
            } else if let data = CategoryData.fromDict(dict: message) {
                self.categoryOperationCallback?(data, operationType)
            }
        }
    }
    
    func sendData(data: [String:Any], operationType: WCOperationType) {
        var modifiedData = data
        modifiedData["operationType"] = operationType.rawValue
        
        if self.session.isReachable {
            self.session.sendMessage(modifiedData, replyHandler: nil) { (error) in
                print("Error message: \(error.localizedDescription)")
            }
        } else {
            self.session.transferUserInfo(modifiedData)
        }
    }
}
