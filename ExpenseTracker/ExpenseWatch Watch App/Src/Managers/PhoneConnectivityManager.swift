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
    
    var expenseOperationCallback: ((ExpenseData, WCOperationType) -> Void)?
    var categoryOperationCallback: ((CategoryData, WCOperationType) -> Void)?
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        let lastSyncTime = getLastSyncTime()
        let dict: [String: Date] = [Const.lastSynchronizeKey: lastSyncTime]
        
        if session.isReachable {
            sendData(data: dict, operationType: .synchronize)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        updateSyncTime()
        DispatchQueue.main.async {
            guard let operationType = WCOperationType.getTypeFromValue(value: message["operationType"] as? String) else {
                return
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
        updateSyncTime()
        
        self.session.sendMessage(modifiedData, replyHandler: nil) { (error) in
            print("Error message: \(error.localizedDescription)")
        }
    }
    
    private func updateSyncTime() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: Const.lastSynchronizeKey)
    }
    
    private func getLastSyncTime() -> Date {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: Const.lastSynchronizeKey) as? Date ?? Date.distantPast
    }
}
