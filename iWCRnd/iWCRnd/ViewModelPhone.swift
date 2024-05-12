//
//  ViewModelPhone.swift
//  iWCRnd
//
//  Created by Shahwat Hasnaine on 12/5/24.
//

import Foundation
import WatchConnectivity

class ViewModelPhone : NSObject,  WCSessionDelegate {
    
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
    
    
}
