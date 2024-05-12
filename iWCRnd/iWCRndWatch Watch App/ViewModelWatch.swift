//
//  ViewModelWatch.swift
//  iWCRndWatch Watch App
//
//  Created by Shahwat Hasnaine on 13/5/24.
//

import Foundation
import WatchConnectivity

class ViewModelWatch : NSObject,  WCSessionDelegate{
    var session: WCSession
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
