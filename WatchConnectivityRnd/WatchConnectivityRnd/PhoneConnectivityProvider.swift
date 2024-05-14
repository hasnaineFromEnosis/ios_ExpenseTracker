//
//  PhoneConnectivityProvider.swift
//  WatchConnectivityRnd
//
//  Created by Shahwat Hasnaine on 12/5/24.
//

import Foundation
import WatchConnectivity
import CoreData
import os

final class PhoneConnectivityProvider: NSObject, WCSessionDelegate {
    private let persistentContainer: NSPersistentContainer
    private let session: WCSession
    
    init(session: WCSession = .default, persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.session = session
        super.init()
        session.delegate = self
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            os_log(.debug, log: .watch, "watch session is not supported")
            return
        }
        os_log(.debug, log: .watch, "activating watch session")
        session.activate()
    }
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        os_log(.debug,
                   log: .watch,
                   "did finish activating session %lu (error: %s)",
                   activationState == .activated,
                   error?.localizedDescription ?? "none")
    }
}
